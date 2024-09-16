from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect
from django.conf import settings
from django.conf.urls.static import static
from . import views

urlpatterns = [
  
    path('admin/', admin.site.urls),
    
    path('game_studio/', include('game_studio_app.urls')),  
    
    path('index/', lambda request: redirect('index')),  

    path('carrito/', views.carrito, name='carrito'), 

    path('index/', views.index, name='index'),
]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)



