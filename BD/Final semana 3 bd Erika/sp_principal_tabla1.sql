create or replace procedure sp_principal (fecha in varchar2) is 

v_id_atencion atencion.ate_id%type; 
v_esp_id atencion.esp_id%type;
v_fecha_atencion atencion.fecha_atencion%type;
v_costo atencion.costo%type;
v_monto_pago pago_atencion.monto_a_cancelar%type; 
v_fecha_vencimiento pago_atencion.fecha_venc_pago%type; 
v_respuesta_pago_a_tiempo VARCHAR2(2); 

cursor c_atenciones is 
    select 
    ate_id,
    esp_id,
    fecha_atencion,
    costo
    from 
    atencion
    where to_char (fecha_atencion, 'mm-yyyy')='06-2023';


begin

    open c_atenciones; 
    loop
    fetch c_atenciones into v_id_atencion, v_esp_id, v_fecha_atencion, v_costo;
    exit when c_atenciones%NOTFOUND; 

    DBMS_OUTPUT.put_line('esp_id :: ' ||v_esp_id); 
    DBMS_OUTPUT.put_line('fecha_atencion :: ' ||v_fecha_atencion); 
    DBMS_OUTPUT.put_line('costo_atencion :: ' ||v_costo); 
    v_monto_pago := fn_obtener_monto_a_cancelar(v_id_atencion); 
    DBMS_OUTPUT.put_line('monto_pago :: ' ||v_monto_pago); 

    v_fecha_vencimiento := fn_obtener_fecha_vencimiento_pago(v_id_atencion); 
    DBMS_OUTPUT.put_line('fecha_pago :: ' ||v_fecha_vencimiento);     

    v_respuesta_pago_a_tiempo:= fn_pago_a_tiempo (v_id_atencion);     
    DBMS_OUTPUT.put_line('pago_a_tiempo :: ' ||v_respuesta_pago_a_tiempo); 
    DBMS_OUTPUT.put_line('**********************************************');

    insert into detalle_especialidad(correlativo, esp_id, fecha_atencion, costo_atencion, monto_pago, fecha_pago, pago_a_tiempo)
    values (seq_detalle.nextval, v_esp_id, v_fecha_atencion, v_costo, v_monto_pago, v_fecha_vencimiento, v_respuesta_pago_a_tiempo);

    END LOOP; 
    CLOSE c_atenciones; 
end; 

begin 
sp_principal('06-2023');
end;

select * from detalle_especialidad; 