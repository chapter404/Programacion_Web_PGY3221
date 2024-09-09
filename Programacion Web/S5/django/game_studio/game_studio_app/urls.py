from django.urls import path
from .views import inicio, registro, terror, accion, mundo_abierto, free_to_play, supervivencia, carreras, silent_hill, resident_evil, cod, brawl, zelda, roblox, sims, csgo, ocean, last, mario, crash
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', views.home, name='home'),
    path('registro/', views.registro, name='registro'),
    path('protegida/', views.vista_protegida, name='protegida'),
    path('productos/', views.listar_productos, name='listar_productos'),
    path('productos/crear/', views.crear_producto, name='crear_producto'),
    path('productos/editar/<int:pk>/', views.editar_producto, name='editar_producto'),
    path('productos/eliminar/<int:pk>/', views.eliminar_producto, name='eliminar_producto'),
    path('', inicio, name="inicio"),
    # path('registro', registro, name="registro"),
    path('terror', terror, name="terror"),
    path('accion', accion, name="accion"),
    path('mundo_abierto', mundo_abierto, name="mundo_abierto"),
    path('free_to_play', free_to_play, name="free_to_play"),
    path('supervivencia', supervivencia, name="supervivencia"),
    path('carreras', carreras, name="carreras"),
    path('silent_hill', silent_hill, name="silent_hill"),
    path('resident_evil', resident_evil, name="resident_evil"),
    path('cod', cod, name="cod"),
    path('brawl', brawl, name="brawl"),
    path('zelda', zelda, name="zelda"),
    path('roblox', roblox, name="roblox"),
    path('sims', sims, name="sims"),
    path('csgo', csgo, name="csgo"),
    path('ocean', ocean, name="ocean"),
    path('last', last, name="last"),
    path('mario', mario, name="mario"),
    path('crash', crash, name="crash"),
    path('login/', auth_views.LoginView.as_view(template_name='game_studio_app/login.html'), name='login'),
    path('logout/', auth_views.LoginView.as_view(), name='logout'),

]