# Generated by Django 5.0.7 on 2024-09-17 02:28

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Categoria',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre_categoria', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Juego',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('titulo_juego', models.CharField(max_length=100)),
                ('precio_juego', models.DecimalField(decimal_places=2, max_digits=10)),
                ('descripcion_juego', models.TextField()),
                ('imagen_juego', models.ImageField(blank=True, null=True, upload_to='imagenes/')),
                ('categoria_juego', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='juegos', to='game_studio_app.categoria')),
            ],
        ),
        migrations.CreateModel(
            name='Usuario',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre_real', models.CharField(max_length=255)),
                ('nombre_usuario', models.CharField(max_length=255, unique=True)),
                ('correo', models.EmailField(max_length=254, unique=True)),
                ('direccion_despacho', models.CharField(blank=True, max_length=255, null=True)),
                ('fecha_nacimiento', models.DateField()),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
