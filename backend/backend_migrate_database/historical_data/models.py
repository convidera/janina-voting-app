from django.db import models

# Create your models here.


class Vote(models.Model):
    PROGRAMMING_LANGUAGE = (
        ('C', 'C language'),
        ('CPP', 'C++'),
        ('CSHARP', 'C#'),
        ('J', 'Java'),
        ('PY', 'Python'),
        ('R', 'Ruby'),
    ) 
    user_name = models.CharField(max_length=50)

