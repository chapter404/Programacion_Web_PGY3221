document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('formulario-registro').addEventListener('submit', function(event){
        event.preventDefault();
        let valid = true;
        let mensaje_error = '';

        const nombre_real = document.getElementById('nombre_real').value.trim();
        const nombre_usuario = document.getElementById('nombre_usuario').value.trim();
        const correo = document.getElementById('correo').value.trim();
        const clave = document.getElementById('clave').value.trim();
        const confirmacion_clave = document.getElementById('confirmacion_clave').value.trim();
        const fecha_nacimiento = new Date(document.getElementById('fecha_nacimiento').value.trim());

        const hoy = new Date();

        const edad_usuario = hoy.getFullYear() - fecha_nacimiento.getFullYear();
        const mes = hoy.getMonth() - fecha_nacimiento.getMonth();

        if (!nombre_real) {
            mensaje_error = 'El nombre es obligatorio';
            document.getElementById('nombre_real_error').textContent = mensaje_error;
            valid = false;
        } else {
            document.getElementById('nombre_real_error').textContent = '';
        }

        if (!nombre_usuario) {
            mensaje_error = 'El nombre de usuario es obligatorio';
            document.getElementById('nombre_usuario_error').textContent = mensaje_error;
            valid = false;
        } else {
            document.getElementById('nombre_usuario_error').textContent = '';
        }

        if (!correo || !/\S+@\S+\.\S+/.test(correo)) {
            mensaje_error = 'El formato no es válido';
            document.getElementById('correo_error').textContent = mensaje_error;
            valid = false;
        } else {
            document.getElementById('correo_error').textContent = '';
        }

        if (!clave || !/(?=.*\d)(?=.*[A-Z]).{6,18}/.test(clave)) {
            mensaje_error = 'La contraseña debe contener al menos 6 caracteres, incluyendo una letra mayúscula y un número';
            document.getElementById('clave_error').textContent = mensaje_error;
            valid = false;
        } else {
            document.getElementById('clave_error').textContent = '';
        }

        if (clave !== confirmacion_clave) {
            mensaje_error = 'Las contraseñas no coinciden';
            document.getElementById('confirmacion_clave_error').textContent = mensaje_error;
            valid = false;
        } else {
            document.getElementById('confirmacion_clave_error').textContent = '';
        }

        if (edad_usuario < 13 || (edad_usuario === 13 && mes < 0)) {
            mensaje_error = 'Debes ser mayor de 13 años para registrarte';
            document.getElementById('fecha_nacimiento_error').textContent = mensaje_error;
            valid = false;
        }

    });
});
