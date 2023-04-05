from django.contrib import admin
from django.urls import path, include
from . import views

urlpatterns = [
    path('user/', views.user),
    path('user_list/', views.user_list),
    path('user_roles/', views.user_roles),
    path('tissue_types/', views.tissue_types)
    
]