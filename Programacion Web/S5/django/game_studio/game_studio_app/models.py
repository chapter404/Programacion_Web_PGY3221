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
    imagen_juego = models.ImageField(upload_to='juegos/imagenes/', null=True, blank=True)
    
    def __str__(self):
        return self.titulo_juego


class Carrito(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'Carrito de {self.usuario.nombre_usuario}'

class ItemCarrito(models.Model):
    carrito = models.ForeignKey(Carrito, related_name='items', on_delete=models.CASCADE)
    producto = models.CharField(max_length=255)
    cantidad = models.PositiveIntegerField(default=1)
    precio = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f'{self.cantidad} x {self.producto}'

    def total_item(self):
        return self.cantidad * self.precio

class MetodoPago(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    tipo_pago = models.CharField(max_length=50, choices=[('tarjeta', 'Tarjeta'), ('paypal', 'PayPal'), ('transferencia', 'Transferencia Bancaria')])
    detalles = models.CharField(max_length=255)

    def __str__(self):
        return f'{self.tipo_pago} - {self.usuario.nombre_usuario}'

class ModificarPerfil(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    nombre_real = models.CharField(max_length=255, blank=True, null=True)
    correo = models.EmailField(blank=True, null=True)
    direccion_despacho = models.CharField(max_length=255, blank=True, null=True)
    fecha_nacimiento = models.DateField(blank=True, null=True)

    def __str__(self):
        return f'Modificar perfil de {self.usuario.nombre_usuario}'

    def save(self, *args, **kwargs):
        if self.nombre_real:
            self.usuario.nombre_real = self.nombre_real
        if self.correo:
            self.usuario.correo = self.correo
        if self.direccion_despacho:
            self.usuario.direccion_despacho = self.direccion_despacho
        if self.fecha_nacimiento:
            self.usuario.fecha_nacimiento = self.fecha_nacimiento
        self.usuario.save()
        super().save(*args, **kwargs)
