from django.urls import reverse
from .forms import UsuarioForm, LoginForm, JuegoForm
from .models import Usuario, Juego, Categoria
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
import logging


logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger('game')


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

def registro(request):
    return render(request, 'formulario_registro.html')

def panel_inicio_sesion(request):
    return render(request, 'game_studio_app/panel_inicio_sesion.html')

@csrf_exempt
def registrar(request):
    if request.method == 'POST':
        form = UsuarioForm(request.POST)
        if form.is_valid():
            user = User.objects.create_user(
                username=form.cleaned_data['nombre_usuario'],
                email=form.cleaned_data['correo'],
                password=form.cleaned_data['clave']
            )
            usuario = form.save(commit=False)  
            usuario.user = user
            usuario.save()
            messages.success(request, 'Registro exitoso')
            return redirect('iniciar_sesion')
        else:
            messages.error(request, 'Por favor, corrija los errores del formulario')
    else:
        form = UsuarioForm()

    return render(request, 'form.html', {'form': form})


def iniciar_sesion(request):
    logger.debug('Este es un mensaje DEBUG')
    logger.info('Este es un mensaje INFO')
    logger.warning('Este es un mensaje WARNING')
    logger.error('Este es un mensaje ERROR')
    logger.critical('Este es un mensaje CRITICAL')
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']
            user = authenticate(request, username=username, password=password)
            logger.debug('Formulario Correcto')

            if user is not None:
                login(request, user)
                logger.debug('Usuario autenticado')

                if user.is_superuser:
                    logger.debug('Usuario es superusuario')
                    return redirect(reverse('admin:index'))
                logger.debug('Usuario no es superusuario')
                return redirect('panel_usuario')
            else:
                messages.error(request, 'Nombre de usuario o clave incorrectos.')

    else:
        form = LoginForm()

    return render(request, 'game_studio_app/panel_inicio_sesion.html', {'form': form})


@login_required
def panel_usuario(request):
    usuario = Usuario.objects.get(user=request.user)
    return render(request, 'game_studio_app/panel_usuario.html', {'usuario': usuario})


def mostrar_juegos(request):
    juegos = Juego.objects.all()
    return render(request, 'administrar_juegos/mostrar_juegos.html', {'juegos': juegos})


def crear_juego(request):
    if request.method == 'POST':
        form = JuegoForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            messages.success(request, 'Juego creado exitosamente.')
            return redirect('mostrar_juegos')
        else:
            messages.error(request, 'Hay errores en el formulario.')
    else:
        form = JuegoForm()
    return render(request, 'administrar_juegos/crear_juego.html', {'form': form})


def editar_juego(request, juego_id):
    juego = get_object_or_404(Juego, id=juego_id)
    if request.method == 'POST':
        form = JuegoForm(request.POST, request.FILES, instance=juego)
        if form.is_valid():
            form.save()
            messages.success(request, 'Juego actualizado exitosamente.')
            return redirect('mostrar_juegos')
        else:
            messages.error(request, 'Hay errores en el formulario.')
    else:
        form = JuegoForm(instance=juego)
    return render(request, 'administrar_juegos/editar_juego.html', {'form': form})


def eliminar_juego(request, juego_id):
    juego = get_object_or_404(Juego, id=juego_id)
    if request.method == 'POST':
        juego.delete()
        return redirect('mostrar_juegos')


def categoria_juegos(request, categoria):
    juegos = Juego.objects.filter(categoria_juego__nombre_categoria=categoria)
    
    categoria_titulo = categoria.replace("_", " ").capitalize()

    return render(request, 'categoria_juegos.html', {'juegos': juegos, 'categoria_titulo': categoria_titulo})



def detalle_juego(request, id):
    juego = Juego.objects.get(id=id)
    return render(request, 'detalle_juego.html', {'juego': juego})


def crear_categoria(request):
    if request.method == 'POST':
        nombre = request.POST.get('nombre_categoria')
        if nombre:
            Categoria.objects.create(nombre_categoria=nombre)
        return redirect('crear_categoria') 

    return render(request, 'administrar_juegos/crear_categoria.html')


def editar_categoria(request, categoria_id):
    categoria = get_object_or_404(Categoria, id=categoria_id)
    if request.method == 'POST':
        nombre = request.POST.get('nombre_categoria')
        if nombre:
            categoria.nombre_categoria = nombre
            categoria.save()
            return redirect('mostrar_categorias')
    return render(request, 'administrar_juegos/editar_categoria.html', {'categoria': categoria})


def eliminar_categoria(request, categoria_id):
    categoria = get_object_or_404(Categoria, id=categoria_id)
    if request.method == 'POST':
        categoria.delete()
        return redirect('mostrar_categorias')


def mostrar_categorias(request):
    categorias = Categoria.objects.all()
    return render(request, 'administrar_juegos/mostrar_categorias.html', {'categorias': categorias})