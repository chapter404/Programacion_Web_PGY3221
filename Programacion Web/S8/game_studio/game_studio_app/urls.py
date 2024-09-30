''' Este archivo se encarga de manejar las rutas de la aplicación, es decir, las URL que se pueden visitar en la página web. '''

from django.urls import path
from . import views
from django.contrib.auth.views import LogoutView
from django.conf import settings
from django.conf.urls.static import static
from .views import CustomPasswordResetView

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
    path('carrito/', views.ver_carrito, name='ver_carrito'),
    path('agregar_carrito/<int:juego_id>/', views.agregar_carrito, name='agregar_carrito'),
    path('carrito/eliminar/<int:producto_id>/', views.eliminar_del_carrito, name='eliminar_del_carrito'),
    path('carrito/actualizar/<int:producto_id>/', views.actualizar_cantidad, name='actualizar_cantidad'),
    path('api/juegos/', views.juegos_api, name='juegos_api'),
    path('api/juegos/<int:id>/', views.juegos_api, name='juego_api_detalle'),
    path('api/categorias/', views.categorias_api, name='categorias_api'),
    path('api/categorias/<int:id>/', views.categorias_api, name='categorias_api_detalle'),
    path('buscar_juegos/', views.buscar_juegos, name='buscar_juegos'),
    path('detalle_juego_seleccionado', views.detalle_juego_seleccionado, name='detalle_juego_seleccionado'),
    path('traducir_texto', views.traducir_texto, name='traducir_texto'),
    path('ver_carrito/', views.ver_carrito, name='ver_carrito'),
    path('recuperar_contraseña/', views.recuperar_contraseña, name='recuperar_contraseña'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
