CREATE VIEW Saldo_Total_Clientes AS SELECT 
    c.cliente_id,    c.nombre,    c.apellido,    SUM(cb.saldo) AS saldo_total FROM 
    clientes c JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido;
 
CREATE VIEW Transacciones_Recientes_Clientes AS SELECT 
    t.transaccion_id,    t.cuenta_id,    t.tipo_transaccion,    t.monto,    
	t.fecha_transaccion,    t.descripcion FROM 
    transacciones t
WHERE 
    t.fecha_transaccion >= NOW() - INTERVAL '30 days';
 
CREATE VIEW Clientes_Multiples_Sucursales AS SELECT 
    c.cliente_id,    c.nombre,    c.apellido,    COUNT(DISTINCT e.sucursal_id) AS sucursales FROM 
    clientes c JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id JOIN 
    empleados e ON cb.cliente_id = e.empleado_id GROUP BY 
    c.cliente_id, c.nombre, c.apellido
     HAVING COUNT(DISTINCT e.sucursal_id) > 1;
 
CREATE VIEW Transacciones_Cuentas_Saldo_Alto AS SELECT 
    t.transaccion_id,    t.cuenta_id,    t.tipo_transaccion,    
	t.monto,    t.fecha_transaccion,    t.descripcion FROM 
    transacciones t JOIN 
    cuentas_Bancarias cb ON t.cuenta_id = cb.cuenta_id
WHERE 
    cb.saldo > 5000;
 
CREATE VIEW Prestamos_Total_Adeudado AS SELECT 
    c.cliente_id,    c.nombre,    c.apellido,    SUM(p.monto) AS total_adeudado 
	FROM 
    clientes c JOIN 
    cuentas_Bancarias cb ON c.cliente_id = cb.cliente_id
JOIN 
    prestamos p ON cb.cuenta_id = p.cuenta_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido;
 
CREATE VIEW Cuentas_Alta_Actividad_Reciente AS SELECT 
    t.cuenta_id,    COUNT(t.transaccion_id) AS num_transacciones FROM 
    transacciones t WHERE 
    t.fecha_transaccion >= NOW() - INTERVAL '30 days' 
	GROUP BY t.cuenta_id 
	HAVING COUNT(t.transaccion_id) > 3;
 
CREATE VIEW Clientes_Retiros_Altos AS SELECT 
    c.cliente_id,    c.nombre,    c.apellido,    t.monto,    t.fecha_transaccionFROM 
    clientes c JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id JOIN 
    transacciones t ON cb.cuenta_id = t.cuenta_idJOIN 
    
WHERE 
    t.tipo_transaccion = 'Retiro' AND t.monto > 1000;
 
CREATE VIEW Sucursales_Numero_Clientes AS SELECT 
    s.sucursal_id,    s.nombre AS sucursal_nombre,
    COUNT(DISTINCT c.cliente_id) AS num_clientes FROM 
    sucursales s JOIN 
    empleados e ON s.sucursal_id = e.sucursal_id JOIN 
    cuentas_bancarias cb ON e.empleado_id = cb.cliente_id
JOIN 
    clientes c ON cb.cliente_id = c.cliente_id
GROUP BY 
    s.sucursal_id, s.nombre;
 
CREATE VIEW Clientes_Multiples_Tipos_Cuentas AS SELECT 
    c.cliente_id,    c.nombre,    c.apellido,    COUNT(DISTINCT cb.tipo_cuenta) AS tipos_cuentas
	FROM 
    clientes c JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
	GROUP BY 
    c.cliente_id, c.nombre, c.apellido
HAVING COUNT(DISTINCT cb.tipo_cuenta) > 1;
 
CREATE VIEW Prestamos_Superiores_Promedio ASSELECT 
    p.prestamo_id,    p.cuenta_id,    p.monto,    p.tasa_interes,    p.fecha_inicio,    p.fecha_fin,    p.estadoFROM 
    Prestamos p
WHERE 
    p.monto > (SELECT AVG(monto) FROM Prestamos);