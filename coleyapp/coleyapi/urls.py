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

]