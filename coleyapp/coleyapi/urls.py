from django.contrib import admin
from django.urls import path, include
from . import views


# API endpoints

urlpatterns = [

    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('create_user/', views.create_user_view, name='create-user'),
    path('user_roles/', views.user_roles, name='user-roles'),
    path('new_sample/', views.create_sample_view, name='create-sample'),
    path('new_patient/', views.create_patient_view, name='create-patient'),
    path('patient_list/', views.get_patients, name='get-patients'),
    path('tissuetypes/', views.tissue_types, name='get-tissuetypes'),
    path('tumortypes/', views.tumor_types, name='get-tumortypes'),
    path('temperatures/', views.temperatures, name='get-temperatures'),
    path('containers/', views.containers, name='get-containers'),
    path('samples/', views.samples, name='get-samples'),
    path('cuts/', views.cuts, name='get-cuts'),
    path('cuts_from_sample/', views.get_cuts_from_sample, name='get-cuts-from-sample'),
    path('result_file_upload/', views.file_upload, name='file-upload'),
    path('get_results_filter/', views.get_results_filter, name='get-results-filter')

]