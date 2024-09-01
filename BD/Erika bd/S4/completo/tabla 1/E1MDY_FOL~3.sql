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