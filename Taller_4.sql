--1. Saldo total de cada cliente
--Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.

CREATE VIEW SaldoTotalClientes AS
SELECT 
    c.cliente_id,
    c.Nombre,
    SUM(cb.Saldo) AS SaldoTotal
FROM 
    clientes c
    JOIN cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id,
    c.Nombre;

--2. Transacciones recientes de clientes
--Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.

CREATE VIEW transacciones_recientes_clientes AS
SELECT
	c.cliente_id,
	c.nombre AS cliente_nombre,
    t.tipo_transaccion,
    t.monto,
    t.fecha_transaccion,
    t.descripcion,
	t.transaccion_id,
    t.cuenta_id    
FROM
    transacciones t
JOIN
    cuentas_bancarias cb ON t.cuenta_id = cb.cuenta_id
JOIN
    clientes c ON cb.cliente_id = c.cliente_id
WHERE
    t.fecha_transaccion >= CURRENT_DATE - INTERVAL '30 days';
	
--3. Clientes con cuentas en múltiples sucursales
--Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.

CREATE VIEW Clientes_Multiples_Sucursales AS
SELECT 
    c.cliente_id,
    c.nombre AS nombre_cliente,
    COUNT(DISTINCT cb.sucursal_id) AS num_sucursales
FROM 
    Clientes c
JOIN 
    Cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre
HAVING 
    COUNT(DISTINCT cb.sucursal_id) > 1;

--4. Transacciones de cuentas con saldo alto
--Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.

CREATE VIEW transacciones_cuentas_saldo_alto AS
SELECT
    t.transaccion_id,
    t.cuenta_id,
	c.saldo AS Saldo_cuenta,
    t.tipo_transaccion,
    t.monto,
    t.fecha_transaccion,
    t.descripcion
FROM
    transacciones t
JOIN
    cuentas_bancarias c ON t.cuenta_id = c.cuenta_id
WHERE
    c.saldo > 5000;


--5. Préstamos y total adeudado por cliente
--Crear una vista que muestre los clientes con préstamos y el total adeudado.
CREATE VIEW prestamos_y_total_adeudado AS
SELECT
    c.cliente_id,
    c.nombre,
    COALESCE(SUM(p.monto), 0) AS total_adeudado
FROM
    clientes c
JOIN
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN
    prestamos p ON cb.cuenta_id = p.cuenta_id
GROUP BY
    c.cliente_id, c.nombre;
	

--6. Cuentas con alta actividad reciente
--Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
CREATE VIEW cuentas_con_alta_actividad_reciente AS
SELECT
    t.cuenta_id,
    COUNT(t.transaccion_id) AS cantidad_transacciones
FROM
    transacciones t
WHERE
    t.fecha_transaccion >= CURRENT_DATE - INTERVAL '30 DAYS'
GROUP BY
    t.cuenta_id
HAVING
    COUNT(t.transaccion_id) > 3;

--7. Clientes con retiros altos
--Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.

CREATE VIEW ClientesConRetirosAltos AS
SELECT
    c.cliente_id,
    c.nombre,
    t.monto AS monto_retiro,
    t.fecha_transaccion
FROM
    Clientes c
JOIN
    cuentas_bancarias cu ON c.cliente_id = cu.cliente_id
JOIN
    Transacciones t ON cu.cuenta_id = t.cuenta_id
WHERE
    t.tipo_transaccion = 'retiro' AND
    t.monto > 1000;
	
--8. Clientes y número de sucursales
--Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.

CREATE VIEW SucursalesYNumeroDeClientes AS
SELECT
    s.sucursal_id,
    s.nombre,
    COUNT(c.cliente_id) AS numero_de_clientes
FROM
    Sucursales s
LEFT JOIN
    Clientes c ON s.sucursal_id = c.sucursal_id
GROUP BY
    s.sucursal_id,
    s.nombre;
	
--9. Clientes con múltiples tipos de cuentas
--Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.

CREATE VIEW ClientesConMultiplesTiposDeCuentas AS
SELECT
    c.cliente_id,
    c.nombre,
    COUNT(DISTINCT cu.tipo_cuenta) AS numero_tipos_cuenta
FROM
    Clientes c
JOIN
    Cuentas_bancarias cu ON c.cliente_id = cu.cliente_id
GROUP BY
    c.cliente_id,
    c.nombre
HAVING
    COUNT(DISTINCT cu.tipo_cuenta) > 1;
	
--10. Préstamos superiores al promedio
--Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.

CREATE VIEW PrestamosSuperioresAlPromedio AS
SELECT
    p.prestamo_id,
    p.monto,
    p.fecha_inicio,
    p.cuenta_id
FROM
    Prestamos p
WHERE
    p.monto > (
        SELECT AVG(monto)
        FROM Prestamos
    );