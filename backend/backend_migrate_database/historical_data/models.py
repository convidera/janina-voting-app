from django.db import models

# Create your models here.


class Vote(models.Model):
    user_name = models.CharField(max_length=50)

