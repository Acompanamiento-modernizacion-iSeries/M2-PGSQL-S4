#1
CREATE VIEW saldo_total_cliente AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(cb.saldo) AS saldo_total
FROM 
    Clientes c
    JOIN CuentasBancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido;

#2
CREATE VIEW transacciones_recentes AS
SELECT 
    t.transaccion_id,
    t.cuenta_id,
    t.tipo_transaccion,
    t.monto,
    t.fecha_transaccion,
    t.descripcion,
    c.cliente_id,
    c.nombre,
    c.apellido
FROM 
    Transacciones t
    JOIN CuentasBancarias cb ON t.cuenta_id = cb.cuenta_id
    JOIN Clientes c ON cb.cliente_id = c.cliente_id
WHERE 
    t.fecha_transaccion >= NOW() - (INTERVAL '30 DAY');

#3
CREATE VIEW clientes_multiples_sucursales AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT s.sucursal_id) AS sucursales_count
FROM 
    Clientes c
    JOIN CuentasBancarias cb ON c.cliente_id = cb.cliente_id
    JOIN Empleados e ON cb.sucursal_id = e.sucursal_id
    JOIN Sucursales s ON e.sucursal_id = s.sucursal_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
HAVING 
    COUNT(DISTINCT e.sucursal_id) > 1;

#4
CREATE VIEW transacciones_saldo_alto AS
SELECT 
    t.transaccion_id,
    t.cuenta_id,
    t.tipo_transaccion,
    t.monto,
    t.fecha_transaccion,
    t.descripcion
FROM 
    Transacciones t
    JOIN CuentasBancarias cb ON t.cuenta_id = cb.cuenta_id
WHERE 
    cb.saldo > 5000;

#5
CREATE VIEW prestamos_total_adeudado AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(p.monto * (1 + p.tasa_interes)) AS total_adeudado
FROM 
    Clientes c
    JOIN CuentasBancarias cb ON c.cliente_id = cb.cliente_id
    JOIN Prestamos p ON cb.cuenta_id = p.cuenta_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido;

#6
CREATE VIEW cuentas_alta_actividad AS
SELECT 
    t.cuenta_id,
    COUNT(t.transaccion_id) AS transacciones_count
FROM 
    Transacciones t
WHERE 
    t.fecha_transaccion >= NOW() - INTERVAL '1 MONTH'
GROUP BY 
    t.cuenta_id
HAVING 
    COUNT(t.transaccion_id) > 3;

#7
CREATE VIEW clientes_retiros_altos AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    SUM(t.monto) AS total_retiros
FROM 
    Transacciones t
    JOIN CuentasBancarias cb ON t.cuenta_id = cb.cuenta_id
    JOIN Clientes c ON cb.cliente_id = c.cliente_id
WHERE 
    t.tipo_transaccion = 'retiro' AND t.monto > 1000
GROUP BY 
    c.cliente_id, c.nombre, c.apellido;
    
#8
CREATE VIEW clientes_numero_sucursales AS
SELECT 
    s.sucursal_id,
    s.nombre AS sucursal_nombre,
    COUNT(DISTINCT c.cliente_id) AS numero_clientes
FROM 
    Sucursales s
    JOIN Empleados e ON s.sucursal_id = e.sucursal_id
    JOIN CuentasBancarias cb ON e.sucursal_id = cb.sucursal_id
    JOIN Clientes c ON cb.cliente_id = c.cliente_id
GROUP BY 
    s.sucursal_id, s.nombre;

#9
CREATE VIEW clientes_multiples_tipos_cuentas AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT cb.tipo_cuenta) AS tipos_cuentas_count
FROM 
    Clientes c
    JOIN CuentasBancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
HAVING 
    COUNT(DISTINCT cb.tipo_cuenta) > 1;

#10
CREATE VIEW prestamos_superiores_promedio AS
SELECT 
    p.préstamo_id,
    p.cuenta_id,
    p.monto,
    p.tasa_interes,
    p.fecha_inicio,
    p.fecha_fin,
    p.estado
FROM 
    Prestamos p
WHERE 
    p.monto > (SELECT AVG(monto) FROM Prestamos);