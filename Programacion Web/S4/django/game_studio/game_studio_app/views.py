from django.shortcuts import render

def inicio(request):
    return render(request, 'index.html')

def registro(request):
    return render(request, 'form.html')

def terror(request):
    return render(request, 'terror.html')

def accion(request):
    return render(request, 'accion.html')

def mundo_abierto(request):
    return render(request, 'mundo_abierto.html')

def free_to_play(request):
    return render(request, 'free_to_play.html')

def supervivencia(request):
    return render(request, 'supervivencia.html')

def carreras(request):
    return render(request, 'carreras.html')

def silent_hill(request):
    return render(request, 'silent_hill_2.html')
