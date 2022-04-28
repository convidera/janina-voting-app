import pytest
from django.core.management import call_command
import os



""" @pytest.fixture(scope='session')
def django_db_setup(django_db_blocker):
    with django_db_blocker.unblock():
        call_command('loaddata', 'test_data.json')
""" 

@pytest.fixture(scope='session')
def csrf_setup(entryp_setup):
    return entryp_setup + str(os.environ.get('URI_CSRF_PATH'))

@pytest.fixture(scope='session')
def entryp_setup():
    return "/" + str(os.environ.get('URI_ENTRYP_PATH'))
