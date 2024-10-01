# Generated by Django 5.1 on 2024-09-17 01:06

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('game_studio_app', '0001_initial'),
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
            name='Carrito',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('usuario', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='game_studio_app.usuario')),
            ],
        ),
        migrations.CreateModel(
            name='ItemCarrito',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('producto', models.CharField(max_length=255)),
                ('cantidad', models.PositiveIntegerField(default=1)),
                ('precio', models.DecimalField(decimal_places=2, max_digits=10)),
                ('carrito', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items', to='game_studio_app.carrito')),
            ],
        ),
        migrations.CreateModel(
            name='Juego',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('titulo_juego', models.CharField(max_length=100)),
                ('precio_juego', models.DecimalField(decimal_places=2, max_digits=10)),
                ('descripcion_juego', models.TextField()),
                ('imagen_juego', models.ImageField(blank=True, null=True, upload_to='juegos/imagenes/')),
                ('categoria_juego', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='juegos', to='game_studio_app.categoria')),
            ],
        ),
        migrations.CreateModel(
            name='MetodoPago',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('tipo_pago', models.CharField(choices=[('tarjeta', 'Tarjeta'), ('paypal', 'PayPal'), ('transferencia', 'Transferencia Bancaria')], max_length=50)),
                ('detalles', models.CharField(max_length=255)),
                ('usuario', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='game_studio_app.usuario')),
            ],
        ),
        migrations.CreateModel(
            name='ModificarPerfil',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre_real', models.CharField(blank=True, max_length=255, null=True)),
                ('correo', models.EmailField(blank=True, max_length=254, null=True)),
                ('direccion_despacho', models.CharField(blank=True, max_length=255, null=True)),
                ('fecha_nacimiento', models.DateField(blank=True, null=True)),
                ('usuario', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='game_studio_app.usuario')),
            ],
        ),
    ]
