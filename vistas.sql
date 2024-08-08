-- Taller nro 4, CAMILO ANDRES GARCIA CRUZ
-- Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.
CREATE VIEW SaldoTotalClientes AS
SELECT
    Clientes.cliente_id,
    Clientes.nombre,
    SUM(CuentasBancarias.saldo) AS saldo_total
FROM
    Clientes
JOIN
    CuentasBancarias ON Clientes.cliente_id = CuentasBancarias.cliente_id
GROUP BY
    Clientes.cliente_id,
    Clientes.nombre;
	
	
-- Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.
CREATE VIEW TransaccionesUltimos30Dias AS
SELECT
    Transacciones.transaccion_id,
    Transacciones.fecha_transaccion,
    Transacciones.monto,
    Clientes.cliente_id,
    Clientes.nombre,
    CuentasBancarias.cuenta_id
FROM
    Transacciones
JOIN
    CuentasBancarias ON Transacciones.cuenta_id = CuentasBancarias.cuenta_id
JOIN
    Clientes ON CuentasBancarias.cliente_id = Clientes.cliente_id
WHERE
    Transacciones.fecha_transaccion >= CURRENT_DATE - INTERVAL '30' DAY;
	
-- Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.
CREATE VIEW ClientesConCuentasEnMultiplesSucursales AS
SELECT
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido
FROM
    Clientes
JOIN
    CuentasBancarias ON Clientes.cliente_id = CuentasBancarias.cliente_id
GROUP BY
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido
HAVING
    COUNT(DISTINCT CuentasBancarias.cuenta_id) > 1;
	
-- Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.
CREATE VIEW TransaccionesCuentasSaldoMayor5000 AS
SELECT
    Transacciones.transaccion_id,
    Transacciones.fecha_transaccion,
    Transacciones.monto,
    CuentasBancarias.cuenta_id,
    CuentasBancarias.saldo
FROM
    Transacciones
JOIN
    CuentasBancarias ON Transacciones.cuenta_id = CuentasBancarias.cuenta_id
WHERE
    CuentasBancarias.saldo > 5000;
	
-- Crear una vista que muestre los clientes con préstamos y el total adeudado.
CREATE VIEW ClientesConPrestamosYTotalAdeudado AS
SELECT
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    SUM(Prestamos.monto) AS total_adeudado
FROM
    Clientes
JOIN
    CuentasBancarias ON Clientes.cliente_id = CuentasBancarias.cliente_id
JOIN
    Prestamos ON CuentasBancarias.cuenta_id = Prestamos.cuenta_id
GROUP BY
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido;
	
-- Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
CREATE VIEW CuentasConMasDeTresTransaccionesUltimoMes AS
SELECT
    CuentasBancarias.cuenta_id,
    CuentasBancarias.numero_cuenta,
    CuentasBancarias.cliente_id,
    CuentasBancarias.saldo
FROM
    CuentasBancarias
JOIN
    Transacciones ON CuentasBancarias.cuenta_id = Transacciones.cuenta_id
WHERE
    Transacciones.fecha_transaccion >= NOW() - INTERVAL '1 month'
GROUP BY
    CuentasBancarias.cuenta_id,
    CuentasBancarias.numero_cuenta,
    CuentasBancarias.cliente_id,
    CuentasBancarias.saldo
HAVING
    COUNT(Transacciones.transaccion_id) > 3;
	
-- Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.
CREATE VIEW ClientesConRetirosMayoresA1000 AS
SELECT
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    Transacciones.transaccion_id,
    Transacciones.monto,
    Transacciones.fecha_transaccion
FROM
    Clientes
JOIN
    CuentasBancarias ON Clientes.cliente_id = CuentasBancarias.cliente_id
JOIN
    Transacciones ON CuentasBancarias.cuenta_id = Transacciones.cuenta_id
WHERE
    Transacciones.tipo_transaccion = 'retiro' AND
    Transacciones.monto > 1000;
	
-- Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.
CREATE VIEW SucursalesConNumeroDeClientes AS
SELECT
    Sucursales.sucursal_id,
    Sucursales.nombre_sucursal,
    COUNT(Clientes.cliente_id) AS numero_de_clientes
FROM
    Sucursales
JOIN
    CuentasBancarias ON Sucursales.sucursal_id = CuentasBancarias.sucursal_id
JOIN
    Clientes ON CuentasBancarias.cliente_id = Clientes.cliente_id
GROUP BY
    Sucursales.sucursal_id,
    Sucursales.nombre_sucursal;

-- Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.
CREATE VIEW ClientesConMasDeUnTipoDeCuenta AS
SELECT
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido,
    COUNT(DISTINCT CuentasBancarias.tipo_cuenta) AS numero_de_tipos_de_cuenta
FROM
    Clientes
JOIN
    CuentasBancarias ON Clientes.cliente_id = CuentasBancarias.cliente_id
GROUP BY
    Clientes.cliente_id,
    Clientes.nombre,
    Clientes.apellido
HAVING
    COUNT(DISTINCT CuentasBancarias.tipo_cuenta) > 1;

-- Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.
CREATE VIEW PrestamosSuperanPromedio AS
SELECT
    Prestamos.prestamo_id,
    Prestamos.cuenta_id,
    Prestamos.monto,
    Prestamos.fecha_inicio
FROM
    Prestamos
WHERE
    Prestamos.monto > (SELECT AVG(monto) FROM Prestamos);
	