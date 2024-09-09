from django.contrib import admin
from .models import Usuario, Producto
from .models import Categoria, Games

# Register your models here.

admin.site.register(Categoria)
admin.site.register(Games)
admin.site.register(Usuario)
admin.site.register(Producto)

