
--1.Crear una vista que muestre el saldo total de cada 
--cliente en todas sus cuentas.

CREATE OR REPLACE VIEW SaldoClientes AS
SELECT A.cliente_id, A.nombre, A.apellido, SUM(B.saldo) saldo_total
FROM Clientes A
JOIN CuentasBancarias B ON A.cliente_id = B.cliente_id
GROUP BY A.cliente_id, A.nombre, A.apellido;
	

--2.Crear una vista que muestre las transacciones realizadas por 
--los clientes en los últimos 30 días.


CREATE OR REPLACE VIEW TransaccionesRecientes AS
SELECT transaccion_id, cuenta_id, nombre, monto, fecha_transaccion, 
descripcion
FROM Transacciones
INNER JOIN Tipo_transaccion  ON tipo_transaccion = tipo_id
WHERE fecha_transaccion >= NOW() - INTERVAL '30 days';

--3.Crear una vista que muestre los clientes que tienen 
--cuentas en más de una sucursal.

CREATE OR REPLACE VIEW ClientesSucursales AS
SELECT A.cliente_id, A.nombre, A.apellido, 
COUNT(DISTINCT C.sucursal_id) AS sucursales
FROM Clientes A
JOIN CuentasBancarias B ON A.cliente_id = B.cliente_id
JOIN Sucursales C ON c.sucursal_id = C.sucursal_id
GROUP BY A.cliente_id, A.nombre, A.apellido
HAVING COUNT(DISTINCT C.sucursal_id) > 1;

--4.Crear una vista que muestre las transacciones de cuentas 
--con saldo mayor a 5000.

CREATE OR REPLACE VIEW TransaccionesCuentasSaldoMayor AS
SELECT transaccion_id, A.cuenta_id, nombre, monto,
fecha_transaccion, descripcion
FROM Transacciones A
JOIN CuentasBancarias B ON A.cuenta_id = B.cuenta_id
JOIN Tipotransaccion ON tipo_transaccion = tipo_id
WHERE B.saldo > 5000;


--5.Crear una vista que muestre los clientes con préstamos y el 
--total adeudado.

CREATE OR REPLACE VIEW PrestamosTotalXCliente AS
SELECT A.cliente_id, nombre, apellido,
SUM(C.monto) AS total_adeudado
FROM Clientes A
JOIN CuentasBancarias B ON A.cliente_id = B.cliente_id
JOIN Prestamos C ON B.cuenta_id = C.cuenta_id
GROUP BY A.cliente_id, nombre, apellido;


--6.Crear una vista que muestre las cuentas que han 
--realizado más de 3 transacciones en el último mes.

CREATE OR REPLACE VIEW CuentasMasde3Transacciones AS
SELECT cuenta_id, COUNT(A.transaccion_id) AS num_transacciones
FROM Transacciones A
WHERE A.fecha_transaccion >= NOW() - INTERVAL '30 days'
GROUP BY A.cuenta_id
HAVING COUNT(A.transaccion_id) > 3;


--7.Crear una vista que muestre los clientes que han 
--realizado retiros mayores a 1000.

CREATE OR REPLACE VIEW ClientesRetirosMayor AS
SELECT A.cliente_id, A.nombre, apellido, monto, fecha_transaccion
FROM Clientes A
JOIN CuentasBancarias B ON A.cliente_id = B.cliente_id
JOIN Transacciones C ON B.cuenta_id = C.cuenta_id
JOIN TipoTransaccion D ON C.tipo_transaccion = D.tipo_id
WHERE D.tipo_id = 2 AND C.monto > 1000;


--8.Crear una vista que muestre las sucursales y el número
--de clientes asociados a cada una.

CREATE OR REPLACE VIEW SucursalesNumeroClientes AS
SELECT A.sucursal_id, A.nombre AS sucursal_nombre,
COUNT(DISTINCT c.cliente_id) AS num_clientes
FROM Sucursales A
JOIN CuentasBancarias B ON A.sucursal_id = B.sucursal_id
JOIN Clientes C ON B.cliente_id = C.cliente_id
GROUP BY A.sucursal_id, A.nombre;



--9.Crear una vista que muestre los clientes que tienen más 
--de un tipo de cuenta.

CREATE OR REPLACE VIEW ClientesCuentas AS
SELECT A.cliente_id, nombre, apellido,
COUNT(DISTINCT B.tipo_cuenta) AS tipos_cuentas
FROM Clientes A
JOIN CuentasBancarias B ON A.cliente_id = B.cliente_id
GROUP BY A.cliente_id, nombre, apellido
HAVING COUNT(DISTINCT B.tipo_cuenta) > 1;


--10.Crear una vista que muestre los préstamos que superan 
--el promedio de todos los préstamos.

CREATE OR REPLACE VIEW PrestamosMayorPromedio AS
SELECT prestamo_id, cuenta_id, monto, tasa_interes,
fecha_inicio, fecha_fin, estado
FROM Prestamos 
WHERE monto > (SELECT AVG(monto) FROM Prestamos);