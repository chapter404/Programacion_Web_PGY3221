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
    path('panel_inicio_sesion', views.panel_inicio_sesion, name='panel_inicio_sesion'),
    path('iniciar_sesion', views.iniciar_sesion, name='iniciar_sesion'),
    path('cerrar_sesion/', LogoutView.as_view(), name='cerrar_sesion'),
    path('panel_usuario/', views.panel_usuario, name='panel_usuario'),
]