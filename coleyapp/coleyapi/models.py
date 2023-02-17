from django.db import models
from django.contrib.auth.models import AbstractUser,UserManager

from django.utils import timezone
# Create your models here.

class Analysis(models.Model):
    id = models.AutoField(primary_key=True)
    user_id = models.ForeignKey('User', models.DO_NOTHING)
    cut = models.ForeignKey('Cut', models.DO_NOTHING, null=True)
    date = models.DateTimeField()
    result_xlsx_path = models.FileField(upload_to='uploads/')
    state = models.JSONField()  # This field type is a guess.

    class Meta:
        managed = True
        


class Containers(models.Model):
    container_name = models.CharField(max_length=255)
    container_description = models.JSONField()  # This field type is a guess.

    class Meta:
        managed = True
        


class Cut(models.Model):
    parent_cut = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
    cut_number = models.IntegerField(null=True)
    user_id = models.ForeignKey('User', models.DO_NOTHING)
    purpose = models.CharField(max_length=255)
    cut_date = models.DateTimeField()

    class Meta:
        managed = True
        

class Patients(models.Model):
    patient_name = models.CharField(max_length=255)
    patient_dob = models.DateField()
    gender = models.CharField(max_length=255)

    class Meta:
        managed = True
       


class Sample(models.Model):
    user_id = models.ForeignKey('User', models.DO_NOTHING)
    origin = models.CharField(max_length=255)
    patient = models.ForeignKey(Patients, models.DO_NOTHING)
    tumor_type = models.ForeignKey('TumorType', models.DO_NOTHING)
    entry_date = models.DateTimeField(default=timezone.now)
    temperature = models.ForeignKey('Temperature', models.DO_NOTHING)
    container = models.ForeignKey('Containers', models.DO_NOTHING)
    location = models.JSONField()  # This field type is a guess.
    cut = models.ForeignKey('Cut', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = True
      


class Temperature(models.Model):
    temperature_desc = models.CharField(max_length=255)

    class Meta:
        managed = True
        


class TumorType(models.Model):
    tumor_description = models.CharField(max_length=255)

    class Meta:
        managed = True
        


class User(AbstractUser):
    username = models.CharField(max_length=255, unique=True, null=False)
    first_name = models.CharField(max_length=255, blank=True, null=True)
    last_name = models.CharField(max_length=255, blank=True, null=True)
    email = models.EmailField(max_length=255)
    password = models.CharField(max_length=255)
    groups = models.IntegerField(blank=True, null=True)
    user_permissions = models.IntegerField(blank=True, null=True)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    is_superuser = models.BooleanField(default=False)
    last_login = models.DateTimeField(blank=True, null=True)
    date_joined = models.DateTimeField(default=timezone.now)

    class Meta:
        managed = True
               