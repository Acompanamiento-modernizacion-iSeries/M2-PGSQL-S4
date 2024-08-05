-- Requisitos previos
ALTER TABLE cuentas_bancarias ADD COLUMN sucursal_id INT REFERENCES sucursales(sucursal_id);

UPDATE cuentas_bancarias SET sucursal_id = 1 WHERE cuenta_id IN (1, 2);

UPDATE cuentas_bancarias SET sucursal_id = 2 WHERE cuenta_id IN (3, 4);

-- 1. Saldo total de cada cliente
CREATE OR REPLACE VIEW saldo_total_cliente AS 
SELECT cli.*, SUM(cb.saldo) AS saldo_total FROM cuentas_bancarias cb
INNER JOIN clientes cli
ON cb.cliente_id = cli.cliente_id
GROUP BY cli.cliente_id;

-- 2. Transacciones recientes de clientes
CREATE OR REPLACE VIEW transacciones_cliente_30d AS
SELECT cli.*, tra.* FROM transacciones tra
INNER JOIN cuentas_bancarias cb
ON tra.cuenta_id = cb.cuenta_id
INNER JOIN clientes cli
ON cb.cliente_id = cli.cliente_id
WHERE tra.fecha_transaccion > (CURRENT_DATE - 30);

-- 3. Clientes con cuentas en múltiples sucursales
CREATE OR REPLACE VIEW cuenta_mas1_sucursal AS
SELECT cli.cliente_id, cli.nombre, cli.apellido, suc.nombre AS nombre_sucursal FROM clientes cli
INNER JOIN cuentas_bancarias cb
ON cli.cliente_id = cb.cliente_id
INNER JOIN sucursales suc
ON suc.sucursal_id = cb.sucursal_id;

-- 4. Transacciones de cuentas con saldo alto
CREATE OR REPLACE VIEW cuenta_saldo_alto AS
SELECT tra.*, cb.saldo FROM transacciones tra
INNER JOIN cuentas_bancarias cb
ON tra.cuenta_id = cb.cuenta_id
WHERE cb.saldo > 5000;

-- 5. Préstamos y total adeudado por cliente
CREATE OR REPLACE VIEW prestamo_y_total_adeudado_cli AS
SELECT cli.*, SUM(pre.monto) AS deuda FROM clientes cli
INNER JOIN cuentas_bancarias cb
ON cli.cliente_id = cb.cliente_id
INNER JOIN prestamos pre
ON cb.cuenta_id = pre.cuenta_id
GROUP BY cli.cliente_id;

-- 6. Cuentas con alta actividad reciente
CREATE OR REPLACE VIEW cuentas_alta_actividad AS
SELECT cb.*, COUNT(tra.*) AS transacciones FROM cuentas_bancarias cb
INNER JOIN transacciones tra
ON tra.cuenta_id = cb.cuenta_id
GROUP BY cb.cuenta_id
HAVING COUNT(tra.*) >= 3;

-- 7. Clientes con retiros altos
CREATE OR REPLACE VIEW clientes_retiro_alto AS
SELECT cli.*, tra.monto FROM clientes cli
INNER JOIN cuentas_bancarias cb
ON cb.cliente_id = cli.cliente_id
INNER JOIN transacciones tra
ON tra.cuenta_id = cb.cuenta_id
WHERE tra.tipo_transaccion = 'retiro' AND tra.monto > 1000;

-- 8. Clientes y número de sucursales
CREATE OR REPLACE VIEW clientes_y_sucursales AS
SELECT suc.*, COUNT(cli.*) AS num_clientes FROM clientes cli
INNER JOIN cuentas_bancarias cb
ON cb.cliente_id = cli.cliente_id
INNER JOIN sucursales suc
ON suc.sucursal_id = cb.sucursal_id
GROUP BY suc.sucursal_id;

-- 9. Clientes con múltiples tipos de cuentas
CREATE OR REPLACE VIEW clientes_multiples_cuentas AS
SELECT cli.*, COUNT(cb.*) AS cuentas FROM clientes cli
INNER JOIN cuentas_bancarias cb
ON cb.cliente_id = cli.cliente_id
GROUP BY cli.cliente_id
HAVING COUNT(cb.*) > 1;

-- 10. Préstamos superiores al promedio
CREATE OR REPLACE VIEW prestamos_sup_prom AS
WITH promedio AS (SELECT AVG(monto) AS promedio FROM prestamos)
SELECT * FROM prestamos pre, promedio pro
WHERE pre. monto > pro.promedio;