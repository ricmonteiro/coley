from django.db import models
from django.contrib.auth.models import AbstractBaseUser, AbstractUser,BaseUserManager
# Create your models here.


class Analysis(models.Model):
    analysis_id = models.IntegerField(primary_key=True)
    user_id = models.IntegerField()
    cut = models.ForeignKey('Cut', models.DO_NOTHING)
    date = models.DateTimeField()
    result_xlsx_path = models.FileField(upload_to='uploads/')
    state = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'analysis'


class Containers(models.Model):
    container_id = models.IntegerField(primary_key=True)
    container_name = models.CharField(max_length=255)
    container_description = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'containers'


class Cut(models.Model):
    cut_id = models.IntegerField(primary_key=True)
    parent_cut = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
    cut_number = models.IntegerField()
    user_id = models.IntegerField()
    purpose = models.CharField(max_length=255)
    cut_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'cut'


class Patients(models.Model):
    patient_id = models.IntegerField(primary_key=True)
    patient_name = models.CharField(max_length=255)
    patient_dob = models.DateField()
    gender = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'patients'


class Sample(models.Model):
    sample_id = models.IntegerField(primary_key=True)
    user_id = models.IntegerField()
    origin = models.CharField(max_length=255)
    patient = models.ForeignKey(Patients, models.DO_NOTHING)
    tumor_type = models.ForeignKey('TumorType', models.DO_NOTHING)
    entry_date = models.DateTimeField()
    temperature = models.ForeignKey('Temperature', models.DO_NOTHING)
    container = models.ForeignKey(Containers, models.DO_NOTHING)
    location = models.TextField()  # This field type is a guess.
    cut = models.ForeignKey(Cut, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sample'


class Temperature(models.Model):
    temperature_id = models.IntegerField(primary_key=True)
    temperature_desc = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'temperature'


class TumorType(models.Model):
    tumor_type_id = models.SmallIntegerField(primary_key=True)
    tumor_description = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'tumor_type'


class User(AbstractUser):
    id = models.IntegerField(primary_key=True, unique=True)
    username = models.CharField(unique=True, max_length=255)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    groups = models.IntegerField()
    user_permissions = models.IntegerField()
    is_staff = models.BooleanField()
    is_active = models.BooleanField(default=True)
    is_superuser = models.BooleanField()
    last_login = models.DateTimeField()
    date_joined = models.DateTimeField()
    USERNAME_FIELD = 'id'

    class Meta:
        managed = False
        db_table = 'user'
