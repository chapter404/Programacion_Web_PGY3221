create or replace function fn_obtener_monto_a_cancelar(id_atencion in number) return number is 

v_monto_pago pago_atencion.monto_a_cancelar%type; 

begin 
SELECT 
monto_a_cancelar 
into 
v_monto_pago 
FROM 
pago_atencion
WHERE 
ate_id= id_atencion;
return v_monto_pago; 
end; 

declare 
v_respuesta pago_atencion.monto_a_cancelar%type; 
begin 
v_respuesta := fn_obtener_monto_a_cancelar (100);
DBMS_OUTPUT.put_line ('monto :: '|| v_respuesta);
end; 