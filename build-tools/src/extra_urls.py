####################################################################################################
# Enable the Django Debug Toolbar in development mode
from django.conf import settings

if settings.DEBUG:
    from debug_toolbar.toolbar import debug_toolbar_urls
    urlpatterns += debug_toolbar_urls()