CREATE OR REPLACE PROCEDURE INFORME_PRINCIPAL (periodo IN VARCHAR2) IS 
    v_esp_id ESPECIALIDAD.ESP_ID%TYPE;
    v_nombre_especialidad ESPECIALIDAD.NOMBRE%TYPE;
    v_total_medicos NUMBER;
    v_total_atenciones_periodo NUMBER;
    v_costo_total_periodo NUMBER;
    v_categoria VARCHAR2(10);

    CURSOR c_especialidades IS 
        SELECT DISTINCT 
        esp_id
        FROM 
        ATENCION
        WHERE TO_CHAR(FECHA_ATENCION, 'MM-YYYY') = 'PERIODO';

BEGIN
    OPEN c_especialidades; 
    LOOP
        FETCH c_especialidades INTO v_esp_id;
        EXIT WHEN c_especialidades%NOTFOUND; 

       
        SELECT NOMBRE
        INTO v_nombre_especialidad
        FROM ESPECIALIDAD
        WHERE ESP_ID = v_esp_id;

        DBMS_OUTPUT.PUT_LINE('Esp_ID: ' || v_esp_id);
        DBMS_OUTPUT.PUT_LINE('Nombre_Especialidad: ' || v_nombre_especialidad);
        DBMS_OUTPUT.PUT_LINE('Periodo: ' || periodo);
        
        v_total_medicos := fn_obtener_total_medicos(v_esp_id);
        DBMS_OUTPUT.PUT_LINE('Total_Médicos: ' || v_total_medicos);
        
        v_total_atenciones_periodo := obtener_total_atenciones_periodo(v_esp_id, periodo);
        DBMS_OUTPUT.PUT_LINE('Total_Atenciones_Periodo: ' || v_total_atenciones_periodo);
        
        v_costo_total_periodo := fn_obtener_costo_total_periodo(v_esp_id, periodo);
        DBMS_OUTPUT.PUT_LINE('Costo_Total_Periodo: ' || v_costo_total_periodo);
        DBMS_OUTPUT.PUT_LINE('Categoría: ' || v_categoria);
        DBMS_OUTPUT.PUT_LINE('**********************************************');

        
        INSERT INTO RESUMEN_ESPECIALIDAD(ESP_ID, NOMBRE_ESPECIALIDAD, PERIODO, TOTAL_MEDICOS, TOTAL_ATENCIONES_PERIODO, COSTO_TOTAL_PERIODO, CATEGORIA)
        VALUES (v_esp_id, v_nombre_especialidad, periodo, v_total_medicos, v_total_atenciones_periodo, v_costo_total_periodo, v_categoria);
        
    END LOOP; 
    CLOSE c_especialidades; 
END;



BEGIN 
    INFORME_PRINCIPAL('06-2023');
END;


SELECT * FROM RESUMEN_ESPECIALIDAD;


