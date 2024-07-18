#!/bin/sh

# The script checks to see if the project already exists. If it doesn't, 
# it creates the project. If it does, it updates and runs the server

# Check to see if the project already exists
if [ ! -d "/usr/src/app/webengine" ]; then
    # Create the project if it doesn't exist
    django-admin startproject webengine .

    # Exit the script and the container
    exit 0
fi

python manage.py migrate
python manage.py collectstatic --noinput

python manage.py runserver 0.0.0.0:8080
 
