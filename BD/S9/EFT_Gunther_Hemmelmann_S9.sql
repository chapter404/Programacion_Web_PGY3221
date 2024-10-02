/* PARTE 1 - Trigger */

/* Trigger que actualiza la tabla bitacora al cambiar el sueldo de un vendedor */
CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_BITACORA
AFTER UPDATE ON VENDEDOR
FOR EACH ROW
DECLARE
    v_sueldo_antiguo NUMBER(8);
    v_sueldo_nuevo NUMBER(8);
    v_diferencia_sueldo NUMBER(8);
BEGIN
    v_sueldo_antiguo := :OLD.sueldo_base;
    v_sueldo_nuevo := :NEW.sueldo_base;
    
    IF v_sueldo_nuevo != v_sueldo_antiguo THEN
        v_diferencia_sueldo := v_sueldo_nuevo - v_sueldo_antiguo;
        INSERT INTO BITACORA
        VALUES(seq_bitacora.NEXTVAL,
               :NEW.rutvendedor,
               v_sueldo_antiguo,
               v_sueldo_nuevo,
               v_diferencia_sueldo);
    END IF;
END;


/* Pruebas para verificar la acción del trigger */

/* Disminución de sueldo a un vendedor */ 
UPDATE
    VENDEDOR
SET
    sueldo_base = 500000
WHERE
    rutvendedor = '10656569-K' ;

/* Aumento de sueldo a un vendedor */ 
UPDATE
    VENDEDOR
SET
    sueldo_base = 450000
WHERE
    rutvendedor = '12456778-1' ;

/* Consulta a la tabla bitacora */
SELECT *
FROM BITACORA;




/* PARTE 2 - Paquete */

/* Paquete con herramientas para generar el informe con los porcentajes de venta de cada vendedor */

/* Declaración del paquete */
CREATE OR REPLACE PACKAGE PKG_PORCENTAJE_VENTAS_VENDEDOR 
IS
  v_anio_periodo NUMBER(4);
  v_total_ventas NUMBER;
  v_mensaje_error VARCHAR2(255);
  
  FUNCTION FN_OBTENER_TOTAL_VENTAS_VENDEDOR(p_rut_vendedor VARCHAR2) RETURN NUMBER;
  
  PROCEDURE SP_GENERAR_INFORME_PORCENTAJE_VENDEDOR;
  
  PROCEDURE SP_REGISTRAR_ERROR(p_rutina IN VARCHAR2, p_mensaje_error IN VARCHAR2);
  
END PKG_PORCENTAJE_VENTAS_VENDEDOR;


/* Cuerpo del paquete */
CREATE OR REPLACE PACKAGE BODY PKG_PORCENTAJE_VENTAS_VENDEDOR
IS
    PROCEDURE SP_REGISTRAR_ERROR(p_rutina IN VARCHAR2, p_mensaje_error IN VARCHAR2)
    IS
    BEGIN
    EXECUTE IMMEDIATE
      'INSERT INTO ERROR_PROCESOS_MENSUALES
       VALUES (seq_error.NEXTVAL, :1, :2)'
    USING
        p_rutina, p_mensaje_error;
    END SP_REGISTRAR_ERROR;


    FUNCTION FN_OBTENER_TOTAL_VENTAS_VENDEDOR(p_rut_vendedor VARCHAR2)
    RETURN NUMBER
    IS
    v_monto_total_ventas NUMBER;    
    BEGIN
    SELECT
        NVL(SUM(total), 0)
    INTO
        v_monto_total_ventas
    FROM
        BOLETA
    WHERE
        rutvendedor = p_rut_vendedor AND
        EXTRACT(YEAR FROM fecha) = v_anio_periodo;
    
    RETURN v_monto_total_ventas;  
    EXCEPTION
    WHEN OTHERS THEN
      v_mensaje_error := SQLERRM;
      sp_registrar_error('fn_obtener_total_ventas_vendedor', v_mensaje_error);
      RETURN 0;
    END FN_OBTENER_TOTAL_VENTAS_VENDEDOR;


    FUNCTION FN_OBTENER_TOTAL_VENTAS_PERIODO(p_anio_periodo NUMBER)
    RETURN NUMBER
    IS
    v_monto_total_ventas NUMBER;
    BEGIN
    SELECT
        NVL(SUM(total), 0)
    INTO
        v_monto_total_ventas
    FROM
        BOLETA
    WHERE
        EXTRACT(YEAR FROM fecha) = p_anio_periodo;
    
    RETURN v_monto_total_ventas;
    EXCEPTION
    WHEN OTHERS THEN
      v_mensaje_error := SQLERRM;
      sp_registrar_error('fn_obtener_total_ventas_periodo', v_mensaje_error);
      RETURN 0;
    END FN_OBTENER_TOTAL_VENTAS_PERIODO;


    PROCEDURE SP_GENERAR_INFORME_PORCENTAJE_VENDEDOR
    IS
    v_aporte NUMBER;
    v_fn_obtener_total_ventas_vendedor NUMBER;
    CURSOR cur_vendedores IS
    SELECT
        v.rutvendedor,
        v.nombre,
        c.descripcion AS comuna,
        v.sueldo_base
    FROM
        VENDEDOR v
    LEFT JOIN
        COMUNA c ON v.codcomuna = c.codcomuna;
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE error_procesos_mensuales';
    
    v_total_ventas := fn_obtener_total_ventas_periodo(v_anio_periodo);
    
    IF v_total_ventas = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No hay ventas en el año ' || v_anio_periodo);
    END IF;
    
    FOR registro IN cur_vendedores LOOP
        v_fn_obtener_total_ventas_vendedor := fn_obtener_total_ventas_vendedor(registro.rutvendedor);
        v_aporte := v_fn_obtener_total_ventas_vendedor / v_total_ventas;
        
        BEGIN
          INSERT INTO porcentaje_vendedor
          VALUES(
            v_anio_periodo,
            registro.rutvendedor,
            registro.nombre,
            registro.comuna,
            registro.sueldo_base,
            v_aporte);
        EXCEPTION
          WHEN OTHERS THEN
            v_mensaje_error := 'Error al insertar registro con el rut: ' || registro.rutvendedor || ' ' || SQLERRM;
            sp_registrar_error('sp_generar_informe_porcentaje_vendedor', v_mensaje_error);
        END;       
    END LOOP;
    
    EXCEPTION
      WHEN OTHERS THEN
        v_mensaje_error := SQLERRM;
        sp_registrar_error('sp_generar_informe_porcentaje_vendedor', v_mensaje_error);
    END SP_GENERAR_INFORME_PORCENTAJE_VENDEDOR;
END PKG_PORCENTAJE_VENTAS_VENDEDOR;


/* Bloque anonimo para definir las variables del paquete y llamar al procedimiento generador del informe */
BEGIN
  pkg_porcentaje_ventas_vendedor.v_anio_periodo := 2024;
  pkg_porcentaje_ventas_vendedor.sp_generar_informe_porcentaje_vendedor;
END;


/* Pruebas para verificar el funcionamiento del paquete */

/* Consulta a la tabla con el informe porcentaje_vendedor */
SELECT *
FROM PORCENTAJE_VENDEDOR;

/* Consulta a la tabla que almacena los errores del proceso */
SELECT *
FROM ERROR_PROCESOS_MENSUALES;







