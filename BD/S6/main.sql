-- Función para obtener el total de costos por atenciones de un médico en un período
CREATE OR REPLACE FUNCTION obtener_total_costos_atenciones(p_med_run IN NUMBER, p_periodo IN VARCHAR2) RETURN NUMBER IS
    v_total_costos NUMBER(10);
BEGIN
    SELECT SUM(costo)
    INTO v_total_costos
    FROM ATENCION
    WHERE med_run = p_med_run
      AND TO_CHAR(fecha_atencion, 'MM-YYYY') = p_periodo;

    RETURN NVL(v_total_costos, 0); 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN 0;
END obtener_total_costos_atenciones;


-- Paquete para gestionar el resumen médico
CREATE OR REPLACE PACKAGE pkg_paquete_resumen_medico IS
    v_periodo_consulta VARCHAR2(7);
    v_limite_antiguedad NUMBER;

    FUNCTION fn_obtener_cantidad_atenciones(p_med_run IN NUMBER) RETURN NUMBER;
    PROCEDURE generar_informe_resumen;
END pkg_paquete_resumen_medico;


-- Implementación del paquete para el resumen médico
CREATE OR REPLACE PACKAGE BODY pkg_paquete_resumen_medico IS

    -- Función para obtener la cantidad de atenciones de un médico en un período
    FUNCTION obtener_cantidad_atenciones(p_med_run IN NUMBER) RETURN NUMBER IS
        v_cantidad_atenciones NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_cantidad_atenciones
        FROM ATENCION
        WHERE med_run = p_med_run
          AND TO_CHAR(fecha_atencion, 'MM-YYYY') = v_periodo_consulta;

        RETURN NVL(v_cantidad_atenciones, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error en obtener_cantidad_atenciones: ' || SQLERRM);
            RETURN 0;
    END obtener_cantidad_atenciones;

    -- Procedimiento para insertar el resumen en la tabla resumen_medico
    PROCEDURE insertar_resumen_medico(p_periodo IN VARCHAR2, p_med_run IN NUMBER, p_cantidad_atenciones IN NUMBER, p_costo_total IN NUMBER, p_promedio_atencion IN NUMBER, p_proporcion_total IN NUMBER) IS
        v_sql VARCHAR2(500);
    BEGIN
        v_sql := 'INSERT INTO resumen_medico (periodo, rutmedico, cantidad_atenciones, costo_atenciones, promedio_por_atencion, proporcion_de_total) ' ||
                 'VALUES (:1, :2, :3, :4, :5, :6)';
        EXECUTE IMMEDIATE v_sql
        USING p_periodo, p_med_run, p_cantidad_atenciones, p_costo_total, p_promedio_atencion, p_proporcion_total;
        
        DBMS_OUTPUT.PUT_LINE('Insertado en resumen_medico: ' || p_periodo || ', ' || p_med_run || ', ' || p_cantidad_atenciones || ', ' || p_costo_total || ', ' || p_promedio_atencion || ', ' || p_proporcion_total);
    END insertar_resumen_medico;

    -- Procedimiento para generar el informe resumen médico
    PROCEDURE generar_informe_resumen IS
        v_total_atenciones_periodo NUMBER;
        v_total_costo_periodo NUMBER;
        v_med_run NUMBER;
        v_cantidad_atenciones NUMBER;
        v_costo_total NUMBER;
        v_promedio_atencion NUMBER;
        v_proporcion_total NUMBER;
        v_fecha_contrato DATE;
        v_antiguedad NUMBER;
    BEGIN
        -- Calcular el total de atenciones y costos en el período
        SELECT SUM(costo), COUNT(*)
        INTO v_total_costo_periodo, v_total_atenciones_periodo
        FROM ATENCION
        WHERE TO_CHAR(fecha_atencion, 'MM-YYYY') = v_periodo_consulta;

        DBMS_OUTPUT.PUT_LINE('Total costo del período: ' || v_total_costo_periodo);
        DBMS_OUTPUT.PUT_LINE('Total atenciones del período: ' || v_total_atenciones_periodo);

        -- Recorrer cada médico y calcular el resumen
        FOR medico IN (SELECT med_run, fecha_contrato FROM MEDICO) LOOP
            v_antiguedad := FLOOR(MONTHS_BETWEEN(SYSDATE, medico.fecha_contrato) / 12);

            -- Verificar si el médico cumple con el límite de antigüedad
            IF v_antiguedad >= v_limite_antiguedad THEN
                v_med_run := medico.med_run;

                -- Obtener la cantidad de atenciones y el costo total para el médico
                v_cantidad_atenciones := obtener_cantidad_atenciones(v_med_run);
                v_costo_total := obtener_total_costos_atenciones(v_med_run, v_periodo_consulta);
                
                DBMS_OUTPUT.PUT_LINE('Médico: ' || v_med_run);
                DBMS_OUTPUT.PUT_LINE('Cantidad atenciones: ' || v_cantidad_atenciones);
                DBMS_OUTPUT.PUT_LINE('Costo total: ' || v_costo_total);

                -- Si el médico tiene atenciones, calcular el promedio y la proporción del total
                IF v_cantidad_atenciones > 0 THEN
                    v_promedio_atencion := v_costo_total / v_cantidad_atenciones;
                    v_proporcion_total := (v_costo_total / v_total_costo_periodo) * 100;

                    -- Insertar los datos en la tabla resumen_medico
                    insertar_resumen_medico(v_periodo_consulta, v_med_run, v_cantidad_atenciones, v_costo_total, v_promedio_atencion, v_proporcion_total);
                END IF;
            END IF;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                v_error_msg VARCHAR2(500);
            BEGIN
                v_error_msg := SUBSTR(SQLERRM, 1, 500); 
                INSERT INTO ERRORES_PROCESO (nro_correlativo, subprograma_error, descripcion_error)
                VALUES (seq_error.NEXTVAL, 'pkg_paquete_resumen_medico.generar_informe_resumen', v_error_msg);
                
                DBMS_OUTPUT.PUT_LINE('Error en generar_informe_resumen: ' || v_error_msg);
                DBMS_OUTPUT.PUT_LINE('***************************************************');
            END;
    END generar_informe_resumen;

END pkg_paquete_resumen_medico;


-- Bloque anónimo para ejecutar el informe
BEGIN
    pkg_paquete_resumen_medico.v_periodo_consulta := '01-2021';
    pkg_paquete_resumen_medico.v_limite_antiguedad := 15;
    pkg_paquete_resumen_medico.generar_informe_resumen;
    
    DBMS_OUTPUT.PUT_LINE('Informe de resumen médico generado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al ejecutar el informe: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('*******************************************');
END;


-- Consultas de prueba para ver los resultados
SELECT * FROM errores_proceso;
SELECT * FROM resumen_medico;
