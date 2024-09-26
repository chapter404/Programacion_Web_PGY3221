document.getElementById("btn-traducir").addEventListener("click", function() {
    const descripcion = document.getElementById("id_descripcion_juego").value;

    fetch(url_traducir, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": document.querySelector("[name=csrfmiddlewaretoken]").value,
        },
        body: JSON.stringify({ descripcion_juego: descripcion })
    })
    .then(response => {
        console.log(response); 
        return response.json();
    })
    .then(data => {
        console.log(data);
        document.getElementById("id_descripcion_juego").value = data.texto_traducido;
    })
    .catch(error => console.error("Error:", error));
});
