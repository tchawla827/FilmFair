# Generated by Django 2.2.3 on 2019-09-01 10:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0002_shows_date'),
    ]

    operations = [
        migrations.AddField(
            model_name='movie',
            name='movie_trailer',
            field=models.CharField(default='null', max_length=300),
        ),
    ]
