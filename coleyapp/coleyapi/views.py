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
AUTHENTICATED_USER = "SELECT to_json(u) FROM authenticated_user(%d) u"
USER_AVAILABLE_ROLES = "SELECT user_available_roles(%d)"

# Sample PL/pgSQL functions
TISSUES_AVAILABLE = "SELECT to_json(t) FROM tissuetype t"
TUMORS_AVAILABLE = "SELECT to_json(tu) FROM tumortype tu"
TEMPERATURES_AVAILABLE = "SELECT to_json(t) FROM temperature t"
SAMPLE_INFORMATION = "SELECT * FROM sample_information(%d)"
SAMPLE_LIST_FOR_USER = "SELECT * FROM sample_list_for_user(%d)"
CONTAINERS_AVAILABLE = "SELECT to_json(c) FROM containers c"
SAMPLES_AVAILABLE = "SELECT to_json(s) FROM sample s"
CUTS_FROM_SAMPLE = "SELECT * FROM get_all_cuts_from_sample(%d)"

# Patient PL/pgSQL functions
PATIENT_LIST = "SELECT to_json(p) FROM patients p"

## PL/pgSQL procedures
# (user_id, origin, patient_id, tumor_type_id, tissue_type_id, entry_date, 
# temperature_id, container_id, "location")
REGISTER_NEW_SAMPLE = "CALL register_new_sample(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
REGISTER_NEW_CUT = "CALL register_new_cut(%s, %s, %s, %s)"
REGISTER_NEW_USER = "CALL create_new_user(%s,%s,%s,%s,%s,%s)"
REGISTER_NEW_PATIENT = "CALL create_new_patient(%s, %s, %s)"



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
            return JsonResponse({'success': False, 'error': 'Invalid username or password', 'is_logged': True})
            
    else:
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
                return JsonResponse([{'success': False, 'error': 'There was a problem obtaining your roles.'}], safe=False)
        except:
            return JsonResponse([{'success': False, 'error': 'Could not establish connection to the database.'}], safe=False)


# Create users view

@csrf_exempt
def create_user_view(request):

    roles_numbers = {'admin': 1, 'supervisor': 2, 'technician': 3, 'student': 4}
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
        

        return JsonResponse({'success' : True, 'message' : 'User created successfully!'})
    else:
        return JsonResponse({'sucess' : False, 'message' : 'There was a problem.'})
    
# Create patient view
@csrf_exempt
def create_patient_view(request):
    name = str(json.loads(request.body.decode('utf-8'))['name'])
    dob = str(json.loads(request.body.decode('utf-8'))['dob'])
    gender = str(json.loads(request.body.decode('utf-8'))['gender'])
    
    try:
        cursor.execute(REGISTER_NEW_PATIENT, (name, dob, gender))
    except Exception as inst:
        return JsonResponse({'success' : False, 'message': inst})
    return JsonResponse({'success': True, 'message': 'Patient registered successfully!'})

@csrf_exempt
# Create sample view
def create_sample_view(request):
    if request.method == 'POST':
        userid = int(json.loads(request.body.decode('utf-8'))['user'])
        origin = str(json.loads(request.body.decode('utf-8'))['origin'])
        patient = int(json.loads(request.body.decode('utf-8'))['selectedPatient'])
        tumor = int(json.loads(request.body.decode('utf-8'))['selectedTumor'])
        tissue = int(json.loads(request.body.decode('utf-8'))['selectedTissue'])
        date_creation = str(json.loads(request.body.decode('utf-8'))['selectedDate'])
        temperature = int(json.loads(request.body.decode('utf-8'))['selectedTemperature'])
        container = int(json.loads(request.body.decode('utf-8'))['selectedContainer'])
        print(userid, origin, patient, tumor, tissue, date_creation, temperature, container)
        #CALL register_new_sample(%d, %s, %d, %d, %d, %d, %d, %s, %s)"
        # user_id, origin, patient_id, tumor_type_id, tissue_type_id, entry_date, temperature_id, container_id, "location" #
        cursor.execute(REGISTER_NEW_SAMPLE, (userid, origin, patient, tumor, tissue, temperature, container, None, date_creation))
        return JsonResponse({'success': True, 'message' :'Sample created!'})

        #return JsonResponse({'success': False, 'message' :'Registering failed...'})
    
# Get patients view
def get_patients(request):
    data = []
    while len(data) == 0:
        time.sleep(0.5)
        cursor.execute(PATIENT_LIST)
        data = cursor.fetchall()
    return JsonResponse({'success': True, 'message': 'Patients retrieved!', 'data': data})

def tissue_types(request):
    data = []
    while len(data) == 0:
        time.sleep(0.5)
        cursor.execute(TISSUES_AVAILABLE)
        data = cursor.fetchall()
    return JsonResponse({'success': True, 'message': 'Tissues retrieved!', 'data': data})

def tumor_types(request):
    data = []
    while len(data) == 0:
        time.sleep(0.5)
        cursor.execute(TUMORS_AVAILABLE)
        data = cursor.fetchall()
    return JsonResponse({'success': True, 'message': 'Tumors retrieved!', 'data': data})

def temperatures(request):
    data = []
    while len(data) == 0:
        time.sleep(0.5)
        cursor.execute(TEMPERATURES_AVAILABLE)
        data = cursor.fetchall()
    return JsonResponse({'success': True, 'message': 'Temperatures retrieved!', 'data': data})

def containers(request):
    data = []
    while len(data) == 0:
        time.sleep(0.5)
        cursor.execute(CONTAINERS_AVAILABLE)
        data = cursor.fetchall()
    return JsonResponse({'success': True, 'message': 'Containers retrieved!', 'data':data})

def samples(request):
    data = []
    while len(data) == 0:
        time.sleep(0.5)
        cursor.execute(SAMPLES_AVAILABLE)
        data = cursor.fetchall()
    return JsonResponse({'success': True, 'message': 'Samples retrieved successfully', 'data': data})


def get_cuts_from_sample(request):
    data = []
    print(request)
    #while len(data) == 0:
        #cursor.execute(CUTS_FROM_SAMPLE % int(session.get(sampleid)))
        #data = cursor.fetchall()
    return JsonResponse({'success': True, 'message': 'Cuts from a given sample retrieved!', 'data' :data})

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
'''
