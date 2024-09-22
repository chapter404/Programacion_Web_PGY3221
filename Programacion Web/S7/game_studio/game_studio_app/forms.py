from django import forms
from django.contrib.auth.models import User
from .models import Usuario, Juego, Categoria

class UsuarioForm(forms.ModelForm):
    clave = forms.CharField(label='Clave', widget=forms.PasswordInput)
    confirmacion_clave = forms.CharField(label='Confirmar Clave', widget=forms.PasswordInput)

    class Meta:
        model = Usuario
        fields = ['nombre_real', 'nombre_usuario', 'correo', 'direccion_despacho', 'fecha_nacimiento']

    def clean(self):
        cleaned_data = super().clean()
        clave = cleaned_data.get('clave')
        confirmacion_clave = cleaned_data.get('confirmacion_clave')

        if clave and confirmacion_clave and clave != confirmacion_clave:
            raise forms.ValidationError("Las claves no coinciden")
        
        return cleaned_data
    
    
class LoginForm(forms.Form):
    username = forms.CharField(label='Nombre de Usuario', max_length=100)
    password = forms.CharField(label='Clave de Ingreso', widget=forms.PasswordInput)


class JuegoForm(forms.ModelForm):
    imagen_juego_url = forms.URLField(required=False, widget=forms.HiddenInput())
    class Meta:
        model = Juego
        fields = ['titulo_juego', 'categoria_juego', 'precio_juego', 'descripcion_juego', 'imagen_juego']
        widgets = {
            'categoria_juego': forms.Select(),
            'precio_juego': forms.NumberInput(attrs={'step': '0.01'}),
            'descripcion_juego': forms.Textarea(attrs={'rows': 4}),
        }
