from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.http import HttpResponseRedirect
from accounts.models import *
import stripe
from django.conf import settings

stripe.api_key = settings.STRIPE_SECRET_KEY

# Home page
def index(request):
    movies = Movie.objects.all()
    context = {
        'mov': movies
    }
    return render(request, "index.html", context)

# Movie details and available shows
def movies(request, id):
    movies = Movie.objects.get(movie=id)
    cin = Cinema.objects.filter(cinema_show__movie=movies).prefetch_related('cinema_show').distinct()
    show = Shows.objects.filter(movie=id)
    context = {
        'movies': movies,
        'show': show,
        'cin': cin,
    }
    return render(request, "movies.html", context)

# Show seats view
def seat(request, id):
    show = Shows.objects.get(shows=id)
    seat = Bookings.objects.filter(shows=id)
    return render(request, "seat.html", {'show': show, 'seat': seat})

# After booking is confirmed
def booked(request):
    if request.method == 'POST':
        user = request.user
        seat = ','.join(request.POST.getlist('check'))
        show = request.POST['show']
        book = Bookings(useat=seat, shows_id=show, user=user)
        book.save()
        return render(request, "booked.html", {'book': book})

# Ticket view — FIXED to show total price
def ticket(request, id):
    ticket = Bookings.objects.get(id=id)
    seat_list = ticket.useat.split(',') if ticket.useat else []
    seat_count = len(seat_list)
    total_price = seat_count * ticket.shows.price
    return render(request, "ticket.html", {
        'ticket': ticket,
        'total_price': total_price
    })

# Alternate ticket view
def booked_ticket(request, pk):
    ticket = get_object_or_404(Bookings, pk=pk)
    return render(request, 'booked_ticket.html', {'ticket': ticket})

# Stripe Checkout integration
def checkout_page(request):
    return render(request, 'checkout.html')

# Create Stripe checkout session — FIXED to charge based on seat count
def create_checkout_session(request):
    if request.method != 'POST':
        return redirect('index')

    ticket_id = request.POST.get('ticket_id')
    ticket = get_object_or_404(Bookings, pk=ticket_id)

    seat_list = ticket.useat.split(',') if ticket.useat else []
    seat_count = len(seat_list)
    total_price = seat_count * ticket.shows.price

    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'inr',
                    'product_data': {
                        'name': f"Ticket #{ticket.pk} — {ticket.shows.movie.movie_name}",
                    },
                    'unit_amount': int(total_price * 100),  # in paise
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

# Payment success
def checkout_success(request):
    ticket_id = request.GET.get('ticket_id')
    return render(request, 'success.html', {'ticket_id': ticket_id})

# Payment cancel
def checkout_cancel(request):
    return render(request, 'cancel.html')
