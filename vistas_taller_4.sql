--1. Saldo total de cada cliente
CREATE VIEW saldo_total_por_cliente AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(cb.saldo) AS saldo_total
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido;

--2. Transacciones recientes de clientes
CREATE VIEW transacciones_recientes AS
SELECT 
    t.*,
    c.nombre,
    c.apellido
FROM 
    transacciones t
JOIN 
    cuentas_bancarias cb ON t.cuenta_id = cb.cuenta_id
JOIN 
    clientes c ON cb.cliente_id = c.cliente_id
WHERE 
    t.fecha_transaccion >= NOW() - INTERVAL '30 days';

--3. Clientes con cuentas en múltiples sucursales
CREATE VIEW clientes_multisucursal AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT cb.sucursal_id) AS num_sucursales
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
HAVING 
    COUNT(DISTINCT cb.sucursal_id) > 1;


--4. Transacciones de cuentas con saldo alto
CREATE VIEW transacciones_cuentas_saldo_alto AS
SELECT 
    t.*,
    cb.saldo
FROM 
    transacciones t
JOIN 
    cuentas_bancarias cb ON t.cuenta_id = cb.cuenta_id
WHERE 
    cb.saldo > 5000;

--5. Préstamos y total adeudado por cliente
CREATE VIEW prestamos_total_adeudado AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(p.monto) AS total_adeudado
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN 
    prestamos p ON cb.cuenta_id = p.cuenta_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido;


--6. Cuentas con alta actividad reciente
CREATE VIEW cuentas_alta_actividad AS
SELECT 
    t.cuenta_id,
    COUNT(t.transaccion_id) AS num_transacciones
FROM 
    transacciones t
WHERE 
    t.fecha_transaccion >= NOW() - INTERVAL '1 month'
GROUP BY 
    t.cuenta_id
HAVING 
    COUNT(t.transaccion_id) > 3;


--7. Clientes con retiros altos
CREATE VIEW clientes_retiros_altos AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    t.monto AS monto_retiro
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN 
    transacciones t ON cb.cuenta_id = t.cuenta_id
WHERE 
    t.tipo_transaccion = 'retiro' AND t.monto > 1000;


--8. Clientes y número de sucursales
CREATE VIEW sucursales_num_clientes AS
SELECT 
    s.sucursal_id,
    s.nombre AS nombre_sucursal,
    COUNT(DISTINCT cb.cliente_id) AS num_clientes
FROM 
    sucursales s
JOIN 
    cuentas_bancarias cb ON s.sucursal_id = cb.sucursal_id
GROUP BY 
    s.sucursal_id, s.nombre;

--9. Clientes con múltiples tipos de cuentas
CREATE VIEW clientes_multiples_tipos_cuentas AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT cb.tipo_cuenta) AS num_tipos_cuenta
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
HAVING 
    COUNT(DISTINCT cb.tipo_cuenta) > 1;


--10. Préstamos superiores al promedio
CREATE VIEW prestamos_superiores_promedio AS
SELECT 
    p.*
FROM 
    prestamos p
WHERE 
    p.monto > (SELECT AVG(monto) FROM prestamos);