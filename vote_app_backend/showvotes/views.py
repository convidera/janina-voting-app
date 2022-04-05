from django.http import HttpResponseRedirect

from .models import Choice
# ...
def results(request):
    selected_choice = Choice.objects.get(pk=request.POST['choice'])
    selected_choice.votes += 1
    selected_choice.save()

    #Generate JSON and send to results page
    return HttpResponseRedirect()
