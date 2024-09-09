from django.db import migrations, models

class Migration(migrations.Migration):

    dependencies = [
        ('game_studio_app', '0002_categoria_games'),
    ]

    operations = [
        migrations.AddField(
            model_name='games',
            name='id',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
    ]
