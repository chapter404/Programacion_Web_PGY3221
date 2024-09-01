CREATE OR REPLACE FUNCTION fn_obtener_total_atenciones_periodo(
    p_esp_id IN ATENCION.ESP_ID%TYPE, 
    p_periodo IN VARCHAR2
) 
RETURN NUMBER IS
    v_total_atenciones_periodo ATENCION.ATE_ID%TYPE; 
BEGIN
    SELECT COUNT(*) 
    INTO v_total_atenciones_periodo
    FROM ATENCION
    WHERE ESP_ID = p_esp_id 
    AND TO_CHAR(FECHA_ATENCION, 'MM-YYYY') = p_periodo;

    RETURN v_total_atenciones_periodo;
END;


DECLARE
    v_esp_id ATENCION.ESP_ID%TYPE := 100;  
    v_periodo VARCHAR2(7) := '06-2023';  
    v_total_atenciones NUMBER;
BEGIN
    v_total_atenciones := fn_obtener_total_atenciones_periodo(v_esp_id, v_periodo);
    DBMS_OUTPUT.PUT_LINE('Número total de atenciones para la especialidad ' || v_esp_id || ' en el período ' || v_periodo || ' es: ' || v_total_atenciones);
END;


