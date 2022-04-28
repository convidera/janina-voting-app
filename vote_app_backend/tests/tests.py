import pytest

from django.db import models

@pytest.mark.django_db
def test_csrf_token_exists(self, csrf_setup):
    response = self.client.get(csrf_setup)
    assert response.status_code == 204


@pytest.mark.skip
def test_user_can_vote(self, entryp_setup):
    response = self.client.post(entryp_setup)
    assert response.status_code == 200

    #create post request to api endpoint
    testuser = models.Username.objects.create(username_text='test')
    testuser.save()