create or replace function fn_obtener_fecha_vencimiento_pago(id_atencion in number)return varchar2 is

v_fecha_vencimiento pago_atencion.fecha_venc_pago%type; 

begin

select 
fecha_venc_pago
into
v_fecha_vencimiento
from pago_atencion 
where 
ate_id= id_atencion; 

return v_fecha_vencimiento; 
end; 

declare 
v_respuesta pago_atencion.fecha_venc_pago%type; 
begin 
v_respuesta := fn_obtener_fecha_vencimiento_pago (100);
DBMS_OUTPUT.put_line ('fecha :: '|| v_respuesta);
end; 