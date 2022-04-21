from django.urls import path
#from pathlib import Path

from . import views
import os
from dotenv import load_dotenv

load_dotenv()


# Build paths inside the project like this: BASE_DIR / 'subdir'.
#BASE_DIR = Path(__file__).resolve().parent.parent



urlpatterns = [
    path('', views.handleVotes, name='handleVotes'),
    path(str(os.getenv('URI_CSRF_PATH')), views.setFECookie, name='setFECookie'),
    #path('get-csrf', views.setFECookie, name='setFECookie'),
    path(str(os.getenv('URI_TEST_PATH')), views.ping, name='ping')
    #path('ping', views.ping, name='ping')
]
