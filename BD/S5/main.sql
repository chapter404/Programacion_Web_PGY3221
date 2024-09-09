-- Función para retornar el descuento basado en la edad
CREATE OR REPLACE FUNCTION obtener_descuento_edad(p_edad IN NUMBER) RETURN NUMBER IS
  v_descuento NUMBER := 0;
BEGIN
  SELECT porcentaje_descto 
  INTO v_descuento 
  FROM PORC_DESCTO_3RA_EDAD
  WHERE p_edad BETWEEN anno_ini AND anno_ter;

  RETURN v_descuento;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END obtener_descuento_edad;

 
-- Función para calcular los días de atraso de una atención
CREATE OR REPLACE FUNCTION calcular_dias_atraso(p_ate_id IN NUMBER) RETURN NUMBER IS
  v_dias_atraso NUMBER;
BEGIN
  SELECT fecha_pago - fecha_venc_pago
  INTO v_dias_atraso
  FROM PAGO_ATENCION
  WHERE ate_id = p_ate_id;

  RETURN v_dias_atraso;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END calcular_dias_atraso;

 
-- Función para calcular la edad del paciente al inicio del período
CREATE OR REPLACE FUNCTION calcular_edad_paciente(p_pac_run IN NUMBER, p_periodo IN VARCHAR2) RETURN NUMBER IS
  v_edad NUMBER;
  v_fecha_inicio DATE;
BEGIN
  v_fecha_inicio := TO_DATE('01-' || p_periodo, 'DD-MM-YYYY');

  SELECT FLOOR(MONTHS_BETWEEN(v_fecha_inicio, fecha_nacimiento) / 12)
  INTO v_edad
  FROM PACIENTE
  WHERE pac_run = p_pac_run;

  RETURN v_edad;
END calcular_edad_paciente;

 
-- Procedimiento para insertar datos en la tabla RESUMEN_ATENCIONES usando NDS
CREATE OR REPLACE PROCEDURE insertar_resumen_atenciones(p_ate_id IN NUMBER, p_monto_atencion IN NUMBER, p_dias_atraso IN NUMBER, p_descuento IN NUMBER, p_monto_final IN NUMBER) IS
  v_sql VARCHAR2(4000);
BEGIN
  v_sql := 'INSERT INTO resumen_atenciones (ate_id, monto_atencion, dias_atraso, descuento, monto_cancelar)
            VALUES (:1, :2, :3, :4, :5)';
  EXECUTE IMMEDIATE v_sql USING p_ate_id, p_monto_atencion, p_dias_atraso, p_descuento, p_monto_final;
END insertar_resumen_atenciones;

 
 
 -- Procedimiento principal para generar el informe
CREATE OR REPLACE PROCEDURE generar_informe(p_periodo IN VARCHAR2, p_limite_atraso IN NUMBER) IS
  CURSOR c_atenciones IS
    SELECT a.ate_id, pa.monto_atencion, p.pac_run, p.fecha_nacimiento
    FROM ATENCION a
    JOIN PACIENTE p ON a.pac_run = p.pac_run
    JOIN PAGO_ATENCION pa ON a.ate_id = pa.ate_id;

  v_ate_id NUMBER;
  v_monto_atencion NUMBER;
  v_pac_run NUMBER;
  v_edad NUMBER;
  v_descuento NUMBER;
  v_dias_atraso NUMBER;
  v_monto_final NUMBER;
  v_error_id NUMBER; -- Variable para almacenar el id de la secuencia
  v_error_mensaje VARCHAR2(200); -- Variable para almacenar el mensaje de error
BEGIN
  FOR r IN c_atenciones LOOP
    BEGIN
      -- Asignar valores a variables locales
      v_ate_id := r.ate_id;
      v_monto_atencion := r.monto_atencion;
      v_pac_run := r.pac_run;

      -- Obtener la edad del paciente al inicio del período
      v_edad := calcular_edad_paciente(v_pac_run, p_periodo);
      
      -- Obtener el descuento basado en la edad
      v_descuento := obtener_descuento_edad(v_edad);
      
      -- Calcular los días de atraso
      v_dias_atraso := calcular_dias_atraso(v_ate_id);
      
      -- Verificar si los días de atraso superan el límite permitido
      IF v_dias_atraso > p_limite_atraso THEN
        RAISE_APPLICATION_ERROR(-20001, 'Límite de días de atraso excedido.');
      END IF;
      
      -- Calcular el monto final después del descuento
      v_monto_final := v_monto_atencion - v_descuento;

      -- Insertar en la tabla RESUMEN_ATENCIONES usando NDS
      insertar_resumen_atenciones(v_ate_id, v_monto_atencion, v_dias_atraso, v_descuento, v_monto_final);
    EXCEPTION
      WHEN OTHERS THEN
        -- Obtener el id de la secuencia y el mensaje de error
        SELECT seq_error.NEXTVAL INTO v_error_id FROM dual; -- Obtener el próximo valor de la secuencia
        v_error_mensaje := SUBSTR(SQLERRM, 1, 200); -- Limitar el mensaje de error a 200 caracteres
        
        -- Registrar el error en la tabla ERRORES_INFORME
        INSERT INTO errores_informe (id_error, rutina_afectada, mensaje_oracle)
        VALUES (v_error_id, 'generar_informe', v_error_mensaje);
    END;
  END LOOP;
END generar_informe;



BEGIN
  generar_informe('06-2021', 150);
END;



SELECT * FROM errores_informe;
SELECT * FROM resumen_atenciones;
