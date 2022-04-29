import pytest
import json
from showvotes.models import Choice, Username
from django.test import Client
from django.http import JsonResponse


@pytest.fixture
def create_test_users():
    userdata_dict1  = {
        'username': 'test123',
        'progrLang': 'cpp'
    }
    userdata_dict2  = {
        'username': 'Loewenzahn',
        'progrLang': 'cpp'
    }
    userdata_dict3  = {
        'username': 'mary_poppins',
        'progrLang': 'ruby'
    }
    userdata_dict4  = {
        'username': 'mary_poppins',
        'progrLang': 'c'
    }
    user_data_lst = [ userdata_dict1, userdata_dict2, userdata_dict3, userdata_dict4 ]
    return user_data_lst


def test_csrf_token_exists(csrf_setup):
    c = Client()
    response = c.get(csrf_setup)
    #print(response.items())
    assert response.status_code == 204
    

#@pytest.mark.skip
@pytest.mark.django_db
def test_user_can_vote(entryp_setup, create_test_users):
    c = Client()
    data1 = create_test_users[0]
    data2 = create_test_users[1]
    data3 = create_test_users[2]

    #Check if vote indicators are zero
    zero_sel = Choice.objects.filter(choice_text=data1['progrLang']).count()
    assert zero_sel == 0
    zero_total = Username.objects.all().count()
    assert zero_total == 0

    #Send request with data1
    resp1 = c.post(entryp_setup, json.dumps(data1), content_type="application/json")
    assert resp1.status_code == 200
    
    resp_data1 = json.loads(resp1.content)
    assert data1['username'] == resp_data1['username']
    assert data1['progrLang'] == resp_data1['progrLang']
    assert resp_data1['votes'] == 1

    #Send request with data2
    resp2 = c.post(entryp_setup, json.dumps(data2), content_type="application/json")
    assert resp2.status_code == 200
    
    resp_data2 = json.loads(resp2.content)
    assert data2['username'] == resp_data2['username']
    assert data2['progrLang'] == resp_data2['progrLang']
    assert resp_data2['votes'] == 2

    #Send request with data3
    resp3 = c.post(entryp_setup, json.dumps(data3), content_type="application/json")
    assert resp3.status_code == 200
    
    resp_data3 = json.loads(resp3.content)
    assert data3['username'] == resp_data3['username']
    assert data3['progrLang'] == resp_data3['progrLang']
    assert resp_data3['votes'] == 1
    assert resp_data3['totalVotes'] == 3


@pytest.mark.django_db
def test_error_username_exists(entryp_setup, create_test_users):
    c = Client()
    data3 = create_test_users[2]
    data4 = create_test_users[3]

    resp3 = c.post(entryp_setup, json.dumps(data3), content_type="application/json")
    resp_data3 = json.loads(resp3.content)
    try:
        key = resp_data3['error']
    except KeyError:
        pass
    
    resp4 = c.post(entryp_setup, json.dumps(data4), content_type="application/json")
    resp_data4 = json.loads(resp4.content)
    try:
        key = resp_data4['error']
    except KeyError:
        pytest.fail('Error Username exists was not thrown')
    assert resp_data4['error'] == 'Username already exists'