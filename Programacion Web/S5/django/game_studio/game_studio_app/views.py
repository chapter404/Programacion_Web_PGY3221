from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from .models import Producto, Usuario
from .forms import ProductoForm
from django.shortcuts import get_object_or_404
from django.http import HttpResponse
import json
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt


def inicio(request):
    return render(request, 'index.html')

def terror(request):
    return render(request, 'terror.html')

def accion(request):
    return render(request, 'accion.html')

def mundo_abierto(request):
    return render(request, 'mundo_abierto.html')

def free_to_play(request):
    return render(request, 'free_to_play.html')

def supervivencia(request):
    return render(request, 'supervivencia.html')

def carreras(request):
    return render(request, 'carreras.html')

def silent_hill(request):
    return render(request, 'silent_hill_2.html')

def resident_evil(request):
    return render(request, 'resident_Evil_4.html')

def cod(request):
    return render(request, 'call_of_duty.html')

def brawl(request):
    return render(request, 'brawl_stars.html')

def zelda(request):
    return render(request, 'zelda.html')

def roblox(request):
    return render(request, 'roblox.html')

def sims(request):
    return render(request, 'sims.html')

def csgo(request):
    return render(request, 'csgo.html')

def ocean(request):
    return render(request, 'ocean_is_home.html')

def last(request):
    return render(request, 'last_day_on_earth.html')

def mario(request):
    return render(request, 'mario_kart.html')

def crash(request):
    return render(request, 'ctr_crash.html')

def home(request):
    return render(request, 'game_studio_app/home.html')

def registro(request):
    return render(request, 'form.html')

@csrf_exempt
def registrar(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)

            nombre_real = data.get('nombre_real')
            nombre_usuario = data.get('nombre_usuario')
            correo = data.get('correo')
            clave = data.get('clave')
            confirmacion_clave = data.get('confirmacion_clave')
            fecha_nacimiento = data.get('fecha_nacimiento')

            if clave != confirmacion_clave:
                return JsonResponse({'success': False, 'error': 'Las contraseñas no coinciden'})

            # Aquí puedes crear el nuevo usuario o procesar los datos como desees
            # user = User.objects.create_user(nombre_usuario, correo, clave)

            # Respuesta exitosa
            return JsonResponse({'success': True})

        except json.JSONDecodeError:
            return JsonResponse({'success': False, 'error': 'Datos inválidos'})
    else:
        # Si la solicitud no es POST
        return JsonResponse({'success': False, 'error': 'Método no permitido'})

@login_required
def vista_protegida(request):
    return render(request, 'game_studio_app/protegida.html')

@login_required
def listar_productos(request):
    productos = Producto.objects.all()
    return render(request, 'game_studio_app/listar.html', {'productos': productos})

@login_required
def crear_producto(request):
    if request.method == 'POST':
        form = ProductoForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('listar_productos')
        
    else:
        form = ProductoForm()

    return render(request, 'game_studio_app/crear.html', {'form': form})

@login_required
def editar_producto(request, pk):
    producto = get_object_or_404(Producto, pk=pk)
    if request.method == 'POST':
        form = ProductoForm(request.POST, instance=producto)
        if form.is_valid():
            form.save()
            return redirect ('listar_productos')
    else:
        form = ProductoForm(instance=producto)
    
    return render(request, 'game_studio_app/editar.html', {'form': form})

@login_required
def eliminar_producto(request, pk):
    producto = get_object_or_404(Producto, pk=pk)
    if request.method == 'POST':
        producto.delete()
        return redirect ('listar_productos')
    return render(request, 'game_studio_app/editar.html', {'producto': producto})

