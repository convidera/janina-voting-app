from django.http import HttpResponseRedirect

from .models import Username, Choice



def index(request):
    user = Username.create(username_text=request.POST['username'])
    user.save();
    selected_choice = user.choice_set.create(choice_text=request.POST['progrLang'])
    selected_choice.votes += 1
    selected_choice.save()

    response_data = {}
    response_data['username'] = user
    response_data['progrLang'] = selected_choice
    response_data['votes'] = selected_choice.votes
    response_data['totalVotes'] = Choice.objects.all().count()

    return JsonResponse(response_data)


    #return redirect('/results', response_data)
    #return HttpResponseRedirect(json.dumps(buildResponse()), content_type="application/json")
