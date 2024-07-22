#!/bin/bash

echo "Running the project"
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py runserver 0.0.0.0:8080
