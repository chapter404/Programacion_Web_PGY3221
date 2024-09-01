CREATE OR REPLACE FUNCTION fn_obtener_costo_total_periodo(
    p_esp_id ATENCION.ESP_ID%TYPE, 
    p_periodo IN VARCHAR2
) 
RETURN NUMBER IS
    v_costo_total_periodo ATENCION.COSTO%TYPE;  
BEGIN
    SELECT SUM(COSTO) 
    INTO v_costo_total_periodo
    FROM ATENCION
    WHERE ESP_ID = p_esp_id
    AND TO_CHAR(FECHA_ATENCION, 'MM-YYYY') = p_periodo;

    RETURN v_costo_total_periodo;
END;


DECLARE
    v_esp_id ATENCION.ESP_ID%TYPE := 100;  
    v_periodo VARCHAR2(7) := '06-2023'; 
    v_costo_total NUMBER;
BEGIN
    v_costo_total := fn_obtener_costo_total_periodo(v_esp_id, v_periodo);
    DBMS_OUTPUT.PUT_LINE('esp_id ' || v_esp_id || ' período ' || v_periodo || ' costo total: ' || v_costo_total);
END;

