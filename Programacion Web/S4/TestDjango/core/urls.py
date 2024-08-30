from django.urls import path
from .views import libros, crear

urlpatterns = [
    path('libros', libros, name="libros"),
    path('libros/crear', crear, name="crear"),
]
