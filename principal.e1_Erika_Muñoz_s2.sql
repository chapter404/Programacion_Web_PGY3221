--1 Cantidad de atenciones registradas en un período por un médico 
CREATE OR REPLACE FUNCTION FN_CANTIDAD_ATENCIONES(
  p_rut_medico IN VARCHAR2,
  p_periodo IN VARCHAR2
) RETURN NUMBER AS
v_cantidad_atenciones NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cantidad_atenciones
  FROM ATENCION
  WHERE med_run = p_rut_medico
  AND fecha_atencion >= TO_DATE(p_periodo || '-01', 'MM-YYYY-DD')
  AND fecha_atencion < ADD_MONTHS(TO_DATE(p_periodo || '-01', 'MM-YYYY-DD'), 1);
  RETURN v_cantidad_atenciones;
END FN_CANTIDAD_ATENCIONES;

--2 Promedio de sueldos de los médicos que pertenecen a un cargo
CREATE OR REPLACE FUNCTION FN_PROMEDIO_SUELDO_CARGO(
  p_id_cargo IN NUMBER
) RETURN NUMBER AS
v_promedio_sueldo NUMBER;
BEGIN
  SELECT AVG(sueldo_base) INTO v_promedio_sueldo
  FROM MEDICO
  WHERE car_id = p_id_cargo;
  RETURN v_promedio_sueldo;
END FN_PROMEDIO_SUELDO_CARGO;

--3 Costo total de las atenciones registradas en un período
CREATE OR REPLACE FUNCTION FN_COSTO_TOTAL_ATENCIONES(
  p_periodo IN VARCHAR2
) RETURN NUMBER AS
v_costo_total NUMBER;
BEGIN
  SELECT SUM(costo) INTO v_costo_total
  FROM ATENCION
  WHERE fecha_atencion >= TO_DATE(p_periodo || '-01', 'MM-YYYY-DD')
  AND fecha_atencion < ADD_MONTHS(TO_DATE(p_periodo || '-01', 'MM-YYYY-DD'), 1);
  RETURN v_costo_total;
END FN_COSTO_TOTAL_ATENCIONES;



--Procedimiento almacenado principal
CREATE OR REPLACE PROCEDURE SP_GENERAR_INFORMES(
  p_id_unidad IN NUMBER,
  p_periodo IN VARCHAR2
) AS
BEGIN
-- Generar informe RESUMEN_MEDICO
  FOR medico IN (
    SELECT m.med_run, m.pnombre || ' ' || m.apaterno || ' ' || m.amaterno AS nombre_completo,
           c.nombre AS nombre_cargo, u.nombre AS nombre_unidad,
           m.sueldo_base, m.car_id, FN_PROMEDIO_SUELDO_CARGO(m.car_id) AS promedio_sueldo_cargo
    FROM MEDICO m
    JOIN CARGO c ON m.car_id = c.car_id
    JOIN UNIDAD u ON m.uni_id = u.uni_id
    WHERE m.uni_id = p_id_unidad
  ) LOOP
    INSERT INTO RESUMEN_MEDICO (
      RUT_MEDICO, NOMBRE_COMPLETO, NOMBRE_CARGO, NOMBRE_UNIDAD, SUELDO_BASE, DIFERENCIA_CARGO, SOBRE_PROMEDIO
    ) VALUES (
      medico.med_run, medico.nombre_completo, medico.nombre_cargo, medico.nombre_unidad,
      medico.sueldo_base, medico.sueldo_base - medico.promedio_sueldo_cargo,
      CASE WHEN medico.sueldo_base >= medico.promedio_sueldo_cargo THEN 'SI' ELSE 'NO' END
    );
  END LOOP;
-- Generar informe DETALLE_ATENCIONES
  FOR cur_atencion IN (
    SELECT m.med_run, p_periodo AS periodo, COUNT(*) AS total_atenciones, SUM(a.costo) AS costo_atenciones
    FROM ATENCION a
    JOIN MEDICO m ON a.med_run = m.med_run
    WHERE a.fecha_atencion >= TO_DATE(p_periodo || '-01', 'MM-YYYY-DD')
    AND a.fecha_atencion < ADD_MONTHS(TO_DATE(p_periodo || '-01', 'MM-YYYY-DD'), 1)
    GROUP BY m.med_run
  ) LOOP
    INSERT INTO DETALLE_ATENCIONES (
      RUT_MEDICO, PERIODO, TOTAL_ATENCIONES, COSTO_ATENCIONES, TASA_APORTE_PERIODO
    ) VALUES (
      cur_atencion.med_run, cur_atencion.periodo, cur_atencion.total_atenciones, cur_atencion.costo_atenciones,
      cur_atencion.costo_atenciones / FN_COSTO_TOTAL_ATENCIONES(p_periodo)
    );
  END LOOP;
END SP_GENERAR_INFORMES;


----BLOQUE PARA PROBAR LA FUNCION PRINCIPAL  (EL CUAL ME FALTO LA SEMANA 1 CREO!! :))
DECLARE
  v_id_unidad NUMBER := 1; 
  v_periodo VARCHAR2(6) := '202201'; 
BEGIN
  SP_GENERAR_INFORMES(v_id_unidad, v_periodo);
  DBMS_OUTPUT.PUT_LINE('Informe generado correctamente');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al generar informe: ' || SQLERRM);
END;

