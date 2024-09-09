from django.db import models

class Usuario(models.Model):
    nombre = models.CharField(max_length=50)

    def __str__(self):
        return self.nombre
    

class Categoria(models.Model):
    nombre = models.CharField(max_length=200)
    def __str__(self) :
        return self.nombre
    

class Games(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=200)
    descripcion = models.TextField(null=True, blank=True)
    imagen = models.ImageField(upload_to='inicio', null=True, blank=True)
    categoria = models.ForeignKey(Categoria, on_delete=models.CASCADE, related_name='inicio')


    def __str__(self):
        return self.nombre
    
    def get_code_name(self):
        return f"Nombre Juego: {self.nombre}"