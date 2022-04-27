import pytest
import os
from django.core.management import call_command


@pytest.fixture(scope='session')
def django_db_setup(django_db_blocker):
    settings.DATABASES['test_db'] = {
        'ENGINE': 'django.db.backends.mysql',
        'HOST': 'vote-app-mysql',
        'NAME': 'testingdb',
        'PORT': '3306',
        'USER': 'testing',
        'PASSWORD': os.environ.get('DATABASE_PASS_TEST'),
    }
    with django_db_blocker.unblock():
        call_command('loaddata', 'test_data.json')
