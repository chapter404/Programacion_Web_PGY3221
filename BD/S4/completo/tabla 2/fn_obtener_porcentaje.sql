CREATE OR REPLACE FUNCTION fn_obtener_porcentaje(vunitario NUMBER)RETURN NUMBER IS

  v_porcentaje tramo_precio.porcentaje%TYPE;  
  
BEGIN
  SELECT porcentaje 
  INTO 
  v_porcentaje
  FROM tramo_precio
  WHERE valor_minimo <= vunitario AND valor_maximo >= vunitario;
  RETURN v_porcentaje;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL; 
END;


DECLARE 
  v_porcentaje NUMBER;
BEGIN 
  v_porcentaje := fn_obtener_porcentaje(0);
  IF v_porcentaje IS NOT NULL THEN
    DBMS_OUTPUT.put_line('porcentaje_aplicado::'||v_porcentaje); 
  ELSE
    DBMS_OUTPUT.put_line('No se encontró un porcentaje aplicable'); 
  END IF;
END;



