import io
import stripe
from xhtml2pdf import pisa              # NEW
from django.conf import settings
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render, redirect, get_object_or_404
from django.template.loader import get_template
from django.urls import reverse

from accounts.models import *           # Movie, Shows, Bookings, …

stripe.api_key = settings.STRIPE_SECRET_KEY


# ---------------------------------------------------------------------------
#  Helpers
# ---------------------------------------------------------------------------
def _seat_price(ticket: 'Bookings') -> int:
    seat_count = len(ticket.useat.split(',')) if ticket.useat else 0
    return seat_count * ticket.shows.price


def _render_pdf(template_src: str, context: dict) -> HttpResponse:
    """
    Render a Django template to PDF using xhtml2pdf (pisa).
    """
    template = get_template(template_src)
    html     = template.render(context)
    result   = io.BytesIO()
    pisa_status = pisa.CreatePDF(io.BytesIO(html.encode('utf-8')), dest=result)
    if pisa_status.err:
        return HttpResponse('PDF generation error', status=500)
    response = HttpResponse(result.getvalue(), content_type='application/pdf')
    return response


# ---------------------------------------------------------------------------
#  Existing views (unchanged except for helper usage)
# ---------------------------------------------------------------------------
def index(request):
    movies = Movie.objects.all()
    return render(request, "index.html", {'mov': movies})


def movies(request, id):
    movies = Movie.objects.get(movie=id)
    cin    = Cinema.objects.filter(cinema_show__movie=movies) \
                           .prefetch_related('cinema_show').distinct()
    show   = Shows.objects.filter(movie=id)
    return render(request, "movies.html", {'movies': movies, 'show': show, 'cin': cin})


def seat(request, id):
    show = Shows.objects.get(shows=id)
    seat = Bookings.objects.filter(shows=id)
    return render(request, "seat.html", {'show': show, 'seat': seat})


def booked(request):
    if request.method == 'POST':
        book = Bookings.objects.create(
            useat=','.join(request.POST.getlist('check')),
            shows_id=request.POST['show'],
            user=request.user,
        )
        return render(request, "booked.html", {'book': book})


def ticket(request, id):
    ticket = Bookings.objects.get(pk=id)
    total  = _seat_price(ticket)
    return render(request, "ticket.html", {'ticket': ticket, 'total_price': total})


def booked_ticket(request, pk):
    ticket = get_object_or_404(Bookings, pk=pk)
    total  = _seat_price(ticket)
    return render(request, "booked_ticket.html", {'ticket': ticket, 'total_price': total})


# ---------------------------------------------------------------------------
#  Stripe checkout (unchanged)
# ---------------------------------------------------------------------------
def checkout_page(request):
    return render(request, 'checkout.html')


def create_checkout_session(request):
    if request.method != 'POST':
        return redirect('index')

    ticket = get_object_or_404(Bookings, pk=request.POST.get('ticket_id'))
    total  = _seat_price(ticket)

    session = stripe.checkout.Session.create(
        payment_method_types=['card'],
        line_items=[{
            'price_data': {
                'currency': 'inr',
                'product_data': {
                    'name': f"Ticket #{ticket.pk} — {ticket.shows.movie.movie_name}",
                },
                'unit_amount': int(total * 100),
            },
            'quantity': 1,
        }],
        mode='payment',
        success_url=request.build_absolute_uri(
            reverse('checkout_success') + f"?ticket_id={ticket.pk}"
        ),
        cancel_url=request.build_absolute_uri(reverse('checkout_cancel')),
    )
    return redirect(session.url, code=303)


def checkout_success(request):
    ticket_id = request.GET.get('ticket_id')
    return render(request, 'success.html', {'ticket_id': ticket_id})


def checkout_cancel(request):
    return render(request, 'cancel.html')


# ---------------------------------------------------------------------------
#  NEW  Invoice / print views
# ---------------------------------------------------------------------------
def invoice_view(request, id):
    """HTML view optimised for printing (`Ctrl+P`)."""
    ticket = get_object_or_404(Bookings, pk=id)
    total  = _seat_price(ticket)
    ctx    = {'ticket': ticket, 'total_price': total}
    return render(request, 'invoice.html', ctx)


def invoice_pdf(request, id):
    """Downloadable PDF version of the same invoice."""
    ticket = get_object_or_404(Bookings, pk=id)
    total  = _seat_price(ticket)
    ctx    = {'ticket': ticket, 'total_price': total}
    pdf    = _render_pdf('invoice.html', ctx)
    pdf['Content-Disposition'] = f'attachment; filename="invoice_{ticket.pk}.pdf"'
    return pdf
