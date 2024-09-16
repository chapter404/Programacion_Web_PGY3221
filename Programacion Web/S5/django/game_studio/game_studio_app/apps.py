from django.apps import AppConfig


class GameStudioAppConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'game_studio_app'
    verbose_name = 'Game Studio Application'  # Nombre legible para el admin

    