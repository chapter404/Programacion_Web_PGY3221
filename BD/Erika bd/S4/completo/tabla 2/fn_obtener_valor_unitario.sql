CREATE OR REPLACE FUNCTION fn_obtener_valor_unitario(p_cod_producto NUMBER) RETURN NUMBER IS
    v_valor_unitario NUMBER;
BEGIN
    SELECT vunitario
    INTO v_valor_unitario
    FROM producto
    WHERE codproducto = p_cod_producto;
    
    RETURN v_valor_unitario;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;

DECLARE 
    v_valor_unitario NUMBER(10,2); 
    p_cod_producto NUMBER := 1; 
BEGIN 
    v_valor_unitario := fn_obtener_valor_unitario(p_cod_producto);
    DBMS_OUTPUT.put_line('valor_unitario :: ' || v_valor_unitario);  
END;



