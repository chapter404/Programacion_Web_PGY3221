from django.urls import path
from .views import libros, crear

urlpatterns = [
    path('libros', libros, name="libros"),
    path('libros/form', crear, name="form"),
]
