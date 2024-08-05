--Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.

CREATE VIEW VistaSaldoTotalClientes AS
SELECT C.cliente_id, C.nombre, SUM(CT.saldo) AS SaldoTotal
FROM Clientes C
JOIN Cuentas CT ON C.cliente_id = CT.cliente_id
GROUP BY C.cliente_id, C.nombre

--Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.

CREATE VIEW VistaTransaccionesUltimos30Dias AS
SELECT  T.transaccion_id, C.cliente_id, c.nombre, T.fecha_transaccion, T.monto
FROM  Transacciones T
JOIN  Clientes C ON T.cliente_id = C.cliente_id
WHERE T.fecha_transaccion >= DATEADD(DAY, -30, GETDATE())

--Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.

CREATE VIEW VistaClientesMultiSucursal AS
SELECT  C.cliente_id, C.nombre, COUNT(DISTINCT CT.sucursal_id) AS NumeroSucursales
FROM Clientes C
JOIN Cuentas CT ON C.clienteID = CT.cliente_id
GROUP BY C.cliente_id, C.nombre
HAVING  COUNT(DISTINCT CT.sucursal_id) > 1

--Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000
CREATE VIEW VistaTransaccionesCuentasSaldoMayor5000 AS
SELECT T.transaccion_id, T.cuenta_id, T.fecha_transaccion, T.monto, C.cliente_id, C.nombre
FROM Transacciones T
JOIN Cuentas CT ON T.cuenta_id = CT.cuenta_id
JOIN Clientes C ON CT.cliente_id = C.cliente_id
WHERE CT.saldo > 5000

-- Crear una vista que muestre los clientes con préstamos y el total adeudado.

CREATE VIEW VistaClientesConPrestamos AS
SELECT  PT.prestamo_id, C.cliente_id, C.nombre, SUM(PT.monto) AS TotalAdeudado
FROM Clientes C
JOIN Cuentas CU ON C.cliente_id = CU.cliente_id
JOIN Prestamos PT ON CU.cuenta_id = PT.cuenta_id
GROUP BY PT.prestamo_id, C.cliente_id, C.nombre 

--Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.

CREATE VIEW VistaCuentasConMasDe3TransaccionesUltimoMes AS
SELECT CT.cuenta_id, COUNT(T.transaccion_id) AS NumeroTransacciones
FROM Cuentas CT
JOIN Transacciones T ON CT.cuenta_id = T.cuenta_id
WHERE T.fecha_transaccion >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
GROUP BY CT.cuenta_id
HAVING COUNT(T.transaccion_id) > 3


--Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.

CREATE VIEW VistaClientesConRetirosMayoresA1000 AS
SELECT C.cliente_id,C.nombre, T.transaccion_id, T.cuenta_id,T.fecha_transaccion, T.Monto
FROM Clientes C
JOIN Cuentas CT ON C.cliente_id = CT.cliente_id
JOIN Transacciones T ON CT.cuenta_id = T.cuenta_id
WHERE T.tipo_transaccion = 'retiro' AND T.monto > 1000


-- Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.

CREATE VIEW VistaSucursalesConNumeroDeClientes AS
SELECT S.sucursal_id, S.nombre, COUNT(DISTINCT C.cliente_id) AS NumeroClientes
FROM Sucursales S
JOIN Cuentas CT ON S.sucursal_id = CT.sucursal_id
JOIN Clientes C ON CT.cliente_id = C.cliente_id
GROUP BY S.sucursal_id, S.nombre


--Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.

CREATE VIEW VistaClientesConMasDeUnTipoDeCuenta AS
SELECT C.cliente_id, C.nombre, COUNT(DISTINCT CT.tipo_cuenta) AS NumeroTiposDeCuenta
FROM Clientes C
JOIN Cuentas CT ON C.cliente_id = CT.cliente_id
GROUP BY C.cliente_id, C.nombre
HAVING COUNT(DISTINCT CT.tipo_cuenta) > 1

--Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.

CREATE VIEW VistaPrestamosSuperanPromedio AS
SELECT P.prestamo_id, P.monto
FROM Prestamos P
WHERE P.monto > (SELECT AVG(monto) FROM prestamos);

