/***** CASO 1 *****/

/* Función que devuelve el porcentaje asociado a un producto */
CREATE OR REPLACE FUNCTION fn_obtener_porcentaje_producto(p_precio_producto IN NUMBER)
RETURN NUMBER
IS
    v_porcentaje_producto tramo_precio.porcentaje%TYPE := 0;
BEGIN
    SELECT
        porcentaje
    INTO
        v_porcentaje_producto
    FROM
        tramo_precio
    WHERE
        p_precio_producto BETWEEN valor_minimo AND valor_maximo;    
        
    RETURN v_porcentaje_producto;

END;



/* Procedimiento que registra la cantidad de boletas y unidades vendidas de un producto */
CREATE OR REPLACE PROCEDURE sp_calcular_ventas_producto(
p_codigo_producto IN NUMBER,
p_periodo IN VARCHAR2,
p_cantidad_boletas OUT NUMBER,
p_unidades_vendidas OUT NUMBER)
IS
BEGIN   
    SELECT
        NVL(COUNT(db.codproducto), 0),
        NVL(SUM(db.cantidad), 0)
    INTO
        p_cantidad_boletas,
        p_unidades_vendidas
    FROM
        boleta b
    JOIN
        detalle_boleta db ON b.numboleta = db.numboleta
    WHERE
        db.codproducto = p_codigo_producto AND
        TO_CHAR(b.fecha, 'MM-YYYY') = p_periodo;
END;



/* Función que retorna la cantidad de boletas emitidas a un cliente por periodo */
CREATE OR REPLACE FUNCTION fn_obtener_boletas_cliente(p_rut IN VARCHAR2, p_periodo IN VARCHAR2)
RETURN NUMBER
IS
    v_boletas_emitidas NUMBER := 0;
BEGIN
    SELECT
        COUNT(b.rutcliente)
    INTO
        v_boletas_emitidas
    FROM
        cliente c
    JOIN
        boleta b ON c.rutcliente = b.rutcliente
    WHERE
        c.rutcliente = p_rut AND
        TO_CHAR(b.fecha, 'MM-YYYY') = p_periodo;
        
    RETURN v_boletas_emitidas;
END;



/* Función que retorna la cantidad de facturas emitidas a un cliente por periodo */
CREATE OR REPLACE FUNCTION fn_obtener_facturas_cliente(p_rut IN VARCHAR2, p_periodo IN VARCHAR2)
RETURN NUMBER
IS
    v_facturas_emitidas NUMBER := 0;
BEGIN
    SELECT
        COUNT(f.rutcliente)
    INTO
        v_facturas_emitidas
    FROM
        cliente c
    JOIN
        factura f ON c.rutcliente = f.rutcliente
    WHERE
        c.rutcliente = p_rut AND
        TO_CHAR(f.fecha, 'MM-YYYY') = p_periodo;
        
    RETURN v_facturas_emitidas;
END;



/* Procedimiento principal, generador de los informes */
CREATE OR REPLACE PROCEDURE sp_generar_informes(p_periodo VARCHAR2, p_monto_limite NUMBER)
IS
/* Cursor que genera los registros para el informe 1 */
CURSOR cur_clientes IS
    SELECT
        cli.rutcliente AS RUT,
        cli.nombre AS NOMBRE,
        NVL(com.descripcion, 'SIN COMUNA') AS DESCRIPCION,
        fn_obtener_boletas_cliente(cli.rutcliente, p_periodo) +
        fn_obtener_facturas_cliente(cli.rutcliente, p_periodo) AS TOTAL_DOCUMENTOS,
        cli.credito AS CREDITO
    FROM
        cliente cli
    LEFT JOIN
        comuna com ON cli.codcomuna = com.codcomuna
    WHERE
        cli.credito >= p_monto_limite;
/* Cursor para iterar sobre los productos y co-generar el informe 2 */
CURSOR cur_productos IS
    SELECT
        codproducto,
        vunitario
    FROM
        producto;
/* Variables ocupadas para el informe 2 */
    v_cantidad_boletas NUMBER;
    v_unidades_vendidas NUMBER;
    v_porcentaje tramo_precio.porcentaje%TYPE;
BEGIN
/* Crear informe 1 */

	EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_cliente'; -- Limpiar tabla antes de almacenar el informe 1
    FOR cliente IN cur_clientes LOOP
        INSERT INTO resumen_cliente
        VALUES(
            cliente.rut,
            cliente.nombre,
            cliente.descripcion,
            cliente.total_documentos,
            cliente.credito
        );
    END LOOP;
/* Crear informe 2 */ 
	EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_producto'; -- Limpiar tabla antes de almacenar el informe 2
    FOR reg_producto IN cur_productos LOOP
        sp_calcular_ventas_producto(reg_producto.codproducto, p_periodo, v_cantidad_boletas, v_unidades_vendidas);
        v_porcentaje := fn_obtener_porcentaje_producto(reg_producto.vunitario);
        INSERT INTO resumen_producto
        VALUES(
        reg_producto.codproducto,
        v_cantidad_boletas,
        v_unidades_vendidas,
        reg_producto.vunitario,
        v_porcentaje, 
        reg_producto.vunitario*(1+v_porcentaje));
    END LOOP;
END;



/* Ejecutar el procedimiento principal */
EXECUTE sp_generar_informes('03-2023', 500000)

/* Consultar los registros de la tabla con el informe 1 */
SELECT * FROM resumen_cliente;

/* Consultar los registros de la tabla con el informe 2 */
SELECT * FROM resumen_producto;


