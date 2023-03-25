from django.contrib import admin
from django.urls import path, include
from . import views

urlpatterns = [
    path('user/', views.user),
    path('user_list/', views.user_list),
    path('user_roles/', views.user_roles),
    path('create_new_user/', views.create_new_user),
    path('delete_user/', views.delete_user)
    
]