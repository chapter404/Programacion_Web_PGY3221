from rest_framework import serializers
from .models import Juego

class JuegoSerializer(serializers.ModelSerializer):
    categoria_juego = serializers.StringRelatedField() 

    class Meta:
        model = Juego
        fields = ['id', 'titulo_juego', 'categoria_juego', 'precio_juego', 'descripcion_juego', 'imagen_juego']
