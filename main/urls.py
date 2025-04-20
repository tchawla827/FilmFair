from django.contrib import admin
from django.urls import path,include
from . import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns=[
    path('',views.index,name='index'),
    path('movies/<int:id>',views.movies,name='movies'),
    path('seat/<int:id>',views.seat,name='seat'),
    path('booked',views.booked,name='booked'),
    path('ticket/<int:id>',views.ticket,name='ticket'),
    path('booked_ticket/<int:pk>/', views.booked_ticket, name='booked_ticket'),
    #for payment
    path('checkout/',      views.checkout_page,          name='checkout_page'),
    path('create-session/', views.create_checkout_session, name='create_checkout_session'),
    path('success/',       views.checkout_success,       name='checkout_success'),
    path('cancel/',        views.checkout_cancel,        name='checkout_cancel'),

]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

