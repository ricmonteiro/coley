# Generated by Django 4.1.6 on 2023-03-20 22:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('coleyapi', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Tissuetype',
            fields=[
                ('id', models.SmallAutoField(primary_key=True, serialize=False)),
                ('tissue_description', models.CharField(max_length=255)),
            ],
            options={
                'db_table': 'tissuetype',
                'managed': False,
            },
        ),
    ]