from django.shortcuts import render
from django.db import connection
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.hashers import make_password
# connect to db
cursor = connection.cursor()

TABLE_DATA_SORTED = "SELECT table_data_sorted('auth_user','id')"



# Create your views here.
def user(request):
    cursor.execute(TABLE_DATA_SORTED)
    data = cursor.fetchall()
    return JsonResponse(data[0][0], safe=False)

def password_maker(request):
    pw = make_password('markuspw', salt='abc')
    return JsonResponse(pw, safe=False)
