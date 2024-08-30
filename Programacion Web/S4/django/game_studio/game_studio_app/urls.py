from django.urls import path
from .views import inicio, registro, terror, accion, mundo_abierto, free_to_play, supervivencia, carreras

urlpatterns = [
    path('', inicio, name="inicio"),
    path('registro', registro, name="registro"),
    path('terror', terror, name="terror"),
    path('accion', accion, name="accion"),
    path('mundo_abierto', mundo_abierto, name="mundo_abierto"),
    path('free_to_play', free_to_play, name="free_to_play"),
    path('supervivencia', supervivencia, name="supervivencia"),
    path('carreras', carreras, name="carreras")
]