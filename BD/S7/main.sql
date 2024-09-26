CREATE OR REPLACE TRIGGER trg_update_resumen_atenmedicas
AFTER INSERT OR UPDATE OF costo ON ATENCION
FOR EACH ROW
DECLARE
    v_total_atenciones NUMBER;
    v_total_costo      NUMBER;
    v_exists           NUMBER; -- Variable para verificar si el período ya existe
BEGIN
    -- Obtén el total de atenciones y costos para el período de la nueva atención
    SELECT COUNT(*), SUM(costo)
    INTO v_total_atenciones, v_total_costo
    FROM ATENCION
    WHERE TO_CHAR(fecha_atencion, 'MM-YYYY') = TO_CHAR(:NEW.fecha_atencion, 'MM-YYYY');

    -- Verificar si ya existe un registro para el período en RESUMEN_ATENMEDICAS_MENSUALES
    SELECT COUNT(*)
    INTO v_exists
    FROM RESUMEN_ATENMEDICAS_MENSUALES
    WHERE mes_anno_atencion = TO_CHAR(:NEW.fecha_atencion, 'MM-YYYY');

    IF v_exists > 0 THEN
        -- Actualiza el registro existente
        UPDATE RESUMEN_ATENMEDICAS_MENSUALES
        SET total_aten_unid_adulto = v_total_atenciones, -- Ajusta según corresponda
            total_aten_unid_urgen = v_total_costo        -- Ajusta si el costo corresponde a otro campo
        WHERE mes_anno_atencion = TO_CHAR(:NEW.fecha_atencion, 'MM-YYYY');
    ELSE
        -- Inserta un nuevo registro si el período no existe
        INSERT INTO RESUMEN_ATENMEDICAS_MENSUALES (mes_anno_atencion, total_aten_unid_adulto, total_aten_unid_urgen, fecha_grabacion)
        VALUES (TO_CHAR(:NEW.fecha_atencion, 'MM-YYYY'), 1, :NEW.costo, SYSDATE);
    END IF;
END;



CREATE OR REPLACE TRIGGER trg_update_recargo_ffaa
AFTER INSERT OR UPDATE OF sal_id ON PACIENTE
FOR EACH ROW
DECLARE
    v_last_year    NUMBER;
    v_last_recargo NUMBER;
BEGIN
    -- Verificar si el sistema de salud es "FUERZAS ARMADA" (sal_id = 100)
    IF :NEW.sal_id = 100 THEN
        -- Obtener el último año y porcentaje de recargo registrado
        SELECT MAX(anno_recargo), porc_recargo
        INTO v_last_year, v_last_recargo
        FROM RECARGO_ATENCION_FFAA;

        -- Incrementar el recargo en un 1% para el último año
        INSERT INTO RECARGO_ATENCION_FFAA (anno_recargo, porc_recargo)
        VALUES (v_last_year + 1, v_last_recargo + 1);
    END IF;
END;

