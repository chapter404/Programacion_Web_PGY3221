CREATE OR REPLACE TRIGGER trg_update_sueldo
AFTER UPDATE OF sueldo_base ON vendedor
FOR EACH ROW
BEGIN
   INSERT INTO bitacora (id_bitacora, rutvendedor, anterior, actual, variacion)
   VALUES (SEQ_BITACORA.NEXTVAL, :OLD.rutvendedor, :OLD.sueldo_base, :NEW.sueldo_base, :NEW.sueldo_base - :OLD.sueldo_base);
END;

UPDATE vendedor SET sueldo_base = 500000 WHERE rutvendedor = '10656569-K';
UPDATE vendedor SET sueldo_base = 450000 WHERE rutvendedor = '12456778-1';


CREATE OR REPLACE PACKAGE pkg_ventas IS
   v_anio_proceso NUMBER; 
   v_error_msg VARCHAR2(4000); 
   v_rut_vendedor VARCHAR2(20); 

   FUNCTION f_monto_ventas_vendedor(p_rut VARCHAR2) RETURN NUMBER;
   PROCEDURE p_manejar_errores(p_error VARCHAR2);
END pkg_ventas;

CREATE OR REPLACE PACKAGE BODY pkg_ventas IS
   FUNCTION f_monto_ventas_vendedor(p_rut VARCHAR2) RETURN NUMBER IS
      v_total NUMBER;
   BEGIN
      SELECT SUM(total)
      INTO v_total
      FROM boleta
      WHERE rutvendedor = p_rut
      AND EXTRACT(YEAR FROM fecha) = v_anio_proceso;
      
      RETURN NVL(v_total, 0);
   END f_monto_ventas_vendedor;

   PROCEDURE p_manejar_errores(p_error VARCHAR2) IS
   BEGIN
      INSERT INTO error_procesos_mensuales (correl_error, rutina_error, descrip_error)
      VALUES (SEQ_ERROR.NEXTVAL, 'sp_informe', p_error);
   END p_manejar_errores;
END pkg_ventas;


CREATE OR REPLACE FUNCTION f_monto_total_ventas(p_anio NUMBER) RETURN NUMBER IS
   v_total_ventas NUMBER;
BEGIN
   SELECT SUM(total)
   INTO v_total_ventas
   FROM boleta
   WHERE EXTRACT(YEAR FROM fecha) = p_anio;

   RETURN NVL(v_total_ventas, 0);
END f_monto_total_ventas;


CREATE OR REPLACE PROCEDURE sp_informe IS
   CURSOR c_vendedores IS -- Definimos el cursor explícito
      SELECT rutvendedor, nombre, sueldo_base, codcomuna
      FROM vendedor;
   
   v_total_ventas NUMBER;
   v_aporte NUMBER;
   v_rutvendedor VARCHAR2(10);
   v_nombre VARCHAR2(30);
   v_sueldo_base NUMBER;
   v_codcomuna NUMBER;
BEGIN
   -- Obtener el total de ventas del año en proceso
   v_total_ventas := f_monto_total_ventas(pkg_ventas.v_anio_proceso);

   -- Verificar si el total de ventas es mayor a cero
   IF v_total_ventas > 0 THEN
      -- Abrimos el cursor explícito
      OPEN c_vendedores;
      LOOP
         FETCH c_vendedores INTO v_rutvendedor, v_nombre, v_sueldo_base, v_codcomuna;
         EXIT WHEN c_vendedores%NOTFOUND; -- Terminamos el bucle cuando no haya más registros
         
         -- Calculamos el aporte de ventas
         v_aporte := (pkg_ventas.f_monto_ventas_vendedor(v_rutvendedor) / v_total_ventas) * 100;
         
         -- Usamos SQL dinámico para realizar la inserción en la tabla PORCENTAJE_VENDEDOR
         BEGIN
            EXECUTE IMMEDIATE 'INSERT INTO porcentaje_vendedor (anio, rutvendedor, nomvendedor, comuna, sueldo_base, aporte_ventas)
                               VALUES (:1, :2, :3, :4, :5, :6)'
            USING pkg_ventas.v_anio_proceso, v_rutvendedor, v_nombre, v_codcomuna, v_sueldo_base, v_aporte;
         EXCEPTION
            WHEN OTHERS THEN
               -- Registrar error en la tabla de errores si hay un problema en la inserción
               pkg_ventas.p_manejar_errores(SQLERRM);
         END;
      END LOOP;

      -- Cerramos el cursor
      CLOSE c_vendedores;
   ELSE
      -- Registrar el error si no hay ventas
      pkg_ventas.p_manejar_errores('No se encontraron ventas para el año ' || pkg_ventas.v_anio_proceso);
   END IF;
END sp_informe;


BEGIN
   -- Establecer el año en proceso
   pkg_ventas.v_anio_proceso := 2022;

   -- Ejecutar el informe
   sp_informe;
END;


-- Ver bitácora de cambios de sueldo
SELECT * FROM bitacora;

-- Ver aportes de ventas por vendedor
SELECT * FROM porcentaje_vendedor;

-- Ver errores generados durante el proceso
SELECT * FROM error_procesos_mensuales;
