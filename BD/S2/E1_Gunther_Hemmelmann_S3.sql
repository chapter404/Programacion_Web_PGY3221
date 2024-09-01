/***** CASO 1 *****/

--SET SERVEROUTPUT ON;
--SET SERVEROUTPUT OFF;

/***** Funcion para contabilizar atenciones *****/
CREATE OR REPLACE FUNCTION fn_cantidad_atenciones
(p_id_especialidad IN NUMBER, p_periodo IN VARCHAR2)
RETURN NUMBER
IS
    v_total_atenciones NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO
        v_total_atenciones
    FROM
        atencion
    WHERE
        esp_id = p_id_especialidad AND
        TO_CHAR(fecha_atencion, 'MM-YYYY') = p_periodo;
        
    RETURN v_total_atenciones;
END;



/***** Funcion para calcular el costo total de las atenciones de la especialidad por periodo *****/
CREATE OR REPLACE FUNCTION fn_costo_total_atenciones_especialidad
(p_id_especialidad IN NUMBER, p_periodo IN VARCHAR2)
RETURN NUMBER
IS
    v_costo_total NUMBER := 0;
BEGIN
    SELECT
        NVL(SUM(costo), 0)
    INTO
        v_costo_total
    FROM
        atencion
    WHERE
        esp_id = p_id_especialidad AND
        TO_CHAR(fecha_atencion, 'MM-YYYY') = p_periodo;
        
    RETURN v_costo_total;
END;



/***** Procedimiento para generar informes *****/
CREATE OR REPLACE PROCEDURE sp_generar_informe
(p_periodo IN VARCHAR2)
IS
    v_costo_total NUMBER := 0;

BEGIN
-- Generación del informe con el resumen de las especialidades médicas
    FOR reg IN (
        SELECT
            e.esp_id,
            e.nombre,
            COUNT(em.esp_id) AS CANTIDAD_MEDICOS,
            fn_cantidad_atenciones(e.esp_id, p_periodo) AS ATENCIONES,
            fn_costo_total_atenciones_especialidad(e.esp_id, p_periodo) AS COSTO,
            CASE
                WHEN fn_costo_total_atenciones_especialidad(e.esp_id, p_periodo) = 0
                    THEN '-'
                WHEN fn_costo_total_atenciones_especialidad(e.esp_id, p_periodo) < 20000
                    THEN 'A'
                WHEN fn_costo_total_atenciones_especialidad(e.esp_id, p_periodo) BETWEEN 20000 AND 50000
                    THEN 'B'
                WHEN fn_costo_total_atenciones_especialidad(e.esp_id, p_periodo) > 50000 AND
                    fn_costo_total_atenciones_especialidad(e.esp_id, p_periodo) <= 100000
                    THEN 'C'
                WHEN fn_costo_total_atenciones_especialidad(e.esp_id, p_periodo) > 100000
                    THEN 'D'
            END AS CATEGORIA
        FROM
            especialidad e
        LEFT JOIN
            especialidad_medico em ON em.esp_id = e.esp_id
        GROUP BY
            e.esp_id,
            e.nombre
        ORDER BY
            e.esp_id
    ) LOOP
        INSERT INTO resumen_especialidad
        VALUES (
            reg.esp_id, reg.nombre, p_periodo, reg.CANTIDAD_MEDICOS, reg.ATENCIONES, reg.COSTO, reg.CATEGORIA
        );
    END LOOP;
END;



/***** Ejecutar generador de informes *****/
EXECUTE sp_generar_informe(TO_CHAR(SYSDATE, 'MM-YYYY'));
--TRUNCATE TABLE resumen_especialidad;
--TRUNCATE TABLE detalle_especialidad;

/***** Ver registros de la tabla resumen_especialidad *****/
SELECT *
FROM resumen_especialidad;

/***** Ver registros de la tabla detalle_especialidad *****/
SELECT *
FROM detalle_especialidad;




