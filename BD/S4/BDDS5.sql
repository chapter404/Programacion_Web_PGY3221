-- Función para obtener el porcentaje según precio
CREATE OR REPLACE FUNCTION obtener_porcentaje_precio(v_precio NUMBER)
RETURN NUMBER
IS
    v_porcentaje NUMBER;
BEGIN
    SELECT porcentaje
    INTO v_porcentaje
    FROM tramo_precio
    WHERE v_precio BETWEEN valor_minimo AND valor_maximo;

    RETURN v_porcentaje;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;

-- Procedimiento para obtener boletas y unidades de un producto en un período
CREATE OR REPLACE PROCEDURE obtener_ventas_producto(
    p_cod_producto IN NUMBER,
    p_periodo IN VARCHAR2,
    p_total_boletas OUT NUMBER,
    p_total_unidades OUT NUMBER
)
IS
BEGIN
    SELECT COUNT(DISTINCT numboleta), SUM(cantidad)
    INTO p_total_boletas, p_total_unidades
    FROM detalle_boleta db
    JOIN boleta b ON db.numboleta = b.numboleta
    WHERE db.codproducto = p_cod_producto
      AND TO_CHAR(b.fecha, 'MM-YYYY') = p_periodo;

END;

-- Función para contar boletas de un cliente en un período
CREATE OR REPLACE FUNCTION obtener_cantidad_boletas(
    p_rut_cliente IN VARCHAR2,
    p_periodo IN VARCHAR2
)
RETURN NUMBER
IS
    v_cantidad_boletas NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad_boletas
    FROM boleta
    WHERE rutcliente = p_rut_cliente
      AND TO_CHAR(fecha, 'MM-YYYY') = p_periodo;

    RETURN v_cantidad_boletas;
END;


-- Función para contar facturas de un cliente en un período
CREATE OR REPLACE FUNCTION obtener_cantidad_facturas(
    p_rut_cliente IN VARCHAR2,
    p_periodo IN VARCHAR2
)
RETURN NUMBER
IS
    v_cantidad_facturas NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad_facturas
    FROM factura
    WHERE rutcliente = p_rut_cliente
      AND TO_CHAR(fecha, 'MM-YYYY') = p_periodo;

    RETURN v_cantidad_facturas;
END;

-- Procedimiento para generar informes
CREATE OR REPLACE PROCEDURE generar_informes(
    p_periodo IN VARCHAR2,
    p_credito_limite IN NUMBER
)
IS
    CURSOR c_clientes IS
        SELECT rutcliente, nombre, NVL(comuna.descripcion, 'SIN COMUNA'), credito
        FROM cliente
        LEFT JOIN comuna ON cliente.codcomuna = comuna.codcomuna
        WHERE credito >= p_credito_limite;

    CURSOR c_productos IS
        SELECT codproducto, vunitario
        FROM producto;

    v_total_documentos NUMBER;
    v_total_boletas NUMBER;
    v_total_unidades NUMBER;
    v_porcentaje_aplicado NUMBER;
    v_nuevo_precio NUMBER;
BEGIN
    -- Limpiar tablas de resumen
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_cliente';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_producto';

    -- Procesar clientes
    FOR r_cliente IN c_clientes LOOP
        v_total_documentos := obtener_cantidad_boletas(r_cliente.rutcliente, p_periodo)
                              + obtener_cantidad_facturas(r_cliente.rutcliente, p_periodo);

        INSERT INTO resumen_cliente (rut_cliente, nombre_cliente, nombre_comuna, total_documentos, credito)
        VALUES (r_cliente.rutcliente, r_cliente.nombre, r_cliente.descripcion, v_total_documentos, r_cliente.credito);
    END LOOP;

    -- Procesar productos
    FOR r_producto IN c_productos LOOP
        obtener_ventas_producto(r_producto.codproducto, p_periodo, v_total_boletas, v_total_unidades);

        v_porcentaje_aplicado := obtener_porcentaje_precio(r_producto.vunitario);
        v_nuevo_precio := r_producto.vunitario * (1 + v_porcentaje_aplicado);

        INSERT INTO resumen_producto (cod_producto, total_boletas, total_unidades, valor_unitario, porcentaje_aplicado, precio)
        VALUES (r_producto.codproducto, v_total_boletas, v_total_unidades, r_producto.vunitario, v_porcentaje_aplicado, v_nuevo_precio);
    END LOOP;
END;


BEGIN
    generar_informes('03-2021', 500000);
END;

SELECT * FROM resumen_cliente;
SELECT * FROM resumen_producto;



