from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from .models import Games
from. forms import ProductoForm 

@login_required
def vista_protegida (request):
    return render(request, 'GameApp/protegida.html')

def inicio(request):
    return render(request, 'index.html')

def registro(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user=form.save()
            login(request, user)
            return redirect('index.html')
        else:
            form =UserCreationForm()
            return render(request, 'form.html', {'form': form})
        
@login_required
def vista_protegida (request):
    return render(request, 'GameApp/protegida.html')

def listar_productos(request):
    productos = Producto.objects.all()
    return render(request, 'GameApp/listar.html', {'productos': productos})


def crear_producto(request):
    if request.method == 'POST':
        form = ProductoForm(request.POST)
        if form.is_valid():
           form.save()
           return redirect('listar_producto')
        else:
            form = ProductoForm()
        return render(request, 'GameApp/crear.html', {'form': form})

def editar_producto(request, pk):
    producto = get_object_or_404(producto, pk=pk)
    if request.method == 'POST':
        form = ProductoForm(request.POST, instance=producto)
        if form.is_valid():
            form.save()
            return redirect('listar_producto')
    else:
        form =ProductoForm(instance=producto)
    return render(request, 'GameAPP/editar.html', {'form': form})
    

def eliminar_producto(request, pk):
    producto = get_object_or_404(producto, pk=pk)
    if request.method == 'POST':
            producto.delete()
            return redirect('listar_producto')
    return render(request, 'GameAPP/eliminar.html', {'producto': producto})
    

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


# MODIFICAR DE MOMENTO SOLO ESTOY COPIANDO LO DEL FORO
def listado_juegos(request):
    juegos = Games.objects.all()
    context = {
        'juegos' : juegos
    }
    return render(request, 'index.html', context)