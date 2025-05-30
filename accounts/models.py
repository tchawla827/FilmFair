# FILMFAIR/accounts/models.py

from django.db import models
from django.contrib.auth.models import User
from urllib.parse import urlparse, parse_qs
from django.utils import timezone
import uuid

class Cinema(models.Model):
    cinema         = models.AutoField(primary_key=True)
    role           = models.CharField(max_length=30, default='cinema_manager')
    cinema_name    = models.CharField(max_length=50)
    phoneno        = models.CharField(max_length=15)
    city           = models.CharField(max_length=100)
    address        = models.CharField(max_length=100)
    user           = models.OneToOneField(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.cinema_name

class EmailOTP(models.Model):
    """
    Temporarily holds an OTP for a given email.
    """
    email      = models.EmailField()
    code       = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    uuid       = models.UUIDField(default=uuid.uuid4, unique=True)

    def __str__(self):
        return f"{self.email} – {self.code}"

class Movie(models.Model):
    movie         = models.AutoField(primary_key=True)
    movie_name    = models.CharField(max_length=50)
    movie_trailer = models.CharField(max_length=300, default="")
    movie_rdate   = models.CharField(max_length=20, default="null")
    movie_des     = models.TextField()
    movie_rating  = models.DecimalField(max_digits=3, decimal_places=1)
    movie_poster  = models.ImageField(upload_to='movies/poster', default="movies/poster/not.jpg")
    movie_genre   = models.CharField(max_length=50, default="Action | Comedy | Romance")
    movie_duration= models.CharField(max_length=10, default="2hr 45min")

    def __str__(self):
        return self.movie_name

    @property
    def trailer_embed_url(self):
        """
        Parses the stored YouTube watch URL and returns an embeddable iframe URL.
        """
        query = urlparse(self.movie_trailer).query
        vid   = parse_qs(query).get('v', [''])[0]
        if not vid:
            return ''
        return f'https://www.youtube-nocookie.com/embed/{vid}?rel=0&autoplay=0'

class Shows(models.Model):
    shows    = models.AutoField(primary_key=True)
    cinema   = models.ForeignKey('Cinema', on_delete=models.CASCADE, related_name='cinema_show')
    movie    = models.ForeignKey('Movie',  on_delete=models.CASCADE, related_name='movie_show')
    time     = models.CharField(max_length=100)
    date     = models.CharField(max_length=15, default="")
    price    = models.IntegerField()

    def __str__(self):
        return f"{self.cinema.cinema_name} | {self.movie.movie_name} | {self.time}"

class Bookings(models.Model):
    user                    = models.ForeignKey(User,  on_delete=models.CASCADE)
    shows                   = models.ForeignKey(Shows, on_delete=models.CASCADE)
    useat                   = models.CharField(max_length=100)
    # —— new fields to track Stripe payment —— #
    stripe_session_id       = models.CharField(max_length=255, blank=True, null=True)
    stripe_payment_intent   = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f"{self.user.username} | {self.shows.movie.movie_name} | {self.useat}"

    @property
    def useat_as_list(self):
        return self.useat.split(',')
