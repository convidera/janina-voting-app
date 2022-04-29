import pytest
import os


@pytest.fixture(scope='session')
def csrf_setup(entryp_setup):
    return entryp_setup + str(os.environ.get('URI_CSRF_PATH'))

@pytest.fixture(scope='session')
def entryp_setup():
    return "/" + str(os.environ.get('URI_ENTRYP_PATH'))
