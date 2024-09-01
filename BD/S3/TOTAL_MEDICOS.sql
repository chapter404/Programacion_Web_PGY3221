CREATE OR REPLACE FUNCTION fn_obtener_total_medicos(p_esp_id IN MEDICO.UNI_ID%TYPE) 
RETURN NUMBER IS 
    v_total_medicos MEDICO.CAR_ID%TYPE;  
BEGIN
    BEGIN
        SELECT COUNT(*) 
        INTO v_total_medicos
        FROM MEDICO
        WHERE UNI_ID = p_esp_id;  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            v_total_medicos := 0;  
    END;

    RETURN v_total_medicos;
END;



declare 
v_respuesta MEDICO.CAR_ID%TYPE; 
begin 
v_respuesta := fn_obtener_total_medicos (100);
DBMS_OUTPUT.put_line ('total_medicos :: '|| v_respuesta);
end; 

