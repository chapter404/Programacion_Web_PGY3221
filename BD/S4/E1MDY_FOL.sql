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
