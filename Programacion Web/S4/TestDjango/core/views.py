from django.shortcuts import render

# Create your views here.

def libros(request):
    return render(request, "index.html")

def crear(request):
    return render(request, "index.html")