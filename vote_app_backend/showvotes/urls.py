from django.urls import path

from . import views

urlpatterns = [
    path('', views.handleVotes, name='handleVotes'),
    path('get-csrf', views.setFECookie, name='setFECookie'),
]
