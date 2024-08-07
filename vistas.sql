--- 1. Saldo total de cada cliente
---Enunciado:--- Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.
CREATE VIEW saldo_total_clientes AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    COALESCE(SUM(cb.saldo), 0) as saldo_total
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
ORDER BY c.cliente_id;

--- 2. Transacciones recientes de clientes
---Enunciado:--- Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.
CREATE VIEW transacciones_ultimos_30_dias AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    cb.numero_cuenta,
    t.transaccion_id,
    t.tipo_transaccion,
    t.monto,
    t.fecha_transaccion,
    t.descripcion
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN 
    transacciones t ON cb.cuenta_id = t.cuenta_id
WHERE 
    t.fecha_transaccion >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY 
    t.fecha_transaccion DESC;

--- 3. Clientes con cuentas en múltiples sucursales
---Enunciado:--- Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.
---Como no cree una relacion de cuentas sucursal trate asumir que hay una relación entre cuentas_bancarias y empleados a través del campo cuenta_id, que podría representar al empleado que abrió o maneja la cuenta.
CREATE VIEW clientes_multisucursal AS
SELECT 
    c.cliente_id, 
    c.nombre, 
    c.apellido, 
    COUNT(DISTINCT e.sucursal_id) AS num_sucursales
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN 
    empleados e ON cb.cuenta_id = e.empleado_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
HAVING 
    COUNT(DISTINCT e.sucursal_id) > 1
ORDER BY 
    num_sucursales DESC, c.apellido, c.nombre;

--- 4. Transacciones de cuentas con saldo alto
---Enunciado:--- CREATE VIEW transacciones_cuentas_saldo_alto AS
SELECT 
    cb.cuenta_id,
    cb.numero_cuenta,
    cb.saldo,
    t.transaccion_id,
    t.tipo_transaccion,
    t.monto,
    t.fecha_transaccion,
    t.descripcion,
    c.cliente_id,
    c.nombre,
    c.apellido
FROM 
    cuentas_bancarias cb
JOIN 
    transacciones t ON cb.cuenta_id = t.cuenta_id
JOIN 
    clientes c ON cb.cliente_id = c.cliente_id
WHERE 
    cb.saldo > 1500000
ORDER BY 
    cb.saldo DESC, t.fecha_transaccion DESC;

--- 5. Préstamos y total adeudado por cliente
---Enunciado:--- Crear una vista que muestre los clientes con préstamos y el total adeudado.
CREATE VIEW clientes_con_prestamos AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(p.prestamo_id) AS numero_prestamos,
    SUM(p.monto) AS total_prestamos    
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN 
    prestamos p ON cb.cuenta_id = p.cuenta_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
ORDER BY 
    total_prestamos DESC;

--- 6. Cuentas con alta actividad reciente
---Enunciado:--- Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
CREATE VIEW cuentas_activas_ultimo_mes AS
SELECT 
    cb.cuenta_id,
    cb.numero_cuenta,
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(t.transaccion_id) AS num_transacciones,
    SUM(t.monto) AS total_trans    
FROM 
    cuentas_bancarias cb
JOIN 
    clientes c ON cb.cliente_id = c.cliente_id
JOIN 
    transacciones t ON cb.cuenta_id = t.cuenta_id
WHERE 
    t.fecha_transaccion >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY 
    cb.cuenta_id, cb.numero_cuenta, c.cliente_id, c.nombre, c.apellido
HAVING 
    COUNT(t.transaccion_id) > 3
ORDER BY 
    num_transacciones DESC;
        
--- 7. Clientes con retiros altos
---Enunciado:--- Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.
CREATE VIEW clientes_retiros_grandes AS
SELECT DISTINCT
    c.cliente_id,
    c.nombre,
    c.apellido,
    cb.numero_cuenta,
    t.transaccion_id,
    t.monto,
    t.fecha_transaccion
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
JOIN 
    transacciones t ON cb.cuenta_id = t.cuenta_id
WHERE     
    t.monto > 1000
ORDER BY 
    t.monto DESC, t.fecha_transaccion DESC;

--- 8. Clientes y número de sucursales
---Enunciado:--- Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.

Esta vista no la pude realizar debido a como diseñer el modelor ER :( 
    
--- 9. Clientes con múltiples tipos de cuentas
---Enunciado:--- Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.
CREATE VIEW clientes_multi_cuentas AS
SELECT 
    c.cliente_id,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT cb.tipo_cuenta) AS numero_tipos_cuenta
FROM 
    clientes c
JOIN 
    cuentas_bancarias cb ON c.cliente_id = cb.cliente_id
GROUP BY 
    c.cliente_id, c.nombre, c.apellido
HAVING 
    COUNT(DISTINCT cb.tipo_cuenta) > 1
ORDER BY 
    numero_tipos_cuenta DESC, c.apellido, c.nombre;

--- 10. Préstamos superiores al promedio
---Enunciado:--- Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.
CREATE VIEW prestamos_sobre_promedio AS
WITH promedio_prestamos AS (
    SELECT AVG(monto) AS monto_promedio
    FROM prestamos    
)
SELECT 
    cl.nombre AS nombre_cliente,
    cl.apellido AS apellido_cliente,
    p.monto,
    (SELECT monto_promedio FROM promedio_prestamos) AS promedio_general
FROM 
    prestamos p
JOIN 
    cuentas_bancarias c ON p.cuenta_id = c.cuenta_id
JOIN 
    clientes cl ON c.cliente_id = cl.cliente_id
WHERE 
    p.monto > (SELECT monto_promedio FROM promedio_prestamos)    
ORDER BY 
    p.monto DESC;