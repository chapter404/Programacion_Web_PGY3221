from datetime import date
from django import forms
from django.contrib.auth.models import User
from .models import Usuario

class UsuarioForm(forms.ModelForm):
    confirmacion_clave = forms.CharField(widget=forms.PasswordInput, label='Repetir Clave de Ingreso')

    class Meta:
        model = Usuario
        fields = ['nombre_real', 'nombre_usuario', 'correo', 'direccion_despacho', 'clave', 'confirmacion_clave', 'fecha_nacimiento']

    def clean(self):
        cleaned_data = super().clean()
        clave = cleaned_data.get('clave')
        confirmacion_clave = cleaned_data.get('confirmacion_clave')

        if clave and confirmacion_clave and clave != confirmacion_clave:
            self.add_error('confirmacion_clave', 'Las contraseñas no coinciden')

        return cleaned_data

    def clean_fecha_nacimiento(self):
        fecha_nacimiento = self.cleaned_data.get('fecha_nacimiento')
        hoy = date.today()
        edad_usuario = hoy.year - fecha_nacimiento.year - ((hoy.month, hoy.day) < (fecha_nacimiento.month, fecha_nacimiento.day))

        if edad_usuario < 13:
            raise forms.ValidationError('Debes ser mayor de 13 años para registrarte.')

        return fecha_nacimiento
    
class LoginForm(forms.Form):
    username = forms.CharField(label='Nombre de Usuario', max_length=100)
    password = forms.CharField(label='Clave de Ingreso', widget=forms.PasswordInput)
