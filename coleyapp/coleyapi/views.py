from django.shortcuts import render
from django.db import connection
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.hashers import make_password
from django.contrib.auth import authenticate, login, logout
from django.views.decorators.csrf import csrf_exempt
import json, operator

# connect to db
cursor = connection.cursor()

## PL/pgSQL functions
# User PL/pgSQL functions
USER_LIST = "SELECT user_list()"
AUTHENTICATED_USER = "SELECT authenticated_user(%d)"
USER_AVAILABLE_ROLES = "SELECT user_available_roles(%d)"

# Sample PL/pgSQL functions
TISSUES_AVAILABLE = "SELECT * FROM tissuetype"
SAMPLE_INFORMATION = "SELECT * FROM sample_information(%d)"
SAMPLE_LIST_FOR_USER = "SELECT * FROM sample_list_for_user(%d)"


## PL/pgSQL procedures
REGISTER_NEW_SAMPLE = "CALL register_new_sample(%d, %s, %s, %d, %d, %d, %d, %s) "
REGISTER_NEW_CUT = "CALL register_new_cut(%d, %d, %s, %d)"
REGISTER_NEW_USER = "CALL create_new_user(%s, %s, %s, %s, %s, %s)"


# Create your views here.
@csrf_exempt
def login_view(request):
    if request.method == 'POST':
        username = request.POST.get("username")
        password = request.POST.get("password")

        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            return JsonResponse({'success': True})
           
        else:
            return JsonResponse({'success': False, 'error': 'Invalid username or password'})
    else:
        return JsonResponse({'success': False, 'error': 'Method not allowed'})
    

def logout_view(request):
    logout(request)
    return JsonResponse({'success': True})


def create_user_view(request):
    return True

'''
def user(request):
    id = 10
    cursor.execute(AUTHENTICATED_USER % id)
    data = cursor.fetchone()
    return JsonResponse(data, safe=False)

def user_roles(request):
    id = 10
    cursor.execute(USER_AVAILABLE_ROLES % id)
    data = cursor.fetchone()[0]
    return JsonResponse(data, safe=False)

def user_list(request):
    cursor.execute(USER_LIST)
    data = cursor.fetchall()
    data = data[0][0]
    return JsonResponse(data, safe=False)

def tissue_types(request):
    cursor.execute(TISSUES_AVAILABLE)
    data = cursor.fetchall()
    return JsonResponse(data, safe=False)'''