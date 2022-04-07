from django.urls import path

from . import views

app_name = 'showvotes'

urlpatterns = [
    path('', views.index, name='index'),
]
