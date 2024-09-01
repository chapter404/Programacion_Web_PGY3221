------tabla resumen_cliente----------------
CREATE OR REPLACE PROCEDURE SP_PRINCIPAL (FECHA IN VARCHAR2) IS 

V_RUT_CLIENTE CLIENTE.RUTCLIENTE%TYPE; 
V_NOMBRE_CLIENTE CLIENTE.NOMBRE%TYPE;
V_COD_COMUNA CLIENTE.CODCOMUNA%TYPE;
V_CREDITO CLIENTE.CREDITO%TYPE;
v_nombre_comuna varchar2(50); 
v_total_documentos number (2); 

CURSOR C_CLIENTES IS SELECT  
RUTCLIENTE, 
NOMBRE, 
CODCOMUNA, 
CREDITO
FROM CLIENTE;


BEGIN 
OPEN C_CLIENTES; 

LOOP

FETCH C_CLIENTES INTO V_RUT_CLIENTE, V_NOMBRE_CLIENTE, V_COD_COMUNA, V_CREDITO; 
EXIT WHEN C_CLIENTES%NOTFOUND; 
    DBMS_OUTPUT.put_line('RUT_CLIENTE::'||V_RUT_CLIENTE); 
    DBMS_OUTPUT.put_line('NOMBRE_CLIENTE::'||V_NOMBRE_CLIENTE); 
    
        IF(v_cod_comuna is null)then
        v_cod_comuna:= 0; 
        end if;
    
    v_nombre_comuna := fn_nombre_comuna(v_cod_comuna);
    DBMS_OUTPUT.put_line('NOMBRE_COMUNA::'||v_nombre_comuna);     
    
    v_total_documentos := fn_cantidad_documentos (V_RUT_CLIENTE, fecha);
    DBMS_OUTPUT.put_line('total_documentos::'||v_total_documentos); 
    
    DBMS_OUTPUT.put_line('CREDITO::'||V_CREDITO); 
    DBMS_OUTPUT.put_line('*********************'); 
   
   insert into resumen_cliente (RUT_CLIENTE, NOMBRE_CLIENTE, NOMBRE_COMUNA, total_documentos, CREDITO)
   values (V_RUT_CLIENTE,V_NOMBRE_CLIENTE, v_nombre_comuna, v_total_documentos, V_CREDITO ); 
   
    
END LOOP;    
   
END; 

truncate table resumen_cliente; 

BEGIN
    SP_PRINCIPAL ('03-2023');
END;

select * from resumen_cliente; 
CREATE OR REPLACE PROCEDURE SP_PRINCIPAL (FECHA IN VARCHAR2) IS 

V_RUT_CLIENTE CLIENTE.RUTCLIENTE%TYPE; 
V_NOMBRE_CLIENTE CLIENTE.NOMBRE%TYPE;
V_COD_COMUNA CLIENTE.CODCOMUNA%TYPE;
V_CREDITO CLIENTE.CREDITO%TYPE;
v_nombre_comuna varchar2(50); 
v_total_documentos number (2); 

CURSOR C_CLIENTES IS SELECT  
RUTCLIENTE, 
NOMBRE, 
CODCOMUNA, 
CREDITO
FROM CLIENTE;


BEGIN 
OPEN C_CLIENTES; 

LOOP

FETCH C_CLIENTES INTO V_RUT_CLIENTE, V_NOMBRE_CLIENTE, V_COD_COMUNA, V_CREDITO; 
EXIT WHEN C_CLIENTES%NOTFOUND; 
    DBMS_OUTPUT.put_line('RUT_CLIENTE::'||V_RUT_CLIENTE); 
    DBMS_OUTPUT.put_line('NOMBRE_CLIENTE::'||V_NOMBRE_CLIENTE); 
    
        IF(v_cod_comuna is null)then
        v_cod_comuna:= 0; 
        end if;
    
    v_nombre_comuna := fn_nombre_comuna(v_cod_comuna);
    DBMS_OUTPUT.put_line('NOMBRE_COMUNA::'||v_nombre_comuna);     
    
    v_total_documentos := fn_cantidad_documentos (V_RUT_CLIENTE, fecha);
    DBMS_OUTPUT.put_line('total_documentos::'||v_total_documentos); 
    
    DBMS_OUTPUT.put_line('CREDITO::'||V_CREDITO); 
    DBMS_OUTPUT.put_line('*********************'); 
   
   insert into resumen_cliente (RUT_CLIENTE, NOMBRE_CLIENTE, NOMBRE_COMUNA, total_documentos, CREDITO)
   values (V_RUT_CLIENTE,V_NOMBRE_CLIENTE, v_nombre_comuna, v_total_documentos, V_CREDITO ); 
   
    
END LOOP;    
   
END; 

truncate table resumen_cliente; 

BEGIN
    SP_PRINCIPAL ('03-2023');
END;

select * from resumen_cliente; 
---------------------------------------------
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
---------------------------------------------
select count(*) from boleta where rutcliente='6245678-1'and to_char (fecha, 'mm-yyyy')='03-2023'; 

select count(*) from factura where rutcliente='6245678-1' and to_char (fecha, 'mm-yyyy')='03-2023'; 


create or replace function fn_cantidad_documentos (rut_cliente in varchar2, fecha_consulta in varchar2) return number is 

v_cantidad_boletas number(2);
v_cantidad_facturas number(2);
v_cantidad_total_doc number(2);

begin 
select count(*) 
into 
v_cantidad_boletas
from boleta 
where 
rutcliente = rut_cliente
and 
to_char (fecha, 'mm-yyyy') = fecha_consulta;

select count(*) 
into 
v_cantidad_facturas
from factura 
where 
rutcliente = rut_cliente 
and 
to_char (fecha, 'mm-yyyy') = fecha_consulta; 

v_cantidad_total_doc := v_cantidad_boletas + v_cantidad_facturas;
return v_cantidad_total_doc; 

end; 



declare 
v_respuesta number(2);
begin 
v_respuesta:= fn_cantidad_documentos ('6245678-1','03-2023');
DBMS_OUTPUT.put_line('respuesta::'||v_respuesta);  
end;



----------------------------
--------tabla resuemen_producto----------------------
CREATE OR REPLACE PROCEDURE sp_generar_informe(p_periodo VARCHAR2, p_limite_credito NUMBER) IS
    v_fecha_inicio DATE;
    v_fecha_fin DATE;
    v_credito_cliente VARCHAR2(20);
    v_cursor_boletas SYS_REFCURSOR;
    v_cursor_productos SYS_REFCURSOR;
    v_cursor_result SYS_REFCURSOR; 
    v_codigo_producto NUMBER;
    v_valor_unitario NUMBER;
    v_cantidad_boletas NUMBER;
    v_total_unidades NUMBER;
    v_porcentaje NUMBER;
    v_nuevo_precio NUMBER;
BEGIN
    
    v_fecha_inicio := TO_DATE('01-' || p_periodo, 'DD-MM-YYYY'); 
    v_fecha_fin := LAST_DAY(v_fecha_inicio);

    DBMS_OUTPUT.PUT_LINE('Fecha Inicio: ' || TO_CHAR(v_fecha_inicio, 'DD-MM-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Fecha Fin: ' || TO_CHAR(v_fecha_fin, 'DD-MM-YYYY'));
    
    DBMS_OUTPUT.PUT_LINE('Límite de Crédito: ' || p_limite_credito);
    OPEN v_cursor_boletas FOR
    SELECT rutcliente 
    FROM cliente
    WHERE credito >= p_limite_credito;

    DBMS_OUTPUT.PUT_LINE('Clientes con crédito igual o superior al límite:');
    LOOP
        FETCH v_cursor_boletas INTO v_credito_cliente;
        EXIT WHEN v_cursor_boletas%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('RUT Cliente: ' || v_credito_cliente);
    END LOOP;
    CLOSE v_cursor_boletas;
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_producto';
   
    OPEN v_cursor_productos FOR
    SELECT DISTINCT codproducto 
    FROM detalle_boleta;

    LOOP
        FETCH v_cursor_productos INTO v_codigo_producto;
        EXIT WHEN v_cursor_productos%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Código Producto: ' || v_codigo_producto);

        v_cursor_result := fn_obtener_boletas_y_unidades(v_codigo_producto, v_fecha_inicio, v_fecha_fin);

        LOOP
            FETCH v_cursor_result INTO v_cantidad_boletas, v_total_unidades;
            EXIT WHEN v_cursor_result%NOTFOUND;

            IF v_total_unidades IS NULL THEN
               v_total_unidades := 0;
            END IF;
            
            v_valor_unitario := fn_obtener_valor_unitario(v_codigo_producto);

            IF v_valor_unitario IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Valor unitario no encontrado para el código producto: ' || v_codigo_producto);
                CONTINUE;
            END IF;
           
            v_porcentaje := fn_obtener_porcentaje(v_valor_unitario);

            IF v_porcentaje IS NULL THEN
                v_porcentaje := 0; 
            END IF;
            
            v_nuevo_precio := v_valor_unitario * (1 + v_porcentaje / 100); 

            DBMS_OUTPUT.PUT_LINE('Valor Unitario: ' || v_valor_unitario);
            DBMS_OUTPUT.PUT_LINE('Porcentaje Aplicado: ' || v_porcentaje);
            DBMS_OUTPUT.PUT_LINE('Total Boletas: ' || v_cantidad_boletas);
            DBMS_OUTPUT.PUT_LINE('Total Unidades: ' || v_total_unidades);
            DBMS_OUTPUT.PUT_LINE('Nuevo Precio: ' || v_nuevo_precio);
            DBMS_OUTPUT.PUT_LINE('*******************************************');
            
            BEGIN
                INSERT INTO RESUMEN_PRODUCTO (cod_producto, total_boletas, total_unidades, valor_unitario, porcentaje_aplicado, precio)
                VALUES (v_codigo_producto, v_cantidad_boletas, v_total_unidades, v_valor_unitario, v_porcentaje, v_nuevo_precio);
                DBMS_OUTPUT.PUT_LINE('Datos insertados correctamente para el código producto: ' || v_codigo_producto);
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error al insertar datos para el código producto: ' || v_codigo_producto || '. Error: ' || SQLERRM);
            END;
        END LOOP;
        CLOSE v_cursor_result;
    END LOOP;
    CLOSE v_cursor_productos;
END;

truncate table resumen_cliente; 


BEGIN
    sp_generar_informe('03-2023', 1000);
END;

select * from resumen_producto; 
------------------------------------------------
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
------------------------------------------------
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

--------------------------------------------------------
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
------------------------------------------
---fin---
---ahora lo compile todo junto profe :)-------


