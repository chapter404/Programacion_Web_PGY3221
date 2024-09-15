from django import forms
from django.contrib.auth.models import User
from .models import Usuario

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
