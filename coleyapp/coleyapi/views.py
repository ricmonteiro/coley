from django.shortcuts import render, redirect
from django.db import connection
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.hashers import make_password
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required, user_passes_test
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
import json, operator
import time

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
REGISTER_NEW_USER = "CALL create_new_user(%s,%s,%s,%s,%s,%s)"


# Create your views here.

# Login view
@csrf_exempt
def login_view(request):

    if request.method == 'POST':
        username = request.POST.get("username")
        password = request.POST.get("password")
 

        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            global session
            global authenticated_user
            session = request.session
            cursor.execute(AUTHENTICATED_USER % int(session.get('_auth_user_id')))
            authenticated_user = cursor.fetchall()
            return JsonResponse({'success': True, 'user': authenticated_user})
           
        else:
            is_logged = False
            return JsonResponse({'success': False, 'error': 'Invalid username or password', 'is_logged': True})
            
    else:
        is_logged = False
        return JsonResponse({'success': False, 'error': 'Method not allowed', 'is_logged': False})
    
@csrf_exempt
def logout_view(request): 
    if request.method == 'POST':
        logout(request)
        return JsonResponse({'success': True})
    else:
        return JsonResponse({'success': False, 'message': 'Logout failed', 'is_logged': True})


# Role selection view    

def user_roles(request):
    if request.method == 'GET':
        try:
            
            cursor.execute(USER_AVAILABLE_ROLES % int(session.get('_auth_user_id')))
            data = cursor.fetchone()
            if data is not None:
                return JsonResponse(data, safe=False)
            else: 
                return JsonResponse([{'success': False, 'error': 'There was a problem obtaining your roles'}], safe=False)
        except:
            return JsonResponse([{'success': False, 'error': 'Could not establish connection to the database'}], safe=False)

@csrf_exempt
def create_user_view(request):
    roles_numbers = {'admin':1, 'supervisor':2, 'technician':3, 'student':4}

    if request.method == 'POST':
        username = str(json.loads(request.body.decode('utf-8'))['username'])
        firstname = str(json.loads(request.body.decode('utf-8'))['firstname'])
        lastname = str(json.loads(request.body.decode('utf-8'))['lastname'])
        password = make_password(str(json.loads(request.body.decode('utf-8'))['password']))
        email = str(json.loads(request.body.decode('utf-8'))['email'])
        roles = json.loads(request.body.decode('utf-8'))['roles']
        selected_roles = [role for role, selected in roles.items() if selected]
        roles_id = [n for role, n in roles_numbers.items() if role in selected_roles]

        try:
            cursor.execute(REGISTER_NEW_USER, (username, firstname, lastname, email, password, roles_id))
        except Exception as inst:
             return JsonResponse({'sucess' : False, 'message' : inst})
        

        return JsonResponse({'success' : True, 'message' : 'User created succesfully!'})
    else:
        return JsonResponse({'sucess' : False, 'message' : 'There was a problem.'})



def create_sample_view(request):
    return JsonResponse({'success': True, 'message': 'Sample created successfully'})

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
