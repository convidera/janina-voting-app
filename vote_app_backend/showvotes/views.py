#from django.http import HttpResponseRedirect
from django.http import JsonResponse, HttpResponse
from django.middleware.csrf import get_token
from .models import Username, Choice
import json




def handleVotes(request):
    if request.method == 'POST':
        body_unicode = request.body.decode('utf-8') 	
        body = json.loads(body_unicode)
        usernameJSON = body['username']
        choiceJSON = body['progrLang']
        if usernameJSON and choiceJSON:
            response_data = {}
            if (Username.objects.filter(username_text=usernameJSON).count() < 1):
                user = Username.objects.create(username_text=usernameJSON)
                user.save()
                selected_choice = user.choice_set.create(choice_text=choiceJSON)
                selected_choice.save()

                userQuery = Username.objects.get(username_text=usernameJSON)
                choiceQuery = userQuery.choice_set.get(choice_text=choiceJSON)
                
                response_data['username'] = userQuery.username_text
                response_data['progrLang'] = choiceQuery.choice_text
                response_data['votes'] = Choice.objects.filter(choice_text=choiceJSON).count()
                response_data['totalVotes'] = Username.objects.all().count()
                return JsonResponse(response_data)   
            response_data['error'] = 'Username already exists'
            return JsonResponse(response_data)

def setFECookie(request):
    if request.method == 'GET':
        token = get_token(request)
        html = HttpResponse('', 204)
        return html

def ping(request):
    return HttpResponse('helloworld')