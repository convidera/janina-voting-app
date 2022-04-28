import pytest
from django.test import RequestFactory

from django.db import models
from django.test import Client
from showvotes.views import setFECookie

from . import conftest


@pytest.mark.django_db
def test_csrf_token_exists(csrf_setup):
    # c = Client(HTTP_X_CSRFTOKEN='')
    # response = c.get(csrf_setup)

    factory = RequestFactory()
    default_xsrf_header = {"HTTP_X_CSRFTOKEN":""}
    request = factory.get(csrf_setup, **default_xsrf_header)
    request.COOKIES['csrftoken'] = ''
    response = setFECookie(request)
    print(response.items())
    assert response.status_code == 200
    #assert response.has_header('Content-Type') == 204
    


@pytest.mark.skip
def test_user_can_vote(self, entryp_setup):
    #get csrf token
    c = Client(enforce_csrf_checks=True)
    response = self.client.post(entryp_setup)
    assert response.status_code == 200

    #create post request to api endpoint
    testuser = models.Username.objects.create(username_text='test')
    testuser.save()