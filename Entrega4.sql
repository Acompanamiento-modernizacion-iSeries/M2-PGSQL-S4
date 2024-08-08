-- 1.Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.

CREATE OR REPLACE VIEW vista_saldo_total_cliente AS
SELECT c.cliente_id, c.nombre, c.apellido, SUM(cb.saldo) AS saldo_total
FROM clientes c
JOIN cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY c.cliente_id, c.nombre, c.apellido;

--2.Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.

CREATE OR REPLACE VIEW vista_transacciones_recientes AS
SELECT c.cliente_id, c.nombre, c.apellido, t.transaccion_id, t.cuenta_id, t.tipo_transaccion, t.monto, t.fecha_transaccion, t.descripcion
FROM transacciones t
JOIN cuentas_bancarias cb ON cb.cuenta_id = t.cuenta_id
JOIN clientes c ON c.cliente_id = cb.cliente_id
WHERE t.fecha_transaccion >= NOW() - INTERVAL '30 days';

-- 3.Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.

CREATE OR REPLACE VIEW vista_clientes_multiples_sucursales AS
SELECT c.cliente_id, c.nombre, c.apellido, COUNT(e.sucursal_id) AS num_sucursales
FROM clientes c
JOIN cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN empleados e ON cb.empleado_id = e.empleado_id
GROUP BY c.cliente_id, c.nombre, c.apellido
HAVING COUNT(e.sucursal_id) > 1;

-- 4.Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.

CREATE OR REPLACE VIEW vista_transacciones_cuentas_saldo_alto AS
SELECT cb.numero_cuenta, cb.tipo_cuenta, cb.saldo, t.transaccion_id, t.cuenta_id, t.tipo_transaccion, t.monto, t.fecha_transaccion, t.descripcion
FROM transacciones t
JOIN cuentas_bancarias cb ON t.cuenta_id = cb.cuenta_id
WHERE cb.saldo > 5000;

-- 5.Crear una vista que muestre los clientes con préstamos y el total adeudado.


CREATE OR REPLACE VIEW vista_prestamos_total_adeudado AS
SELECT c.cliente_id, c.nombre, c.apellido, SUM(p.monto) AS total_adeudado
FROM clientes c
JOIN cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN prestamos p ON cb.cuenta_id = p.cuenta_id
GROUP BY c.cliente_id, c.nombre, c.apellido;

-- 6.Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.

CREATE OR REPLACE VIEW vista_cuentas_alta_actividad AS
SELECT t.cuenta_id,	t.fecha_transaccion, COUNT(t.transaccion_id) AS num_transacciones
FROM transacciones t
WHERE t.fecha_transaccion >= NOW() - INTERVAL '1 month'
GROUP BY t.cuenta_id, t.fecha_transaccion
HAVING COUNT(t.transaccion_id) > 3;

-- 7.Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.

CREATE OR REPLACE VIEW vista_clientes_retiros_altos AS
SELECT c.cliente_id, c.nombre, c.apellido, t.monto, t.fecha_transaccion
FROM clientes c
JOIN cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN transacciones t ON cb.cuenta_id = t.cuenta_id
WHERE t.tipo_transaccion = 'retiro' AND t.monto > 1000;

-- 8.Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.

CREATE OR REPLACE VIEW vista_sucursales_num_clientes AS
SELECT e.sucursal_id, s.nombre AS sucursal_nombre, COUNT(c.cliente_id) AS num_clientes
FROM sucursales s
JOIN empleados e ON s.sucursal_id = e.sucursal_id
JOIN cuentas_bancarias cb ON e.empleado_id = cb.empleado_id
JOIN clientes c ON cb.cliente_id = c.cliente_id
GROUP BY e.sucursal_id, s.nombre;

-- 9.Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.

CREATE OR REPLACE VIEW vista_clientes_multiples_tipos_cuentas AS
SELECT c.cliente_id, c.nombre, c.apellido, COUNT(cb.tipo_cuenta) AS num_tipos_cuenta
FROM clientes c
JOIN cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY c.cliente_id, c.nombre, c.apellido
HAVING COUNT(DISTINCT cb.tipo_cuenta) > 1;

-- 10.Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.

CREATE OR REPLACE VIEW vista_prestamos_superiores_al_promedio AS
WITH promedio_prestamos AS ( SELECT AVG(monto) AS promedio FROM prestamos)
SELECT p.prestamo_id, p.cuenta_id, p.monto, p.tasa_interes, p.fecha_inicio, p.fecha_fin, p.estado
FROM prestamos p, promedio_prestamos pp
WHERE p.monto > pp.promedio;
