from django.shortcuts import render
from django.db import connection
from django.http import HttpResponse

# connect to db
cursor = connection.cursor()

TABLE_DATA_SORTED = "SELECT table_data_sorted('auth_user','id')"

# Create your views here.

def user(request):
    cursor.execute(TABLE_DATA_SORTED)
    data = cursor.fetchall()
    return HttpResponse(data[0])
