from django.urls import path


from . import views
import os





urlpatterns = [
    path('', views.handleVotes, name='handleVotes'),
    path(str(os.environ.get('URI_CSRF_PATH')), views.setFECookie, name='setFECookie'),
]
