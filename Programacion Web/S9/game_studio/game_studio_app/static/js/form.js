document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('formulario-registro').addEventListener('submit', function(event){
        event.preventDefault();

        let valid = true;
        let mensaje_error = '';

        const campos = {
            nombre_real: document.getElementById('nombre_real'),
            nombre_usuario: document.getElementById('nombre_usuario'),
            correo: document.getElementById('correo'),
            clave: document.getElementById('clave'),
            confirmacion_clave: document.getElementById('confirmacion_clave'),
            fecha_nacimiento: document.getElementById('fecha_nacimiento')
        };

        const errores = {
            nombre_real_error: 'El campo es obligatorio',
            nombre_usuario_error: 'El campo es obligatorio',
            correo_error: 'El campo es obligatorio y debe tener un formato válido',
            clave_error: 'La contraseña debe contener al menos 6 caracteres, incluyendo una letra mayúscula y un número',
            confirmacion_clave_error: 'Las contraseñas no coinciden',
            fecha_nacimiento_error: 'Debes ser mayor de 13 años para registrarte'
        };

        for (let [campo, elemento] of Object.entries(campos)) {
            const valor = elemento.value.trim();
            const errorElement = document.getElementById(`${campo}_error`);
            
            if (!valor) {
                errorElement.textContent = errores[`${campo}_error`];
                valid = false;
            } else {
                errorElement.textContent = '';
            }
        }

        if (campos.correo.value && !/\S+@\S+\.\S+/.test(campos.correo.value.trim())) {
            document.getElementById('correo_error').textContent = 'El formato del correo no es válido';
            valid = false;
        }

        if (campos.clave.value && !/(?=.*\d)(?=.*[A-Z]).{6,18}/.test(campos.clave.value.trim())) {
            document.getElementById('clave_error').textContent = errores.clave_error;
            valid = false;
        }

        if (campos.clave.value !== campos.confirmacion_clave.value) {
            document.getElementById('confirmacion_clave_error').textContent = errores.confirmacion_clave_error;
            valid = false;
        }

        const fecha_nacimiento = new Date(campos.fecha_nacimiento.value.trim());
        const hoy = new Date();
        const edad_usuario = hoy.getFullYear() - fecha_nacimiento.getFullYear();
        const mes = hoy.getMonth() - fecha_nacimiento.getMonth();

        if (edad_usuario < 13 || (edad_usuario === 13 && mes < 0)) {
            document.getElementById('fecha_nacimiento_error').textContent = errores.fecha_nacimiento_error;
            valid = false;
        }

        if (valid) {
            document.getElementById('mensaje_error').textContent = '';
            document.getElementById('formulario-registro').submit();
        } else {
            document.getElementById('mensaje_error').textContent = 'Por favor, corrija el formulario';
        }
    });
});
