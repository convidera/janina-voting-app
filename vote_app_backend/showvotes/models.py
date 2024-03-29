from django.db import models


class Username(models.Model):
    username_text = models.CharField(max_length=200)

    def __str__(self):
        return self.username_text



class Choice(models.Model):
    username = models.ForeignKey(Username, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=50)

    def __str__(self):
        return self.choice_text