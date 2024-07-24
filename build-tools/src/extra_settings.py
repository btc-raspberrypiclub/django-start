####################################################################################################
# Custom settings needed for initializing the environment

# Import the system environment variables
from os import environ as env

DEBUG = env.get('DEBUG', default="False")

STATIC_ROOT = BASE_DIR / 'static'

ALLOWED_HOSTS = env.get('ALLOWED_HOSTS', default="localhost").split(',')

DATABASES = {
    'default': {
        "ENGINE": env.get('ENGINE', default="django.db.backends.postgresql"),
        "NAME": env.get('NAME', default="webeginedatabase"),
        "USER": env.get('USER', default="siteuser"),
        "PASSWORD": env.get('PASSWORD', default="supersecretpassword"),
        "HOST": env.get('HOST', default="db"),
        "PORT": env.get('PORT', default="5432"),
    }
}

INSTALLED_APPS += [
    'django_extensions',
    'debug_toolbar',
]

MIDDLEWARE += [
    'debug_toolbar.middleware.DebugToolbarMiddleware',
]

DEBUG_TOOLBAR_CONFIG = {
    'SHOW_TOOLBAR_CALLBACK': lambda request: False if request.META.get('HTTP_X_REQUESTED_WITH') == 'XMLHttpRequest' else True,
}
