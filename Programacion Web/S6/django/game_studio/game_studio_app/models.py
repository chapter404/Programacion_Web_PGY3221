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


class Categoria(models.Model):
    nombre_categoria = models.CharField(max_length=100)

    def __str__(self):
        return self.nombre_categoria


class Juego(models.Model):
    titulo_juego = models.CharField(max_length=100)
    categoria_juego = models.ForeignKey(Categoria, related_name='juegos', on_delete=models.CASCADE)
    precio_juego = models.DecimalField(max_digits=10, decimal_places=2)
    descripcion_juego = models.TextField()
    imagen_juego = models.ImageField(upload_to='imagenes/', null=True, blank=True)
    
    def __str__(self):
        return self.titulo_juego
