-----------------------------------------------------------------------
--TALLER 4
--SCRIPT CREADO POR: JUAN PABLO VALDERRAMA PELÁEZ
--CREACIÓN DE VISTAS SOBRE BASE DE DATOS SISTEMA BANCARIO 
------------------------------------------------------------------------
--1.Crear una vista que muestre el saldo total de cada cliente en todas 
--  sus cuentas.
------------------------------------------------------------------------

CREATE VIEW Saldo_Clientes AS
SELECT C.cliente_id, C.nombre, C.apellido, SUM(CB.saldo) AS saldo_total
FROM Clientes C
JOIN Cuentas_Bancarias CB ON C.cliente_id = CB.cliente_id
GROUP BY C.cliente_id, C.nombre, C.apellido;
	
------------------------------------------------------------------------
--2.Crear una vista que muestre las transacciones realizadas por los 
--  clientes en los últimos 30 días.
------------------------------------------------------------------------

CREATE VIEW Transacciones_Recientes AS
SELECT transaccion_id, cuenta_id, nombre, monto, fecha_transaccion, 
descripcion
FROM Transacciones
JOIN Tipo_transaccion ON tipo_transaccion = tipo_id
WHERE fecha_transaccion >= NOW() - INTERVAL '30 days';

------------------------------------------------------------------------
--3.Crear una vista que muestre los clientes que tienen cuentas en más 
-- de una sucursal.
------------------------------------------------------------------------

CREATE VIEW Clientes_Sucursales AS
SELECT C.cliente_id, C.nombre, C.apellido, 
COUNT(DISTINCT S.sucursal_id) AS sucursales
FROM Clientes C
JOIN Cuentas_Bancarias CB ON C.cliente_id = CB.cliente_id
JOIN Sucursales S ON CB.sucursal_id = S.sucursal_id
GROUP BY C.cliente_id, C.nombre, C.apellido
HAVING COUNT(DISTINCT E.sucursal_id) > 1;

------------------------------------------------------------------------
--4.Crear una vista que muestre las transacciones de cuentas con saldo 
--  mayor a 5000.
------------------------------------------------------------------------

CREATE VIEW Transacciones_Cuentas_Saldo_Mayor_5000 AS
SELECT transaccion_id, T.cuenta_id, nombre, monto,
fecha_transaccion, descripcion
FROM Transacciones T
JOIN Cuentas_Bancarias CB ON T.cuenta_id = CB.cuenta_id
JOIN Tipo_transaccion ON tipo_transaccion = tipo_id
WHERE CB.saldo > 5000;

------------------------------------------------------------------------
--5.Crear una vista que muestre los clientes con préstamos y el 
-- total adeudado.
------------------------------------------------------------------------

CREATE VIEW Prestamos_Total_X_Cliente AS
SELECT C.cliente_id, nombre, apellido,
SUM(p.monto) AS total_adeudado
FROM Clientes C
JOIN Cuentas_Bancarias CB ON C.cliente_id = CB.cliente_id
JOIN Prestamos P ON CB.cuenta_id = P.cuenta_id
GROUP BY C.cliente_id, nombre, apellido;

------------------------------------------------------------------------
--6.Crear una vista que muestre las cuentas que han realizado más de 3 
--  transacciones en el último mes.
------------------------------------------------------------------------

CREATE VIEW Cuentas_Mas_de_3_Transacciones AS
SELECT cuenta_id, COUNT(T.transaccion_id) AS num_transacciones
FROM Transacciones T
WHERE T.fecha_transaccion >= NOW() - INTERVAL '30 days'
GROUP BY T.cuenta_id
HAVING COUNT(T.transaccion_id) > 3;

------------------------------------------------------------------------
--7.Crear una vista que muestre los clientes que han realizado retiros
--  mayores a 1000.
------------------------------------------------------------------------

CREATE VIEW Clientes_Retiros_Mayor_1000 AS
SELECT C.cliente_id, C.nombre, apellido, monto, fecha_transaccion
FROM Clientes C
JOIN Cuentas_Bancarias CB ON C.cliente_id = CB.cliente_id
JOIN Transacciones T ON CB.cuenta_id = T.cuenta_id
JOIN Tipo_Transaccion TT ON T.tipo_transaccion = TT.tipo_id
WHERE TT.tipo_id = 2 AND T.monto > 1000;

------------------------------------------------------------------------
--8.Crear una vista que muestre las sucursales y el número de clientes 
-- asociados a cada una.
------------------------------------------------------------------------

CREATE VIEW Sucursales_Numero_Clientes AS
SELECT S.sucursal_id, S.nombre AS sucursal_nombre,
COUNT(DISTINCT c.cliente_id) AS num_clientes
FROM Sucursales S
JOIN Cuentas_Bancarias CB ON S.sucursal_id = CB.sucursal_id
JOIN Clientes C ON CB.cliente_id = C.cliente_id
GROUP BY S.sucursal_id, S.nombre;


------------------------------------------------------------------------
--9.Crear una vista que muestre los clientes que tienen más de un tipo
--  de cuenta.
------------------------------------------------------------------------

CREATE VIEW Clientes_Varias_Cuentas AS
SELECT C.cliente_id, nombre, apellido,
COUNT(DISTINCT CB.tipo_cuenta) AS tipos_cuentas
FROM Clientes C
JOIN Cuentas_Bancarias CB ON C.cliente_id = CB.cliente_id
GROUP BY C.cliente_id, nombre, apellido
HAVING COUNT(DISTINCT CB.tipo_cuenta) > 1;

------------------------------------------------------------------------
--10.Crear una vista que muestre los préstamos que superan el promedio 
-- de todos los préstamos.
------------------------------------------------------------------------

CREATE VIEW Prestamos_Mayor_al_Promedio AS
SELECT prestamo_id, cuenta_id, monto, tasa_interes,
fecha_inicio, fecha_fin, estado
FROM Prestamos 
WHERE monto > (SELECT AVG(monto) FROM Prestamos);
