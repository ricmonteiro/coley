# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth import models as auth_models


class Analysis(models.Model):
    analysis_id = models.IntegerField(primary_key=True)
    user_id = models.IntegerField()
    cut = models.ForeignKey('Cut', models.DO_NOTHING)
    date = models.DateTimeField()
    result_xlsx_path = models.CharField(max_length=255, blank=True, null=True)
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


class UserPermissionLevel(models.Model):
    user_permission_id = models.SmallIntegerField(primary_key=True)
    user_title = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'user_permission_level'


class Users(auth_models.AbstractUser):
    user_id = models.IntegerField(unique=True)
    user_permission = models.ForeignKey(UserPermissionLevel, models.DO_NOTHING)
    name = models.CharField(max_length=255)
    username = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    dummyfile = models.CharFiel(max_length=10)

    class Meta:
        managed = False
        db_table = 'users'
