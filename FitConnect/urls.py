from django.urls import path
from .views import *

urlpatterns = [
    path('fitConnect/create_user', CreateUserView.as_view(), name='create-user'),
]