from django.shortcuts import get_object_or_404, render
from django.urls import reverse
from accounts.models import *
from django.http import HttpResponseRedirect
# Create your views here.


def index(request):
    movies = Movie.objects.all()
    context = {
        'mov': movies
    }
    return render(request,"index.html", context)

def movies(request, id):
    #cin = Cinema.objects.filter(shows__movie=id).distinct()
    movies = Movie.objects.get(movie=id)
    cin = Cinema.objects.filter(cinema_show__movie=movies).prefetch_related('cinema_show').distinct()  # get all cinema
    show = Shows.objects.filter(movie=id)
    context = {
        'movies':movies,
        'show':show,
        'cin':cin,
    }
    return render(request, "movies.html", context )

def seat(request, id):
    show = Shows.objects.get(shows=id)
    seat = Bookings.objects.filter(shows=id)
    return render(request,"seat.html", {'show':show, 'seat':seat})    

def booked(request):
    if request.method == 'POST':
        user = request.user
        seat = ','.join(request.POST.getlist('check'))
        show = request.POST['show']
        book = Bookings(useat=seat, shows_id=show, user=user)
        book.save()
        return render(request,"booked.html", {'book':book})    
        

def ticket(request, id):
    ticket = Bookings.objects.get(id=id)
    print(ticket.shows.price)
    return render(request,"ticket.html", {'ticket':ticket})


#for payment

# … your existing checkout_page and create_checkout_session …

def checkout_success(request):
    ticket_id = request.GET.get('ticket_id')
    # mark as paid, send email, etc.
    return render(request, 'success.html', {'ticket_id': ticket_id})



def checkout_cancel(request):
    """Renders the cancel.html template if the customer cancels."""
    return render(request, 'cancel.html')


from django.shortcuts import render, redirect
import stripe
from django.conf import settings

stripe.api_key = settings.STRIPE_SECRET_KEY

def checkout_page(request):
    return render(request, 'checkout.html')


def create_checkout_session(request):
    if request.method != 'POST':
        return redirect('index')

    ticket_id = request.POST.get('ticket_id')
    ticket = get_object_or_404(Bookings, pk=ticket_id)
    price = int(ticket.shows.price * 100)   # Stripe wants amount in smallest currency unit

    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'inr',
                    'product_data': {
                        'name': f"Ticket #{ticket.pk} — {ticket.shows.movie.movie_name}",
                    },
                    'unit_amount': price,
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url=request.build_absolute_uri(
                reverse('checkout_success') + f"?ticket_id={ticket.pk}"
            ),
            cancel_url=request.build_absolute_uri(
                reverse('checkout_cancel')
            ),
        )
        return redirect(session.url, code=303)

    except Exception as e:
        return render(request, 'error.html', {'message': str(e)})