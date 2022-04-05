from django.http import HttpResponseRedirect

from .models import Username, Choice
# ...

thisUser = user;
thisChoice = selected_choice;

def results(request, user_id):
    user = get_object_or_404(Username, pk=user_id)

    selected_choice = user.choice_set.get(pk=request.POST['progrLang'])
    selected_choice.votes += 1
    selected_choice.save()

    #return data as JSON to endpoint
    return HttpResponseRedirect(json.dumps(buildResponse()), content_type="application/json")


def buildResponse():
    response_data = {}
    response_data['username'] = thisUser
    response_data['progrLang'] = thisChoice

    return response_data
