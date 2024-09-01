create or replace FUNCTION fn_nombre_comuna (idComuna in NUMBER) RETURN VARCHAR2 IS 

V_NOMBRE_COMUNA COMUNA.DESCRIPCION%TYPE;

BEGIN 

    IF (idComuna >0) THEN 
    
        select descripcion 
        INTO 
        V_NOMBRE_COMUNA
        from comuna
        where codcomuna=idComuna; 
        return V_NOMBRE_COMUNA; 
    
    ELSE 
    RETURN 'SIN COMUNA'; 
    end if; 
END; 


declare 
v_respuesta VARCHAR2(50);

begin 
v_respuesta :=fn_nombre_comuna(0);
DBMS_OUTPUT.put_line('respuesta::'||v_respuesta); 
end; 