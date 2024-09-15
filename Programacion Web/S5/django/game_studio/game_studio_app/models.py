from django.db import models
from django.contrib.auth.models import User

class Usuario(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    nombre_real = models.CharField(max_length=255)
    nombre_usuario = models.CharField(max_length=255, unique=True)
    correo = models.EmailField(unique=True)
    direccion_despacho = models.CharField(max_length=255, blank=True, null=True)
    fecha_nacimiento = models.DateField()

    def __str__(self):
        return self.nombre_usuario
