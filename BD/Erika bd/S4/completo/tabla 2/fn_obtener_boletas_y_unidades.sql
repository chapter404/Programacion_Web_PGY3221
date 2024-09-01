CREATE OR REPLACE FUNCTION fn_obtener_boletas_y_unidades (p_cod_producto NUMBER, p_fecha_inicio DATE, p_fecha_fin DATE) RETURN SYS_REFCURSOR IS
  v_resultado SYS_REFCURSOR;
  
BEGIN
 
  OPEN v_resultado FOR
    SELECT 
      COUNT(DISTINCT b.numboleta) AS cantidad_boletas,
      SUM(db.cantidad) AS total_unidades
      into 
      v_resultado
    FROM detalle_boleta db
    JOIN boleta b ON db.numboleta = b.numboleta
    WHERE db.codproducto = p_cod_producto
    AND b.fecha BETWEEN p_fecha_inicio AND p_fecha_fin;
 
  RETURN v_resultado;
END;



DECLARE
  v_cursor SYS_REFCURSOR;
  v_cantidad_boletas NUMBER;
  v_total_unidades NUMBER;
BEGIN
  
  v_cursor := fn_obtener_boletas_y_unidades(1, TO_DATE('01-2023', 'MM-YYYY'), TO_DATE('12-2023', 'MM-YYYY'));
  
  FETCH v_cursor INTO v_cantidad_boletas, v_total_unidades;
 
  DBMS_OUTPUT.put_line('total boletas: ' || v_cantidad_boletas);
  DBMS_OUTPUT.put_line('total unidades: ' || v_total_unidades);
  CLOSE v_cursor;
END;

