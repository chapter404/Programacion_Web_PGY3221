from rest_framework import serializers
from .models import Juego, Categoria

class JuegoSerializer(serializers.ModelSerializer):
    categoria_juego = serializers.PrimaryKeyRelatedField(queryset=Categoria.objects.all())

    class Meta:
        model = Juego
        fields = ['id', 'titulo_juego', 'categoria_juego', 'precio_juego', 'descripcion_juego', 'imagen_juego']


class CategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = ['id', 'nombre_categoria']