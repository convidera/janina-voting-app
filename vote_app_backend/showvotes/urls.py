from django.urls import path

from . import views

app_name = 'show-votes'
urlpatterns = [
    path('<int:pk>/results/', views.ResultsView.as_view(), name='results'),
]
