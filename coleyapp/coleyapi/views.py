from django.shortcuts import render
from django.db import connection
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.hashers import make_password
from iteration_utilities import deepflatten, flatten
import json, operator

# connect to db
cursor = connection.cursor()

# User PL/pgSQL functions
USER_LIST = "SELECT user_list()"

AUTHENTICATED_USER = "SELECT authenticated_user(%d)"

USER_AVAILABLE_ROLES = "SELECT user_available_roles(%d)"

#(username VARCHAR, firstname VARCHAR, lastname VARCHAR, email VARCHAR, password VARCHAR, roles numeric[])
CREATE_NEW_USER = "CALL create_new_user('{0}','{1}','{2}','{3}','{4}','{5}')"

DELETE_USER = "CALL delete_user(%d)"



# Create your views here.
def user(request):
    id = 1
    cursor.execute(AUTHENTICATED_USER % id)
    data = cursor.fetchone()
    return JsonResponse(data, safe=False)

def create_new_user(request):
    uname = 'to.ze'
    firstname = 'Antonio'
    lastname = 'Jose'
    em = 'to.ze@fc.pt'
    pw = 'pbkdf2_sha256$390000$njlgW13w7vcOjba6bkTxto$f7ac6RoVktu4hvRISs7XsM+YyfknX0jae7aS0Duo7VM='
    rol = '{2,3,4}'
    cursor.execute(CREATE_NEW_USER.format(uname, firstname,lastname, em, pw, rol))
    return HttpResponse('User created')

def delete_user(request):
    id = 12
    cursor.execute(DELETE_USER % id)
    return HttpResponse('User deleted')

def user_roles(request):
    id = 1
    cursor.execute(USER_AVAILABLE_ROLES % id)
    data = cursor.fetchone()[0]
    return JsonResponse(data, safe=False)


def user_list(request):
    cursor.execute(USER_LIST)
    data = cursor.fetchall()
    data = data[0][0]
    return JsonResponse(data, safe=False)
