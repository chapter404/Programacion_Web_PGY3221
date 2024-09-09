from django.urls import path
from .views import inicio, registro, terror, accion, mundo_abierto, free_to_play, supervivencia, carreras, silent_hill, resident_evil, cod, brawl, zelda, roblox, sims, csgo, ocean, last, mario, crash

urlpatterns = [
    path('inicio', inicio, name="inicio"),
    path('registro', registro, name="registro"),
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

]