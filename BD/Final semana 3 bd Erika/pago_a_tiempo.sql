create or replace function fn_pago_a_tiempo(id_atencion in number)RETURN VARCHAR2 is

v_fecha_vencimiento pago_atencion.fecha_venc_pago%type; 
v_fecha_pago pago_atencion.fecha_pago%type; 
v_diferencia_dias number (3);
v_respuesta_funcion varchar2 (2) default 'si';


BEGIN
    select 
    fecha_venc_pago, 
    fecha_pago
    into
    v_fecha_vencimiento,
    v_fecha_pago
    from 
    pago_atencion
    where 
    ate_id= id_atencion; 
    v_diferencia_dias := v_fecha_vencimiento - v_fecha_pago; 

    if v_diferencia_dias >=0 then 
    return v_respuesta_funcion;  

    ELSE 
    v_respuesta_funcion :='NO';
    return v_respuesta_funcion; 
    END IF;

end; 

declare 
v_respuesta varchar2(2);
begin 
v_respuesta := fn_pago_a_tiempo (100);
DBMS_OUTPUT.put_line ('pago_a_tiempo :: '|| v_respuesta);
end;

