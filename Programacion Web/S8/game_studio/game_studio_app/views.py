import json
import logging, requests
from .forms import UsuarioForm, LoginForm, JuegoForm
from .models import Usuario, Juego, Categoria, Carrito, ItemCarrito
from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth import login, authenticate
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from django.core.cache import cache
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .serializers import CategoriaSerializer, JuegoSerializer



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
                    # return redirect(reverse('admin:index'))
                else:
                    logger.debug('Usuario no es superusuario')
                return redirect('inicio')
            else:
                messages.error(request, 'Nombre de usuario o clave incorrectos.')

    else:
        form = LoginForm()

    return render(request, 'game_studio_app/panel_inicio_sesion.html', {'form': form})


@login_required
def panel_usuario(request):
    usuario = Usuario.objects.get(user=request.user)
    return render(request, 'game_studio_app/panel_usuario.html', {'usuario': usuario})

@login_required
def mostrar_juegos(request):
    cache.clear()
    juegos = Juego.objects.all()
    return render(request, 'administrar_juegos/mostrar_juegos.html', {'juegos': juegos})

@login_required
def crear_juego(request):
    imagen_juego_url = None

    if request.method == 'POST':
        form = JuegoForm(request.POST, request.FILES)

        nombre_formulario = request.POST.get('nombre_formulario')
        if nombre_formulario == 'formulario_datos_api':
            titulo_juego = request.POST.get('juego.nombre')
            descripcion_juego = request.POST.get('juego.descripcion')
            imagen_juego_url = request.POST.get('juego.imagen')        

            form = JuegoForm(initial={
                'titulo_juego': titulo_juego,
                'descripcion_juego': descripcion_juego,
                'imagen_juego_url': imagen_juego_url,
            })
        
        else:
            if request.POST.get('imagen_juego_url'):
                titulo_del_juego = request.POST.get('titulo_juego')
                imagen_juego_url = request.POST.get('imagen_juego_url')
                response = requests.get(imagen_juego_url)
                contenedor_imagen_juego = ContentFile(response.content, name='imagen_temporal.jpg')
                juego = form.save(commit=False)
                juego.imagen_juego.save(f'{titulo_del_juego}.jpg', contenedor_imagen_juego)
                juego.save()
            if form.is_valid():
                form.save()
                return redirect('mostrar_juegos')
            else:
                logger.debug('Formulario incompleto')
            
    else:
        form = JuegoForm()

    return render(request, 'administrar_juegos/crear_juego.html', {'form': form, 'imagen_juego_url': imagen_juego_url})





@login_required
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

@login_required
def eliminar_juego(request, juego_id):
    juego = get_object_or_404(Juego, id=juego_id)
    logger.debug(f"Juegos a eliminar: {juego}")
    if request.method == 'POST':
        juego.delete()
        return redirect('mostrar_juegos')

@login_required
def categoria_juegos(request, categoria):
    juegos = Juego.objects.filter(categoria_juego__nombre_categoria=categoria)
    
    categoria_titulo = categoria.replace("_", " ").capitalize()

    return render(request, 'categoria_juegos.html', {'juegos': juegos, 'categoria_titulo': categoria_titulo})


@login_required
def detalle_juego(request, id):
    juego = Juego.objects.get(id=id)
    return render(request, 'detalle_juego.html', {'juego': juego})

@login_required
def crear_categoria(request):
    if request.method == 'POST':
        nombre = request.POST.get('nombre_categoria')
        if nombre:
            Categoria.objects.create(nombre_categoria=nombre)
        return redirect('crear_categoria') 

    return render(request, 'administrar_juegos/crear_categoria.html')

@login_required
def editar_categoria(request, categoria_id):
    categoria = get_object_or_404(Categoria, id=categoria_id)
    if request.method == 'POST':
        nombre = request.POST.get('nombre_categoria')
        if nombre:
            categoria.nombre_categoria = nombre
            categoria.save()
            return redirect('mostrar_categorias')
    return render(request, 'administrar_juegos/editar_categoria.html', {'categoria': categoria})

@login_required
def eliminar_categoria(request, categoria_id):
    categoria = get_object_or_404(Categoria, id=categoria_id)
    if request.method == 'POST':
        categoria.delete()
        return redirect('mostrar_categorias')

@login_required
def mostrar_categorias(request):
    categorias = Categoria.objects.all()
    return render(request, 'administrar_juegos/mostrar_categorias.html', {'categorias': categorias})



def modificar_perfil(request):
    usuario = request.user.usuario 
    if request.method == 'POST':
        nombre_real = request.POST.get('nombre_real')
        correo = request.POST.get('correo')
        direccion_despacho = request.POST.get('direccion_despacho')
        fecha_nacimiento = request.POST.get('fecha_nacimiento')
        usuario.nombre_real = nombre_real
        usuario.correo = correo
        usuario.direccion_despacho = direccion_despacho
        usuario.fecha_nacimiento = fecha_nacimiento
        usuario.save()

        messages.success(request, 'Perfil actualizado correctamente.')
        return redirect('panel_usuario')
    
    return render(request, 'panel_usuario.html', {'usuario': usuario})



from django.shortcuts import render, redirect, get_object_or_404
from .models import Juego, Carrito, ItemCarrito
from django.contrib.auth.decorators import login_required


# @login_required
# def agregar_carrito(request, juego_id):
#     juego = get_object_or_404(Juego, id=juego_id)
#     usuario = request.user

#     # Obtiene el carrito del usuario o lo crea si no existe
#     carrito, created = Carrito.objects.get_or_create(usuario=usuario)

#     # Verifica si el producto ya está en el carrito
#     item, item_created = ItemCarrito.objects.get_or_create(carrito=carrito, producto=juego)

#     if not item_created:
#         # Si el producto ya existe, incrementa la cantidad
#         item.cantidad += 1
#         item.save()

#     # Redirigir a la página anterior
#     return redirect(request.META.get('HTTP_REFERER', 'inicio'))

@login_required
def agregar_carrito(request, juego_id):
    juego = get_object_or_404(Juego, id=juego_id)
    usuario = request.user

    # Obtiene el carrito del usuario o lo crea si no existe
    carrito, created = Carrito.objects.get_or_create(usuario=usuario)

    # Verifica si el producto ya está en el carrito
    item, item_created = ItemCarrito.objects.get_or_create(carrito=carrito, producto=juego)

    if not item_created:
        # Si el producto ya existe, incrementa la cantidad
        item.cantidad += 1
        item.save()
    
    # Guardar en la sesión la ID del último item agregado para usarlo en la animación
    request.session['ultimo_item_agregado'] = item.id
    request.session.modified = True

    # Redirigir a la página anterior
    return redirect(request.META.get('HTTP_REFERER', 'inicio'))



@login_required
def ver_carrito(request):
    usuario = request.user
    carrito = Carrito.objects.filter(usuario=usuario).first()
    items = ItemCarrito.objects.filter(carrito=carrito) if carrito else []
    total_carrito = sum(item.subtotal for item in items)

    return render(request, 'carrito.html', {
        'carrito': items,
        'total_carrito': total_carrito,
    })

@login_required
def eliminar_del_carrito(request, producto_id):
    usuario = request.user
    carrito = Carrito.objects.filter(usuario=usuario).first()
    if carrito:
        ItemCarrito.objects.filter(carrito=carrito, producto_id=producto_id).delete()

    return redirect('ver_carrito')

@login_required
def actualizar_cantidad(request, producto_id):
    if request.method == 'POST':
        nueva_cantidad = int(request.POST.get('cantidad', 1))
        usuario = request.user
        carrito = Carrito.objects.filter(usuario=usuario).first()
        
        if carrito:
            item = ItemCarrito.objects.filter(carrito=carrito, producto_id=producto_id).first()
            if item:
                item.cantidad = nueva_cantidad
                item.save()

    return redirect('ver_carrito')

def carrito_en_contexto(request):
    if request.user.is_authenticated:
        try:
            carrito = Carrito.objects.get(usuario=request.user)
            items = carrito.items.all()
            total_carrito = sum(item.subtotal for item in items)

            # Obtener el ID del último item agregado
            ultimo_item_agregado = request.session.get('ultimo_item_agregado', None)

            # Añadir una marca de 'is_new' a los elementos si coinciden
            for item in items:
                if item.id == ultimo_item_agregado:
                    item.is_new = True
                else:
                    item.is_new = False
            
            # Limpiar la variable de sesión
            if 'ultimo_item_agregado' in request.session:
                del request.session['ultimo_item_agregado']
                request.session.modified = True

        except Carrito.DoesNotExist:
            items = []
            total_carrito = 0
    else:
        items = []
        total_carrito = 0

    return {
        'carrito': items,
        'total_carrito': total_carrito,
    }



@api_view(['GET', 'POST', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def juegos_api(request, id=None):
    if request.method == 'GET':
        if id:
            juego = get_object_or_404(Juego, pk=id)
            serializer = JuegoSerializer(juego)
        else:
            juegos = Juego.objects.all()
            serializer = JuegoSerializer(juegos, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = JuegoSerializer(data=request.data)
        logger.debug(f"Datos del request: {request.data}")
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        juego = get_object_or_404(Juego, pk=id)
        serializer = JuegoSerializer(juego, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        juego = get_object_or_404(Juego, pk=id)
        juego.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


def buscar_juegos(request):
    logger.debug('Ejecutando vista buscar_juegos')
    if request.method == 'POST':
        logger.debug('Buscando juegos en la API')
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
            }
        nombre_juego = request.POST.get('nombre_juego')
        url = f"https://www.giantbomb.com/api/search/?api_key=e4eb5381cdf5cbb6a8396befe44004d110a0df1d&format=json&query='{nombre_juego}'&resources=game"
        response = requests.get(url, headers=headers)
        data = response.json()
        juegos = [resultado for resultado in data['results']]
            
        return render(request, 'administrar_juegos/buscar_juegos.html', {'juegos': juegos})
    return render(request, 'administrar_juegos/buscar_juegos.html')


def detalle_juego_seleccionado(request):
    if request.method == 'POST':
        juego_id = request.POST.get('juego_id')
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
            }
        url = f"https://www.giantbomb.com/api/game/{juego_id}/?api_key=e4eb5381cdf5cbb6a8396befe44004d110a0df1d&format=json"
        response = requests.get(url, headers=headers)
        data = response.json()
        juego = data['results']
        return render(request, 'administrar_juegos/detalle_juego_seleccionado.html', {'juego': juego})

    return redirect('buscar_juegos')


# @api_view(['GET', 'POST', 'PUT', 'DELETE'])
# @permission_classes([IsAuthenticated])
# def categorias_api(request, id=None):
#     if request.method == 'GET':
#         if id:
#             categoria = get_object_or_404(Categoria, pk=id)
#             serializer = CategoriaSerializer(categoria)
#         else:
#             categorias = Categoria.objects.all()
#             serializer = CategoriaSerializer(categorias, many=True)
#         return Response(serializer.data)


@api_view(['GET', 'POST', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def categorias_api(request, id=None):
    if request.method == 'GET':
        if id:
            categoria = get_object_or_404(Categoria, pk=id)
            serializer = CategoriaSerializer(categoria)
        else:
            categorias = Categoria.objects.all()
            serializer = CategoriaSerializer(categorias, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
        data = request.data.copy()

        if 'id' in data:
            del data['id']
        
        serializer = CategoriaSerializer(data=data)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            logger.error(f"Errores en la validación del serializador: {serializer.errors}")
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        if id is None:
            return Response({'error': 'ID es requerido para actualizar una categoría.'}, status=status.HTTP_400_BAD_REQUEST)
        
        categoria = get_object_or_404(Categoria, pk=id)
        data = request.data.copy()
        
        serializer = CategoriaSerializer(categoria, data=data)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            logger.error(f"Errores en la validación del serializador: {serializer.errors}")
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        if id is None:
            return Response({'error': 'ID es requerido para eliminar una categoría.'}, status=status.HTTP_400_BAD_REQUEST)
        
        categoria = get_object_or_404(Categoria, pk=id)
        categoria.delete()
        return Response({'message': 'Categoría eliminada con éxito'}, status=status.HTTP_204_NO_CONTENT)
    
    return Response({'error': 'Método no permitido'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
    

def traducir_texto(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        descripcion_juego = data.get('descripcion_juego', '')

        url = "https://api-free.deepl.com/v2/translate"
        payload = {
            "text": [descripcion_juego],
            "target_lang": "ES"
        }
        headers = {
            'Content-Type': 'application/json',
            'Authorization': 'DeepL-Auth-Key 38880200-ee60-43c1-8d26-51525ec06337:fx'
        }
        response = requests.post(url, headers=headers, json=payload)

        if response.status_code == 200:
            traduccion = response.json()["translations"][0]["text"]
            return JsonResponse({'texto_traducido': traduccion})
        else:
            return JsonResponse({'error': 'Error al traducir el texto'}, status=500)
