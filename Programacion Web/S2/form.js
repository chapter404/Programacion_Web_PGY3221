document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('formulario-registro').addEventListener('submit', validarFormulario){
        event.preventDefault();
        let valid = true;
        let mensaje_error = '';

        const nombre_real = document.getElementById('nombre_real').value.trim();
        const nombre_usuario = document.getElementById('nombre_usuario').value.trim();
        const correo = document.getElementById('correo').value.trim();
        const clave = document.getElementById('clave').value.trim();
        const confirmacion_clave = document.getElementById('confirmacion_clave').value.trim();
        const fecha_nacimiento = document.getElementById('fecha_nacimiento').value.trim();

        const hoy = new Date();

        const edad_usuario = hoy.getFullYear() - fecha_nacimiento.getFullYear();
        const mes = hoy.getMonth() - fecha_nacimiento.getMonth();

        if (!nombre_real) {
            valid = false;
            mensaje_error += 'El campo nombre real es requerido.\n';
        }

    }
})