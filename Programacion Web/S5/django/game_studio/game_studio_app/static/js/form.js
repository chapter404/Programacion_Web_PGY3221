function validar() {
    let valid = true;

    const form = document.getElementById('formulario-registro');
    const urlRegistrar = form.getAttribute('data-url');

    const nombre_real = document.getElementById('nombre_real').value.trim();
    const nombre_usuario = document.getElementById('nombre_usuario').value.trim();
    const correo = document.getElementById('correo').value.trim();
    const clave = document.getElementById('clave').value.trim();
    const confirmacion_clave = document.getElementById('confirmacion_clave').value.trim();
    const fecha_nacimiento = document.getElementById('fecha_nacimiento').value.trim();

    if (!nombre_real || !nombre_usuario || !correo || !clave || !confirmacion_clave || !fecha_nacimiento) {
        alert('Todos los campos son obligatorios');
        return;
    }

    if (clave !== confirmacion_clave) {
        alert('Las contraseñas no coinciden');
        return;
    }

    const csrfToken = document.querySelector('input[name="csrfmiddlewaretoken"]').value;

    const formData = {
        nombre_real: nombre_real,
        nombre_usuario: nombre_usuario,
        correo: correo,
        clave: clave,
        confirmacion_clave: confirmacion_clave,
        fecha_nacimiento: fecha_nacimiento,
        csrfmiddlewaretoken: csrfToken
    };

    fetch(urlRegistrar, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrfToken
        },
        body: JSON.stringify(formData)
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
            throw new Error('Error en la respuesta del servidor');
        }
    })
    .then(data => {
        if (data.success) {
            alert('Registro exitoso');
            document.getElementById('formulario-registro').reset();
        } else {
            alert(data.error || 'Error en el registro');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error al enviar los datos');
    });
}
