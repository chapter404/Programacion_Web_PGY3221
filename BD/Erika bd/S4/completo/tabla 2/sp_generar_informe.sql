CREATE OR REPLACE PROCEDURE sp_generar_informe(p_periodo VARCHAR2, p_limite_credito NUMBER) IS
    v_fecha_inicio DATE;
    v_fecha_fin DATE;
    v_credito_cliente VARCHAR2(20);
    v_cursor_boletas SYS_REFCURSOR;
    v_cursor_productos SYS_REFCURSOR;
    v_cursor_result SYS_REFCURSOR; 
    v_codigo_producto NUMBER;
    v_valor_unitario NUMBER;
    v_cantidad_boletas NUMBER;
    v_total_unidades NUMBER;
    v_porcentaje NUMBER;
    v_nuevo_precio NUMBER;
BEGIN
    
    v_fecha_inicio := TO_DATE('01-' || p_periodo, 'DD-MM-YYYY'); 
    v_fecha_fin := LAST_DAY(v_fecha_inicio);

    DBMS_OUTPUT.PUT_LINE('Fecha Inicio: ' || TO_CHAR(v_fecha_inicio, 'DD-MM-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Fecha Fin: ' || TO_CHAR(v_fecha_fin, 'DD-MM-YYYY'));
    
    DBMS_OUTPUT.PUT_LINE('Límite de Crédito: ' || p_limite_credito);
    OPEN v_cursor_boletas FOR
    SELECT rutcliente 
    FROM cliente
    WHERE credito >= p_limite_credito;

    DBMS_OUTPUT.PUT_LINE('Clientes con crédito igual o superior al límite:');
    LOOP
        FETCH v_cursor_boletas INTO v_credito_cliente;
        EXIT WHEN v_cursor_boletas%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('RUT Cliente: ' || v_credito_cliente);
    END LOOP;
    CLOSE v_cursor_boletas;
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_producto';
   
    OPEN v_cursor_productos FOR
    SELECT DISTINCT codproducto 
    FROM detalle_boleta;

    LOOP
        FETCH v_cursor_productos INTO v_codigo_producto;
        EXIT WHEN v_cursor_productos%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Código Producto: ' || v_codigo_producto);

        v_cursor_result := fn_obtener_boletas_y_unidades(v_codigo_producto, v_fecha_inicio, v_fecha_fin);

        LOOP
            FETCH v_cursor_result INTO v_cantidad_boletas, v_total_unidades;
            EXIT WHEN v_cursor_result%NOTFOUND;

            IF v_total_unidades IS NULL THEN
               v_total_unidades := 0;
            END IF;
            
            v_valor_unitario := fn_obtener_valor_unitario(v_codigo_producto);

            IF v_valor_unitario IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('Valor unitario no encontrado para el código producto: ' || v_codigo_producto);
                CONTINUE;
            END IF;
           
            v_porcentaje := fn_obtener_porcentaje(v_valor_unitario);

            IF v_porcentaje IS NULL THEN
                v_porcentaje := 0; 
            END IF;
            
            v_nuevo_precio := v_valor_unitario * (1 + v_porcentaje / 100); 

            DBMS_OUTPUT.PUT_LINE('Valor Unitario: ' || v_valor_unitario);
            DBMS_OUTPUT.PUT_LINE('Porcentaje Aplicado: ' || v_porcentaje);
            DBMS_OUTPUT.PUT_LINE('Total Boletas: ' || v_cantidad_boletas);
            DBMS_OUTPUT.PUT_LINE('Total Unidades: ' || v_total_unidades);
            DBMS_OUTPUT.PUT_LINE('Nuevo Precio: ' || v_nuevo_precio);
            DBMS_OUTPUT.PUT_LINE('*******************************************');
            
            BEGIN
                INSERT INTO RESUMEN_PRODUCTO (cod_producto, total_boletas, total_unidades, valor_unitario, porcentaje_aplicado, precio)
                VALUES (v_codigo_producto, v_cantidad_boletas, v_total_unidades, v_valor_unitario, v_porcentaje, v_nuevo_precio);
                DBMS_OUTPUT.PUT_LINE('Datos insertados correctamente para el código producto: ' || v_codigo_producto);
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error al insertar datos para el código producto: ' || v_codigo_producto || '. Error: ' || SQLERRM);
            END;
        END LOOP;
        CLOSE v_cursor_result;
    END LOOP;
    CLOSE v_cursor_productos;
END;

truncate table resumen_cliente; 


BEGIN
    sp_generar_informe('03-2023', 1000);
END;

select * from resumen_producto; 




