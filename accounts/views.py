from socket import IP_TTL
from django.shortcuts import get_object_or_404, render, redirect
from django.utils import timezone
from django.contrib import messages
from django.contrib.auth import authenticate, login as auth_login, update_session_auth_hash
from django.contrib.auth.models import User
from django.contrib import auth
from django.core.mail import send_mail
from django.conf import settings
from datetime import timedelta
import random

from .models import Cinema, EmailOTP, Bookings, Shows, Movie
from django.db.models import Sum


# ------------- helpers -------------------------------------------------- #

def send_otp(email):
    """
    Generate a 6-digit OTP, save or update it in EmailOTP,
    and send it via email. Returns the OTP record's UUID.
    """
    code = f"{random.randint(0, 999999):06}"
    otp, _ = EmailOTP.objects.update_or_create(
        email=email,
        defaults={"code": code, "created_at": timezone.now()}
    )
    send_mail(
        "Your BoxOffice OTP",
        f"Enter this code to complete your registration: {code}",
        settings.DEFAULT_FROM_EMAIL,
        [email],
    )
    return otp.uuid


# ------------- auth ----------------------------------------------------- #

def login(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(username=username, password=password)

        if user is not None:
            auth_login(request, user)
            return redirect("/")
        messages.error(request, "Username / Password is incorrect")
        return redirect("login")

    return render(request, "login.html")


def register(request):
    # phase-1  → user submits details → send OTP
    if request.method == "POST" and "verify_uuid" not in request.POST:
        verify_uuid = send_otp(request.POST["email"])
        return render(
            request,
            "verify_otp.html",
            {
                "email": request.POST["email"],
                "verify_uuid": verify_uuid,
                "is_cinema": False,
                "form_data": request.POST,
            },
        )

    # phase-2 → user submits OTP → verify & create account
    if request.method == "POST" and request.POST.get("verify_uuid"):
        otp_entry = get_object_or_404(
            EmailOTP,
            uuid=request.POST["verify_uuid"],
            email=request.POST["email"],
        )

        if timezone.now() - otp_entry.created_at > timedelta(minutes=5):
            otp_entry.delete()
            messages.error(request, "OTP expired – please try again.")
            return redirect("register")

        if otp_entry.code == request.POST["otp_code"]:
            user = User.objects.create_user(
                username=request.POST["username"],
                first_name=request.POST["firstname"],
                last_name=request.POST["lastname"],
                email=request.POST["email"],
                password=request.POST["password1"],
            )
            auth_login(request, user)
            otp_entry.delete()
            return redirect("/")

        # wrong code
        return render(
            request,
            "verify_otp.html",
            {
                "email": request.POST["email"],
                "verify_uuid": request.POST["verify_uuid"],
                "error": "Wrong code, try again.",
                "is_cinema": False,
                "form_data": request.POST,
            },
        )

    # GET
    return render(request, "register.html")


def register_cinema(request):
    # phase-1 → user submits details → send OTP
    if request.method == "POST" and "verify_uuid" not in request.POST:
        verify_uuid = send_otp(request.POST["email"])
        return render(
            request,
            "verify_otp.html",
            {
                "email": request.POST["email"],
                "verify_uuid": verify_uuid,
                "is_cinema": True,
                "form_data": request.POST,
            },
        )

    # phase-2 → user submits OTP → verify & create account
    if request.method == "POST" and request.POST.get("verify_uuid"):
        otp_entry = get_object_or_404(
            EmailOTP,
            uuid=request.POST["verify_uuid"],
            email=request.POST["email"],
        )

        if timezone.now() - otp_entry.created_at > timedelta(minutes=5):
            otp_entry.delete()
            messages.error(request, "OTP expired – please try again.")
            return redirect("register_cinema")

        if otp_entry.code == request.POST["otp_code"]:
            user = User.objects.create_user(
                username=request.POST["username"],
                first_name=request.POST["firstname"],
                last_name=request.POST["lastname"],
                email=request.POST["email"],
                password=request.POST["password1"],
            )
            Cinema.objects.create(
                cinema_name=request.POST["cinema"],
                phoneno=request.POST["phone"],
                city=request.POST["city"],
                address=request.POST["address"],
                user=user,
            )
            auth_login(request, user)
            otp_entry.delete()
            return redirect("dashboard")

        # wrong code
        return render(
            request,
            "verify_otp.html",
            {
                "email": request.POST["email"],
                "verify_uuid": request.POST["verify_uuid"],
                "error": "Wrong code, try again.",
                "is_cinema": True,
                "form_data": request.POST,
            },
        )

    # GET
    return render(request, "register_cinema.html")


def logout(request):
    auth.logout(request)
    return redirect("/")


# ------------- profile & user settings --------------------------------- #

def profile(request):
    u = request.user
    if request.method == "POST":
        username = request.POST["username"]
        first_name = request.POST["fn"]
        last_name = request.POST["ln"]
        email = request.POST["email"]
        old = request.POST["old"]
        new = request.POST["new"]
        user = User.objects.get(pk=u.pk)

        if User.objects.filter(username=username).exclude(pk=u.pk).exists():
            messages.error(request, "Username already exists")

        elif User.objects.filter(email=email).exclude(pk=u.pk).exists():
            messages.error(request, "Email already exists")

        elif user.check_password(old):
            user.username = username
            user.first_name = first_name
            user.last_name = last_name
            user.email = email
            user.set_password(new)
            user.save()
            update_session_auth_hash(request, user)  # keep user logged-in
            messages.success(request, "Profile updated")
        else:
            messages.error(request, "Wrong Old Password")

        return redirect("profile")

    return render(request, "profile.html")


# ------------- **FIXED** bookings list --------------------------------- #

def bookings(request):
    """
    List of bookings for the logged-in user.

    We attach a ``total_price`` attribute to every ``Bookings`` instance
    so the template can directly print the correct amount (unit-price × seat-count).
    """
    user = request.user
    bookings_qs = (
        Bookings.objects.filter(user=user.pk)
        .select_related("shows", "shows__movie", "shows__cinema")
        .order_by("-pk")
    )

    for b in bookings_qs:
        seats = [s for s in b.useat.split(",") if s]
        b.total_price = len(seats) * b.shows.price

    return render(request, "bookings.html", {"book": bookings_qs})


# ------------- cinema dashboard & earnings ----------------------------- #

def dashboard(request):
    user = request.user
    m = (
        Shows.objects.filter(cinema=user.cinema)
        .values("movie", "movie__movie_name", "movie__movie_poster")
        .distinct()
    )
    return render(request, "dashboard.html", {"list": m})


def earnings(request):
    user = request.user
    d = Bookings.objects.filter(shows__cinema=user.cinema)
    total = Bookings.objects.filter(shows__cinema=user.cinema).aggregate(
        Sum("shows__price")
    )
    return render(request, "earnings.html", {"s": d, "total": total})


# ------------- add shows ------------------------------------------------ #

def add_shows(request):
    user = request.user

    if request.method == "POST":
        m = request.POST["m"]
        t = request.POST["t"]
        d = request.POST["d"]
        p = request.POST["p"]
        i = user.cinema.pk

        show = Shows(cinema_id=i, movie_id=m, date=d, time=t, price=p)
        show.save()
        messages.success(request, "Show Added")
        return redirect("add_shows")

    m = Movie.objects.all()
    sh = Shows.objects.filter(cinema=user.cinema)
    return render(request, "add_shows.html", {"mov": m, "s": sh})