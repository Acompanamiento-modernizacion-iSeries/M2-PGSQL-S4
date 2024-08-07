-----------------------------------------------------------------------------------------------------------------
-- ** 1. Saldo total de cada cliente
-- ** Enunciado: Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Saldo_Total_Clientes AS
SELECT 
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    SUM(Cuentas_Bancarias.saldo) AS saldo_total
FROM 
    Clientes
JOIN 
    Cuentas_Bancarias ON Clientes.cliente_id = Cuentas_Bancarias.cliente_id
GROUP BY 
    Clientes.cliente_id, Clientes.nombre, Clientes.apellido;

--** Consulta:
SELECT * FROM Saldo_Total_Clientes;

-----------------------------------------------------------------------------------------------------------------
-- ** 2. Transacciones recientes de clientes
-- ** Enunciado: Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Transacciones_Recientes AS
SELECT 
    Transacciones.transaccion_id,
    Transacciones.cuenta_id,
    Transacciones.tipo_transaccion,
    Transacciones.monto,
    Transacciones.fecha_transaccion,
    Transacciones.descripcion,
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido
FROM 
    Transacciones
JOIN 
    Cuentas_Bancarias ON Transacciones.cuenta_id = Cuentas_Bancarias.cuenta_id
JOIN 
    Clientes ON Cuentas_Bancarias.cliente_id = Clientes.cliente_id
WHERE 
    Transacciones.fecha_transaccion >= NOW() - INTERVAL '30 days';

--** Consulta:
SELECT * FROM Transacciones_Recientes;


-----------------------------------------------------------------------------------------------------------------
-- ** 3. Clientes con cuentas en múltiples sucursales
-- ** Enunciado: Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Clientes_Multiples_Sucursales AS
SELECT 
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    COUNT(DISTINCT Cuentas_Bancarias.sucursal_id) AS numero_sucursales
FROM 
    Clientes
JOIN 
    Cuentas_Bancarias ON Clientes.cliente_id = Cuentas_Bancarias.cliente_id
GROUP BY 
    Clientes.cliente_id, Clientes.nombre, Clientes.apellido
HAVING 
    COUNT(DISTINCT Cuentas_Bancarias.sucursal_id) > 1;

--** Consulta:
SELECT * FROM Clientes_Multiples_Sucursales;

-----------------------------------------------------------------------------------------------------------------
-- ** 4. Transacciones de cuentas con saldo alto
-- ** Enunciado: Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Transacciones_Cuentas_Saldo_Alto AS
SELECT 
    Transacciones.transaccion_id,
    Transacciones.cuenta_id,
    Transacciones.tipo_transaccion,
    Transacciones.monto,
    Transacciones.fecha_transaccion,
    Transacciones.descripcion,
    Cuentas_Bancarias.saldo
FROM 
    Transacciones
JOIN 
    Cuentas_Bancarias ON Transacciones.cuenta_id = Cuentas_Bancarias.cuenta_id
WHERE 
    Cuentas_Bancarias.saldo > 5000;

--** Consulta:
SELECT * FROM Transacciones_Cuentas_Saldo_Alto;

-----------------------------------------------------------------------------------------------------------------
-- ** 5. Préstamos y total adeudado por cliente
-- ** Enunciado: Crear una vista que muestre los clientes con préstamos y el total adeudado.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Clientes_Prestamos_Total_Adeudado AS
SELECT 
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    SUM(Prestamos.monto) AS total_adeudado
FROM 
    Clientes
JOIN 
    Prestamos ON Clientes.cliente_id = prestamos.cliente_id
GROUP BY 
    Clientes.cliente_id, Clientes.nombre, Clientes.apellido
HAVING 
    SUM(Prestamos.monto) > 0;

--** Consulta:
SELECT * FROM Clientes_Prestamos_Total_Adeudado;

-----------------------------------------------------------------------------------------------------------------
--** 6. Cuentas con alta actividad reciente
--** Enunciado: Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Cuentas_Alta_Actividad AS
SELECT 
    cuenta_id,
    COUNT(transaccion_id) AS num_transacciones
FROM 
    Transacciones
WHERE 
    fecha_transaccion >= NOW() - INTERVAL '1 month'
GROUP BY 
    cuenta_id
HAVING 
    COUNT(transaccion_id) > 3;

--** Consulta:
select * from Cuentas_Alta_Actividad;

-----------------------------------------------------------------------------------------------------------------
-- ** 7. Clientes con retiros altos
-- ** Enunciado: Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Clientes_Retiros_Altos AS
SELECT 
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    Transacciones.monto AS monto_retiro
FROM 
    Transacciones
JOIN 
    Cuentas_Bancarias ON Transacciones.cuenta_id = Cuentas_Bancarias.cuenta_id
JOIN 
    Clientes ON Cuentas_Bancarias.cliente_id = Clientes.cliente_id
WHERE 
    Transacciones.tipo_transaccion = 'retiro' AND
    Transacciones.monto > 1000;

--** Consulta:
SELECT * FROM Clientes_Retiros_Altos;

-----------------------------------------------------------------------------------------------------------------
-- ** 8. Clientes y número de sucursales
-- ** Enunciado: Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Sucursales_Clientes AS
SELECT 
    Sucursales.sucursal_id,
    Sucursales.nombre AS nombre_sucursal,
    COUNT(Clientes.cliente_id) AS num_clientes
FROM 
    Sucursales
LEFT JOIN 
    Clientes ON Sucursales.sucursal_id = Clientes.sucursal_id
GROUP BY 
    Sucursales.sucursal_id, Sucursales.nombre;

--** Consulta:
select * from Sucursales_Clientes;

-----------------------------------------------------------------------------------------------------------------
-- ** 9. Clientes con múltiples tipos de cuentas
-- ** Enunciado: Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Clientes_Multiples_Cuentas AS
SELECT 
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    COUNT(DISTINCT Relacion_Clientes_Productos.producto_id) AS num_tipos_cuentas
FROM 
    Clientes
JOIN 
    Relacion_Clientes_Productos ON Clientes.cliente_id = Relacion_Clientes_Productos.cliente_id
GROUP BY 
    Clientes.cliente_id, Clientes.nombre, Clientes.apellido
HAVING 
    COUNT(DISTINCT Relacion_Clientes_Productos.producto_id) > 1;

--** Consulta:
select * from Clientes_Multiples_Cuentas

-----------------------------------------------------------------------------------------------------------------
-- ** 10. Préstamos superiores al promedio
-- ** Enunciado: Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.
-----------------------------------------------------------------------------------------------------------------
CREATE VIEW Prestamos_Superiores_Al_Promedio AS
SELECT *
FROM Prestamos
WHERE monto > (SELECT AVG(monto) FROM Prestamos);

--** Consulta:
select * from Prestamos_Superiores_Al_Promedio