#from django.http import HttpResponseRedirect
from django.http import JsonResponse, HttpResponse
from django.middleware.csrf import get_token
from .models import Username
import json




def handleVotes(request):
    #decrypt (with SECRET KEY) hashed csrf token sent from FE
    if request.method == 'POST':
        #deserialize request JSON body
        body_unicode = request.body.decode('utf-8') 	
        body = json.loads(body_unicode)
        usernameJSON = body['username']
        choiceJSON = body['progrLang']
        if usernameJSON and choiceJSON:
            user = Username.objects.create(username_text=usernameJSON)
            user.save()
            selected_choice = user.choice_set.create(choice_text=choiceJSON)
            selected_choice.save()
            selected_choice.votes_set.votes += 1
            selected_choice.votes_set.save()

            userQuery = Username.objects.get(username_text=usernameJSON)
            choiceQuery = userQuery.choice_set.get(choice_text=choiceJSON)
            votesQuery = choiceQuery.votes_set.get(choice_name=choiceJSON)
            response_data = {}
            response_data['username'] = userQuery.username_text
            response_data['progrLang'] = choiceQuery.choice_text
            response_data['votes'] = votesQuery.votes
            response_data['totalVotes'] = Username.objects.all().count()
            return JsonResponse(response_data)   


def setFECookie(request):
    if request.method == 'GET':
        token = get_token(request)
        html = HttpResponse('', 204)
        return html

def ping(request):
    return HttpResponse('helloworld')