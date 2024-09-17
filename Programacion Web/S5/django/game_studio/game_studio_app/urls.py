from django.urls import path
from . import views
from django.contrib import admin
from django.contrib.auth import views as auth_views
from django.contrib.auth.views import LogoutView

urlpatterns = [
    path('', views.inicio, name='inicio'),
    path('terror', views.terror, name="terror"),
    path('accion', views.accion, name="accion"),
    path('mundo_abierto', views.mundo_abierto, name="mundo_abierto"),
    path('free_to_play', views.free_to_play, name="free_to_play"),
    path('supervivencia', views.supervivencia, name="supervivencia"),
    path('carreras', views.carreras, name="carreras"),
    path('silent_hill', views.silent_hill, name="silent_hill"),
    path('resident_evil', views.resident_evil, name="resident_evil"),
    path('brawl', views.brawl, name="brawl"),
    path('zelda', views.zelda, name="zelda"),
    path('roblox', views.roblox, name="roblox"),
    path('sims', views.sims, name="sims"),
    path('csgo', views.csgo, name="csgo"),
    path('cod', views.cod, name="cod"),
    path('ocean', views.ocean, name="ocean"),
    path('last', views.last, name="last"),
    path('mario', views.mario, name="mario"),
    path('crash', views.crash, name="crash"),
    path('registro', views.registro, name="registro"),
    path('registrar', views.registrar, name="registrar"),
    path('iniciar_sesion', views.iniciar_sesion, name='iniciar_sesion'),
    path('cerrar_sesion/', LogoutView.as_view(next_page='iniciar_sesion'), name='cerrar_sesion'),
    path('panel_usuario/', views.panel_usuario, name='panel_usuario'),
    path('juegos/', views.mostrar_juegos, name='mostrar_juegos'),
    path('juegos/crear/', views.crear_juego, name='crear_juego'),
    path('juegos/editar/<int:juego_id>/', views.editar_juego, name='editar_juego'),
    path('juegos/eliminar/<int:juego_id>/', views.eliminar_juego, name='eliminar_juego'),
    path('categoria/<str:categoria>/', views.categoria_juegos, name='categoria_juegos'),
    path('juego/<int:id>/', views.detalle_juego, name='detalle_juego'),
    path('mostrar_categorias/', views.mostrar_categorias, name='mostrar_categorias'),
    path('crear_categoria/', views.crear_categoria, name='crear_categoria'),
    path('editar_categoria/<int:categoria_id>/', views.editar_categoria, name='editar_categoria'),
    path('eliminar_categoria/<int:categoria_id>/', views.eliminar_categoria, name='eliminar_categoria'),
    path('modificar_perfil/', views.modificar_perfil, name='modificar_perfil'),
    path('carrito/', views.ver_carrito, name='ver_carrito'),  # Ruta para ver el carrito
    # path('carrito/eliminar/<int:producto_id>/', views.eliminar_del_carrito, name='eliminar_del_carrito'),  # Ruta para eliminar un producto del carrito
]