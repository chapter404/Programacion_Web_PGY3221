--PARTE 1

create or replace procedure sp_atencion_sin_errores(periodo in varchar2) as

v_id_atencion atencion.ate_id%TYPE;
v_costo_atencion atencion.costo%TYPE;
v_dias_atraso NUMBER(4);
v_rut_paciente atencion.pac_run%TYPE;

cursor c_atencion is
        select 
        a.ate_id,
        a.costo,
        (fecha_pago - fecha_venc_pago),
        a.pac_run
        from atencion a
        join pago_atencion pa
        on a.ate_id = pa.ate_id
        where to_char(a.fecha_atencion,'mm-yyyy')=fecha;

begin
open c_atencion;

LOOP
   FETCH c_atencion into v_id_atencion,v_costo_atencion,v_dias_atraso,v_rut_paciente;
   EXIT WHEN c_atencion%NOTFOUND;
    DBMS_OUTPUT.put_line('v_id_atencion: ' || v_id_atencion);
    DBMS_OUTPUT.put_line('v_costo_atencion: ' || v_costo_atencion);
    DBMS_OUTPUT.put_line('v_dias_atraso: ' || v_dias_atraso);
    DBMS_OUTPUT.put_line('v_rut_paciente: ' || v_rut_paciente);
    DBMS_OUTPUT.put_line('***********************************');
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_atenciones';    
   
    INSERT INTO resumen_atenciones (ATE_ID,MONTO_ATENCION,DIAS_ATRASO,DESCUENTO, MONTO_CANCELAR)
    VALUES(v_id_atencion,v_costo_atencion,v_dias_atraso,0,0);
    
   end; 
END LOOP;

end;


begin
sp_atencion_sin_errores('01-2023');
end;


--PARTE 2
create or replace procedure sp_atencion_con_errores(periodo in varchar2) as

v_id_atencion atencion.ate_id%TYPE;
v_costo_atencion atencion.costo%TYPE;
v_dias_atraso NUMBER(4);
v_rut_paciente atencion.pac_run%TYPE;

v_mensaje_error VARCHAR2(250);
v_codigo_error NUMBER(6);

dias_max_atraso EXCEPTION;

cursor c_atencion is
        select 
        a.ate_id,
        a.costo,
        (fecha_pago - fecha_venc_pago),
        a.pac_run
        from atencion a
        join pago_atencion pa
        on a.ate_id = pa.ate_id
        where to_char(a.fecha_atencion,'mm-yyyy')=periodo;

begin

open c_atencion;

LOOP
   FETCH c_atencion into v_id_atencion,v_costo_atencion,v_dias_atraso,v_rut_paciente;
   EXIT WHEN c_atencion%NOTFOUND;
    DBMS_OUTPUT.put_line('v_id_atencion: ' || v_id_atencion);
    DBMS_OUTPUT.put_line('v_costo_atencion: ' || v_costo_atencion);
    DBMS_OUTPUT.put_line('v_dias_atraso: ' || v_dias_atraso);
    DBMS_OUTPUT.put_line('v_rut_paciente: ' || v_rut_paciente);
    DBMS_OUTPUT.put_line('***********************************');
    begin
        INSERT INTO resumen_atenciones (ATE_ID,MONTO_ATENCION,DIAS_ATRASO,DESCUENTO, MONTO_CANCELAR)
        VALUES(v_id_atencion,v_costo_atencion,v_dias_atraso,0,0);
        EXCEPTION 
        WHEN OTHERS THEN          
            v_mensaje_error:=SQLERRM;
            v_codigo_error:=SQLCODE;
            INSERT INTO errores_informe(ID_ERROR,RUTINA_AFECTADA,MENSAJE_ORACLE)
            VALUES(SEQ_ERROR.nextval,'sp_atencion_errores', v_codigo_error||' '||v_mensaje_error);
    end;
    
    begin
        IF(v_dias_atraso > 150) THEN
            RAISE dias_max_atraso;
        END IF;
        
        EXCEPTION
            WHEN dias_max_atraso THEN
                INSERT INTO errores_informe(ID_ERROR,RUTINA_AFECTADA,MENSAJE_ORACLE)
                VALUES(SEQ_ERROR.nextval,'sp_atencion_errores', v_dias_atraso ||' sobrepasa limite dias de atraso');
     end; 
   
END LOOP;
end;



begin
sp_atencion_con_errores('01-2023');
end;



select * from errores_informe;
select * from resumen_atenciones;
