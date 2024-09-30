/* PARTE 1 */

/* Trigger que actualiza la tabla resumen_profesion al insertar un cliente o modificar su profesión*/
CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_RESUMEN_PROFESION
AFTER INSERT OR UPDATE ON CLIENTE
FOR EACH ROW
DECLARE
    v_codigo_profesion_nuevo NUMBER(3);
    v_codigo_profesion_antiguo NUMBER(3);
BEGIN
    IF INSERTING THEN
        v_codigo_profesion_nuevo := :NEW.cod_prof_ofic;
        
        UPDATE 
            RESUMEN_PROFESION
        SET
            total_clientes = total_clientes + 1
        WHERE
            id_profesion = v_codigo_profesion_nuevo;
    END IF;

    IF UPDATING THEN
        v_codigo_profesion_nuevo := :NEW.cod_prof_ofic;
        v_codigo_profesion_antiguo := :OLD.cod_prof_ofic;

        IF v_codigo_profesion_nuevo != v_codigo_profesion_antiguo THEN
            UPDATE
                RESUMEN_PROFESION
            SET
                total_clientes = total_clientes - 1
            WHERE 
                id_profesion = v_codigo_profesion_antiguo;

            UPDATE
                RESUMEN_PROFESION
            SET
                total_clientes = total_clientes + 1
            WHERE
                id_profesion = v_codigo_profesion_nuevo;
        END IF;
    END IF;
END;


/* Prueba para verificar la acción del trigger al modificar la profesion de un cliente */
SELECT *
FROM CLIENTE
WHERE nro_cliente = 16;

SELECT *
FROM RESUMEN_PROFESION
WHERE id_profesion = 21 OR
      id_profesion = 19;

UPDATE CLIENTE
SET cod_prof_ofic = 19
WHERE nro_cliente = 16;

SELECT *
FROM RESUMEN_PROFESION
WHERE id_profesion = 21 OR
      id_profesion = 19;

/* Prueba para verificar la acción del trigger al insertar un nuevo cliente */
SELECT *
FROM RESUMEN_PROFESION
WHERE id_profesion = 20;

INSERT INTO CLIENTE
VALUES(131, 6016402, '9', 'MARIO', NULL, 'MONDACA',
       'BERRIOS', TO_DATE('19/12/1957', 'DD-MM-YYYY'),
       TO_DATE('29/03/1987','DD-MM-YYYY'), NULL, NULL,
       'Avda. presidente Riesco 234 ', '13', '1', '14' , '20', '2');
       
SELECT *
FROM RESUMEN_PROFESION
WHERE id_profesion = 20;




/* PARTE 2 */

/* Paquete con herramientas para generar el resumen de clientes */
/* Declaración del paquete */
CREATE OR REPLACE PACKAGE PKG_RESUMEN_CLIENTE IS
    v_cod_region NUMBER(3);
    v_error_msg VARCHAR2(250);
    
    FUNCTION FN_OBTENER_PRODUCTOS_INVERSION(p_nro_cliente IN NUMBER) RETURN NUMBER;

    PROCEDURE SP_INSERTAR_REG_RESUMEN_CLIENTE(
        p_nro_cliente IN NUMBER,
        p_rut_cliente IN VARCHAR2,
        p_region_residencia IN VARCHAR2,
        p_mes_inscripcion IN NUMBER,
        p_mensaje IN VARCHAR2,
        p_rango_inversion IN VARCHAR2
    );

    PROCEDURE SP_GENERAR_RESUMEN_CLIENTE(p_codigo_region IN NUMBER);

END PKG_RESUMEN_CLIENTE;



/* Cuerpo del paquete */
CREATE OR REPLACE PACKAGE BODY PKG_RESUMEN_CLIENTE IS

    FUNCTION FN_OBTENER_PRODUCTOS_INVERSION(p_nro_cliente IN NUMBER)
    RETURN NUMBER
    IS
        v_cantidad NUMBER;
    BEGIN
        EXECUTE IMMEDIATE
            'SELECT
                COUNT(*)
            FROM
                PRODUCTO_INVERSION_CLIENTE
            WHERE
                nro_cliente = :1'
        INTO
            v_cantidad
        USING
            p_nro_cliente;

        RETURN NVL(v_cantidad, 0);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        
        WHEN OTHERS THEN
            v_error_msg := SQLERRM;
            INSERT INTO ERROR_PROCESO
            VALUES (SEQ_ERROR.NEXTVAL, 'Error en FN_OBTENER_PRODUCTOS_INVERSION', v_error_msg);
            RETURN 0;
    END FN_OBTENER_PRODUCTOS_INVERSION;
    

    PROCEDURE SP_INSERTAR_REG_RESUMEN_CLIENTE(
        p_nro_cliente IN NUMBER,
        p_rut_cliente IN VARCHAR2,
        p_region_residencia IN VARCHAR2,
        p_mes_inscripcion IN NUMBER,
        p_mensaje IN VARCHAR2,
        p_rango_inversion IN VARCHAR2)
    IS
        v_cantidad_productos_inv NUMBER;
    BEGIN
        v_cantidad_productos_inv := FN_OBTENER_PRODUCTOS_INVERSION(p_nro_cliente);
        INSERT INTO resumen_cliente
        VALUES (p_rut_cliente,
                p_region_residencia,
                p_mes_inscripcion,
                p_mensaje,
                v_cantidad_productos_inv,
                p_rango_inversion);
    EXCEPTION
        WHEN OTHERS THEN
            v_error_msg := SQLERRM;
            INSERT INTO ERROR_PROCESO
            VALUES (SEQ_ERROR.NEXTVAL, 'Error en SP_INSERTAR_REG_RESUMEN_CLIENTE', v_error_msg);
    END SP_INSERTAR_REG_RESUMEN_CLIENTE;


    FUNCTION FN_OBTENER_MENSAJE_ANIVERSARIO(p_mes_inscripcion IN NUMBER)
    RETURN VARCHAR2
    IS
        v_mes_actual NUMBER := EXTRACT(MONTH FROM SYSDATE);
    BEGIN
        IF v_mes_actual = p_mes_inscripcion THEN
            RETURN 'MES ANIVERSARIO';
        ELSE
            RETURN 'NO ANIVERSARIO';
        END IF;
        
        EXCEPTION
        WHEN OTHERS THEN
            v_error_msg := SQLERRM;
            INSERT INTO ERROR_PROCESO
            VALUES (SEQ_ERROR.NEXTVAL, 'Error en FN_OBTENER_MENSAJE_ANIVERSARIO', v_error_msg);
    END FN_OBTENER_MENSAJE_ANIVERSARIO;


    PROCEDURE SP_GENERAR_RESUMEN_CLIENTE(p_codigo_region IN NUMBER)
    IS
        v_rango_inversion VARCHAR2(1);
        v_mensaje VARCHAR2(100);
        v_cantidad_productos_inversion NUMBER;
        
        CURSOR cur_clientes IS
            SELECT
                c.nro_cliente,
                c.numrun, 
                c.dvrun,
                r.nombre_region,
                EXTRACT(MONTH FROM c.fecha_inscripcion) AS mes_inscripcion
            FROM
                cliente c
            JOIN
                region r ON c.cod_region = r.cod_region
            WHERE
                r.cod_region = p_codigo_region
            ORDER BY
                c.numrun;
                
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_CLIENTE';
        
        FOR registro IN cur_clientes LOOP
            BEGIN
                v_cantidad_productos_inversion := FN_OBTENER_PRODUCTOS_INVERSION(registro.nro_cliente);
                v_mensaje := FN_OBTENER_MENSAJE_ANIVERSARIO(registro.mes_inscripcion);
            
                SELECT
                    rango
                INTO
                    v_rango_inversion
                FROM
                    rango_inversion
                WHERE
                    v_cantidad_productos_inversion BETWEEN limite_inf AND limite_sup;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_error_msg := SQLERRM;
                    v_rango_inversion := '*';
                    INSERT INTO ERROR_PROCESO
                    VALUES (SEQ_ERROR.NEXTVAL, 'No se encontró rango de inversión', 'Cliente: ' || registro.numrun);
                    
                WHEN OTHERS THEN
                    v_error_msg := SQLERRM;
                    INSERT INTO ERROR_PROCESO
                    VALUES (SEQ_ERROR.NEXTVAL, 'Error en SP_GENERAR_RESUMEN_CLIENTE', v_error_msg);
            END;
            
            SP_INSERTAR_REG_RESUMEN_CLIENTE(registro.nro_cliente, 
                                            TO_CHAR(registro.numrun) || '-' || registro.dvrun,
                                            registro.nombre_region,
                                            registro.mes_inscripcion,
                                            v_mensaje,
                                            v_rango_inversion);
        END LOOP;
    END SP_GENERAR_RESUMEN_CLIENTE;
END PKG_RESUMEN_CLIENTE;



/* Bloque anonimo para asignar variables y llamar al procedimiento generador de informes del paquete */
BEGIN
    PKG_RESUMEN_CLIENTE.v_cod_region := 6;

    PKG_RESUMEN_CLIENTE.SP_GENERAR_RESUMEN_CLIENTE(PKG_RESUMEN_CLIENTE.v_cod_region);
END;

/* Pruebas de funcionamiento: consultar tablas*/
SELECT *
FROM RESUMEN_CLIENTE;

SELECT *
FROM ERROR_PROCESO;

--TRUNCATE TABLE ERROR_PROCESO;
--TRUNCATE TABLE RESUMEN_CLIENTE;


