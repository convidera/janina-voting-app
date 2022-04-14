#from django.http import HttpResponseRedirect
from django.http import JsonResponse, HttpResponse
from .models import Username
import hmac
import hashlib
import random
import string
import environ




def handleVotes(request):
    if request.method == 'POST':
        usernameJSON = request.POST.get('username')
        choiceJSON = request.POST.get('progrLang')
        if usernameJSON and choiceJSON:
            user = Username.objects.create(username_text=usernameJSON)
            #user = Username.objects.create(username_text=request.POST['username'])
            user.save()
            selected_choice = user.choice_set.create(choice_text=choiceJSON)
            #selected_choice = user.choice_set.create(choice_text=request.POST['progrLang'])
            selected_choice.votes += 1
            selected_choice.save()

            response_data = {}
            response_data['username'] = user
            response_data['progrLang'] = selected_choice
            response_data['votes'] = selected_choice.votes
            response_data['totalVotes'] = selected_choice.objects.all().count()

            return JsonResponse(response_data)
    


    #return redirect('/results', response_data)
    #return HttpResponseRedirect(json.dumps(buildResponse()), content_type="application/json")


def setFECookie(request):
    if request.method == 'GET':
        env = environ.Env()
        environ.Env.read_env()
        html = HttpResponse('', 204)
        token = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(8))
        hash = hmac.new(bytes(env('SECRET_KEY') , 'latin-1'), msg = bytes(token , 'latin-1'), digestmod = hashlib.sha256).hexdigest().upper()
        html.set_cookie('csrftoken', hash)
        return html