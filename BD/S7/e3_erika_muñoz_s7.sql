----Primera Parte: Mantener Actualizada la Tabla RESUMEN_COSTOS
CREATE OR REPLACE PROCEDURE actualizar_resumen_costos AS
BEGIN
   
    MERGE INTO RESUMEN_COSTOS rc
    USING (
        SELECT TO_CHAR(fecha_atencion, 'MM-YYYY') AS periodo,
               SUM(costo) AS costo_total,
               COUNT(*) AS total_atenciones
        FROM ATENCION
        GROUP BY TO_CHAR(fecha_atencion, 'MM-YYYY')
    ) a
    ON (rc.periodo = a.periodo)
    WHEN MATCHED THEN
        UPDATE SET rc.costo_total = a.costo_total,
                   rc.total_atenciones = a.total_atenciones
    WHEN NOT MATCHED THEN
        INSERT (periodo, costo_total, total_atenciones)
        VALUES (a.periodo, a.costo_total, a.total_atenciones);

    -- Mensaje de ?xito
    DBMS_OUTPUT.PUT_LINE('Tabla RESUMEN_COSTOS actualizada exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar RESUMEN_COSTOS: ' || SQLERRM);
END;


    BEGIN
        actualizar_resumen_costos;
    END;


---Segunda Parte: Actualizar la Tabla RECARGO_ATENCION_FFAA
CREATE OR REPLACE PROCEDURE actualizar_recargo_ffaa AS
BEGIN
   
    MERGE INTO RECARGO_ATENCION_FFAA r
    USING (
        SELECT EXTRACT(YEAR FROM SYSDATE) AS anno_recargo,
               NVL(MAX(porc_recargo), 0) + 1 AS nuevo_porc_recargo
        FROM RECARGO_ATENCION_FFAA
        WHERE EXISTS (
            SELECT 1
            FROM PACIENTE p
            JOIN SALUD s ON p.sal_id = s.sal_id
            WHERE s.descripcion = 'FUERZAS ARMADA'
        )
    ) t
    ON (r.anno_recargo = t.anno_recargo)
    WHEN MATCHED THEN
        UPDATE SET r.porc_recargo = t.nuevo_porc_recargo
    WHEN NOT MATCHED THEN
        INSERT (anno_recargo, porc_recargo)
        VALUES (t.anno_recargo, t.nuevo_porc_recargo);

    DBMS_OUTPUT.PUT_LINE('Tabla RECARGO_ATENCION_FFAA actualizada exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar RECARGO_ATENCION_FFAA: ' || SQLERRM);
END;

--
 BEGIN
        actualizar_recargo_ffaa;
 END;


---Bloque PL/SQL para Pruebas
BEGIN
   
    UPDATE ATENCION
    SET costo = 28000
    WHERE ate_id = 476;

   
    BEGIN
        UPDATE ATENCION
        SET fecha_atencion = TO_DATE('2022-03-23', 'YYYY-MM-DD'),
            hr_atencion = '13:45',
            costo = 29000,
            med_run = 9827836,
            pac_run = 7378093
        WHERE ate_id = 573;

        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO ATENCION (ate_id, fecha_atencion, hr_atencion, costo, med_run, pac_run)
            VALUES (573, TO_DATE('2022-03-23', 'YYYY-MM-DD'), '13:45', 29000, 9827836, 7378093);
        END IF;
    END;

    BEGIN
        UPDATE ATENCION
        SET fecha_atencion = TO_DATE('2022-09-23', 'YYYY-MM-DD'),
            hr_atencion = '13:45',
            costo = 15000,
            med_run = 9827836,
            pac_run = 7378093
        WHERE ate_id = 574;

        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO ATENCION (ate_id, fecha_atencion, hr_atencion, costo, med_run, pac_run)
            VALUES (574, TO_DATE('2022-09-23', 'YYYY-MM-DD'), '13:45', 15000, 9827836, 7378093);
        END IF;
    END;

    actualizar_resumen_costos;

    DBMS_OUTPUT.PUT_LINE('Atenciones actualizadas e insertadas exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al modificar o insertar atenciones: ' || SQLERRM);
END;


SELECT ate_id FROM ATENCION WHERE ate_id IN (573, 574);
SELECT * FROM ATENCION WHERE ate_id IN (573, 574);

--selecionar tablas 
select * from ATENCION;
select * from RESUMEN_COSTOS;
select * from RECARGO_ATENCION_FFAA;