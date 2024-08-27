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
----------
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
--------------
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
-------------
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
---------------------------------
CREATE OR REPLACE FUNCTION fn_obtener_total_medicos(p_esp_id IN MEDICO.UNI_ID%TYPE) 
RETURN NUMBER IS 
    v_total_medicos MEDICO.CAR_ID%TYPE;  
BEGIN
    BEGIN
        SELECT COUNT(*) 
        INTO v_total_medicos
        FROM MEDICO
        WHERE UNI_ID = p_esp_id;  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            v_total_medicos := 0;  
    END;

    RETURN v_total_medicos;
END;



declare 
v_respuesta MEDICO.CAR_ID%TYPE; 
begin 
v_respuesta := fn_obtener_total_medicos (100);
DBMS_OUTPUT.put_line ('total_medicos :: '|| v_respuesta);
end; 
--------------------------------------------------
CREATE OR REPLACE FUNCTION fn_obtener_costo_total_periodo(
    p_esp_id ATENCION.ESP_ID%TYPE, 
    p_periodo IN VARCHAR2
) 
RETURN NUMBER IS
    v_costo_total_periodo ATENCION.COSTO%TYPE;  
BEGIN
    SELECT SUM(COSTO) 
    INTO v_costo_total_periodo
    FROM ATENCION
    WHERE ESP_ID = p_esp_id
    AND TO_CHAR(FECHA_ATENCION, 'MM-YYYY') = p_periodo;

    RETURN v_costo_total_periodo;
END;


DECLARE
    v_esp_id ATENCION.ESP_ID%TYPE := 100;  
    v_periodo VARCHAR2(7) := '06-2023'; 
    v_costo_total NUMBER;
BEGIN
    v_costo_total := fn_obtener_costo_total_periodo(v_esp_id, v_periodo);
    DBMS_OUTPUT.PUT_LINE('esp_id ' || v_esp_id || ' período ' || v_periodo || ' costo total: ' || v_costo_total);
END;

--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_obtener_total_atenciones_periodo(
    p_esp_id IN ATENCION.ESP_ID%TYPE, 
    p_periodo IN VARCHAR2
) 
RETURN NUMBER IS
    v_total_atenciones_periodo ATENCION.ATE_ID%TYPE; 
BEGIN
    SELECT COUNT(*) 
    INTO v_total_atenciones_periodo
    FROM ATENCION
    WHERE ESP_ID = p_esp_id 
    AND TO_CHAR(FECHA_ATENCION, 'MM-YYYY') = p_periodo;

    RETURN v_total_atenciones_periodo;
END;


DECLARE
    v_esp_id ATENCION.ESP_ID%TYPE := 100;  
    v_periodo VARCHAR2(7) := '06-2023';  
    v_total_atenciones NUMBER;
BEGIN
    v_total_atenciones := fn_obtener_total_atenciones_periodo(v_esp_id, v_periodo);
    DBMS_OUTPUT.PUT_LINE('Número total de atenciones para la especialidad ' || v_esp_id || ' en el período ' || v_periodo || ' es: ' || v_total_atenciones);
END;


-----------------------------------------------------------
CREATE OR REPLACE PROCEDURE INFORME_PRINCIPAL (periodo IN VARCHAR2) IS 
    v_esp_id ESPECIALIDAD.ESP_ID%TYPE;
    v_nombre_especialidad ESPECIALIDAD.NOMBRE%TYPE;
    v_total_medicos NUMBER;
    v_total_atenciones_periodo NUMBER;
    v_costo_total_periodo NUMBER;
    v_categoria VARCHAR2(10);

    CURSOR c_especialidades IS 
        SELECT DISTINCT 
        esp_id
        FROM 
        ATENCION
        WHERE TO_CHAR(FECHA_ATENCION, 'MM-YYYY') = 'PERIODO';

BEGIN
    OPEN c_especialidades; 
    LOOP
        FETCH c_especialidades INTO v_esp_id;
        EXIT WHEN c_especialidades%NOTFOUND; 

       
        SELECT NOMBRE
        INTO v_nombre_especialidad
        FROM ESPECIALIDAD
        WHERE ESP_ID = v_esp_id;

        DBMS_OUTPUT.PUT_LINE('Esp_ID: ' || v_esp_id);
        DBMS_OUTPUT.PUT_LINE('Nombre_Especialidad: ' || v_nombre_especialidad);
        DBMS_OUTPUT.PUT_LINE('Periodo: ' || periodo);
        
        v_total_medicos := fn_obtener_total_medicos(v_esp_id);
        DBMS_OUTPUT.PUT_LINE('Total_Médicos: ' || v_total_medicos);
        
        v_total_atenciones_periodo := obtener_total_atenciones_periodo(v_esp_id, periodo);
        DBMS_OUTPUT.PUT_LINE('Total_Atenciones_Periodo: ' || v_total_atenciones_periodo);
        
        v_costo_total_periodo := fn_obtener_costo_total_periodo(v_esp_id, periodo);
        DBMS_OUTPUT.PUT_LINE('Costo_Total_Periodo: ' || v_costo_total_periodo);
        DBMS_OUTPUT.PUT_LINE('Categoría: ' || v_categoria);
        DBMS_OUTPUT.PUT_LINE('**********************************************');

        
        INSERT INTO RESUMEN_ESPECIALIDAD(ESP_ID, NOMBRE_ESPECIALIDAD, PERIODO, TOTAL_MEDICOS, TOTAL_ATENCIONES_PERIODO, COSTO_TOTAL_PERIODO, CATEGORIA)
        VALUES (v_esp_id, v_nombre_especialidad, periodo, v_total_medicos, v_total_atenciones_periodo, v_costo_total_periodo, v_categoria);
        
    END LOOP; 
    CLOSE c_especialidades; 
END;



BEGIN 
    INFORME_PRINCIPAL('06-2023');
END;


SELECT * FROM RESUMEN_ESPECIALIDAD;



