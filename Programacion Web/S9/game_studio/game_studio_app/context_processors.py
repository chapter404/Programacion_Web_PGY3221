from .models import Carrito

def carrito(request):
    if request.user.is_authenticated:
        try:
            carrito = Carrito.objects.get(usuario=request.user)
            items = carrito.items.all()
        except Carrito.DoesNotExist:
            carrito = None
            items = []
    else:
        carrito = None
        items = []
        
    return {'carrito': carrito, 'carrito_items': items}
