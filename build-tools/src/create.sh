#!/bin/bash


# Check to see if the project already exists
if [ ! -d "/usr/src/app/webengine" ]; then

  # Only create the project if it doesn't already exist
  case "$1" in
    cms)
      echo "Creating the CMS project"
      # Create the project (Django CMS)
      djangocms webengine .

      ;;
    *)
      echo "Creating the basic project"
      # Create the project (basic Django)
      django-admin startproject webengine .
      ;;
  esac

  # Copy the extra settings and urls files to the project
  cat /usr/local/src/app/extra_settings.py >> /usr/src/app/webengine/settings.py
  cat /usr/local/src/app/extra_urls.py >> /usr/src/app/webengine/urls.py


  # Run the database/code migrations
  ./manage.py migrate

  # Create the superuser (will prompt the user for values - requires  `-it` flag)
  ./manage.py createsuperuser

fi
