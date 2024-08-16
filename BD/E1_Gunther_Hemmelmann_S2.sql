/***** CASO 1 *****/

--SET SERVEROUTPUT ON;
--SET SERVEROUTPUT OFF;

/***** Procedimiento para contabilizar atenciones *****/
CREATE OR REPLACE FUNCTION fn_cantidad_atenciones
(p_rut_medico IN NUMBER, p_periodo IN VARCHAR2)
RETURN NUMBER
IS
    v_total_atenciones NUMBER := 0;
BEGIN
    SELECT
        COUNT(*) AS TOTAL_ATENCIONES
    INTO
    v_total_atenciones
    FROM
        atencion a
    WHERE
        a.med_run = p_rut_medico AND
        TO_CHAR(a.fecha_atencion, 'MM-YYYY') = p_periodo;

    RETURN v_total_atenciones;
END;



/***** Procedimiento para caclular sueldo promedio por cargo *****/
CREATE OR REPLACE FUNCTION fn_sueldo_promedio_cargo
(p_id_cargo IN NUMBER)
RETURN NUMBER
IS
    v_sueldo_promedio NUMBER := 0;
BEGIN
    SELECT
        AVG(sueldo_base)
    INTO
        v_sueldo_promedio
    FROM
        medico
    WHERE
        car_id = p_id_cargo;
                    
    RETURN v_sueldo_promedio;
END;



/***** Procedimiento para calcular el costo total de las atenciones por medico en cierto periodo *****/
CREATE OR REPLACE FUNCTION fn_costo_total_atenciones_medico(p_rut_medico IN VARCHAR2, p_periodo IN VARCHAR2)
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
        TO_CHAR(fecha_atencion, 'MM-YYYY') = p_periodo AND
        TO_CHAR(med_run) = p_rut_medico;
        
    RETURN v_costo_total;    
END;



/***** Procedimiento para calcular el costo total de las atenciones por unidad en cierto periodo *****/
CREATE OR REPLACE FUNCTION fn_costo_total_atenciones_unidad(p_codigo_unidad IN NUMBER, p_periodo IN VARCHAR2)
RETURN NUMBER
IS
    v_costo_total NUMBER := 0;
BEGIN
    SELECT
        NVL(SUM(a.costo), 0)
    INTO
        v_costo_total
    FROM 
        atencion a
    JOIN
        medico m ON m.med_run = a.med_run
    JOIN unidad u ON u.uni_id = m.uni_id
    WHERE
        TO_CHAR(a.fecha_atencion, 'MM-YYYY') = p_periodo AND
        u.uni_id = p_codigo_unidad;
        
    RETURN v_costo_total;    
END;



/***** Procedimiento para generar informes *****/
CREATE OR REPLACE PROCEDURE sp_generador_informes
(p_codigo_unidad IN NUMBER, p_periodo IN VARCHAR2)
IS
    v_costo_total NUMBER := 0;
BEGIN
    v_costo_total := fn_costo_total_atenciones_unidad(p_codigo_unidad, p_periodo);
-- Generación del informe con el detalle de las atenciones
    FOR registro IN (
        SELECT *
        FROM
            medico
        WHERE
            uni_id = p_codigo_unidad
    ) LOOP
        IF v_costo_total = 0 THEN
            INSERT INTO detalle_atenciones
            VALUES (
                TO_CHAR(registro.med_run) || '-' || registro.dv_run, p_periodo, 0, 0, 0
            );
        ELSE
            INSERT INTO detalle_atenciones
            VALUES (
                TO_CHAR((registro.med_run) || '-' || registro.dv_run),
                p_periodo,
                fn_cantidad_atenciones(TO_CHAR(registro.med_run), p_periodo),
                fn_costo_total_atenciones_medico(registro.med_run, p_periodo),
                fn_costo_total_atenciones_medico(registro.med_run, p_periodo) /
                v_costo_total
            );
        END IF;
    END LOOP; 

-- Generación del informe con el resumen de los datos de los medicos    
    FOR registro IN (
        SELECT
            TO_CHAR(m.med_run) || '-' || m.dv_run AS RUT,
            m.pnombre || ' ' || m.snombre || ' ' || m.apaterno || ' ' || m.amaterno AS NOMBRE,
            m.car_id AS ID_CARGO,
            c.nombre AS CARGO,
            u.nombre UNIDAD,
            m.sueldo_base AS SUELDO
        FROM
            medico m
        JOIN
            cargo c ON c.car_id = m.car_id
        JOIN
            unidad u ON u.uni_id = m.uni_id
        WHERE
            m.uni_id = p_codigo_unidad
    ) LOOP
        INSERT INTO resumen_medico
            VALUES (registro.RUT, registro.NOMBRE, registro.CARGO, registro.UNIDAD, registro.SUELDO,
                ABS(ROUND(fn_sueldo_promedio_cargo(registro.ID_CARGO) - registro.SUELDO, 0)),
                CASE
                    WHEN fn_sueldo_promedio_cargo(registro.ID_CARGO) < registro.SUELDO
                    THEN 'SI'
                    ELSE 'NO'
                    END
            );
        END LOOP;                 
END;



/***** Ejecutar generador de informes *****/
EXECUTE sp_generador_informes(700, TO_CHAR(SYSDATE, 'MM-YYYY'));
--TRUNCATE TABLE detalle_atenciones;
--TRUNCATE TABLE resumen_medico;

/***** Ver registros tabla detalle_atenciones *****/
SELECT *
FROM detalle_atenciones;

/***** Ver registros tabla resumen_medico *****/
SELECT *
FROM resumen_medico;


