--1. Saldo total de cada cliente
--Enunciado: Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.
CREATE VIEW saldo_total_clientes AS
SELECT C.cliente_id, nombre, apellido, SUM (saldo) AS saldo_total
FROM clientes C
JOIN cuentas_bancarias B ON C.cliente_id = B.cliente_id
GROUP BY C.cliente_id, nombre, apellido;

--2. Transacciones recientes de clientes
--Enunciado: Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.
CREATE VIEW Ultimas_Transacciones_clientes AS
SELECT nombre, apellido, tipo_transaccion, monto, fecha_transaccion
FROM clientes C
JOIN cuentas_bancarias B ON C.cliente_id = B.cliente_id
JOIN transacciones T ON B.cuenta_id = T.cuenta_id
WHERE fecha_transaccion >= NOW() - INTERVAL '30 days';

--3. Clientes con cuentas en múltiples sucursales
--Enunciado: Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.
--NO EXISTE LA REACION CON SUCURSAL EN BD PERO SERIA ASI
CREATE VIEW Clientes_cuentas_multiples_sucursales AS
SELECT C.cliente_id, C.nombre, C.apellido, COUNT(C.cliente_id) AS cantidad_sucursales 
FROM clientes C
JOIN cuentas_bancarias B ON B.cliente_id = C.cliente_id
JOIN sucursales S ON S.sucursal_id = B.cuenta_id
GROUP BY C.cliente_id, C.nombre, C.apellido HAVING COUNT(C.cliente_id) > 1; 

--4. Transacciones de cuentas con saldo alto
--Enunciado: Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.
CREATE VIEW Transacciones_saldo_alto_5000 AS
SELECT numero_cuenta, tipo_transaccion, monto, fecha_transaccion
FROM cuentas_bancarias B
JOIN transacciones T ON B.cuenta_id = T.cuenta_id
WHERE T.monto > '5000'
ORDER BY numero_cuenta;

--5. Préstamos y total adeudado por cliente
--Enunciado: Crear una vista que muestre los clientes con préstamos y el total adeudado.
CREATE VIEW pestamos_clientes_total_adedudado AS
SELECT C.cliente_id, C.nombre, C.apellido, SUM(monto) AS total_adeudado  
FROM clientes C
JOIN cuentas_bancarias B ON B.cliente_id = C.cliente_id
JOIN prestamos P ON P.cuenta_id = B.cuenta_id
GROUP BY C.cliente_id, C.nombre, C.apellido;

--6. Cuentas con alta actividad reciente
--Enunciado: Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
CREATE VIEW cuentas_reciente_alta_actividad AS
SELECT B.cuenta_id, B.numero_cuenta, COUNT(T.cuenta_id) AS numero_transacciones 
FROM cuentas_bancarias B 
JOIN transacciones T ON B.cuenta_id = T.cuenta_id
WHERE fecha_transaccion >= NOW() - INTERVAL '1 month'
group by B.cuenta_id, B.numero_cuenta HAVING COUNT(T.cuenta_id) > 3;

--7. Clientes con retiros altos
--Enunciado: Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.
CREATE VIEW Clientes_retiros_altos_1000 AS 
SELECT C.cliente_id, C.nombre, C.apellido, T.monto  
FROM clientes C
JOIN cuentas_bancarias B ON C.cliente_id = B.cliente_id
JOIN transacciones T ON B.cuenta_id = T.cuenta_id
WHERE T.tipo_transaccion = 'retiro' and T.monto > '1000'
GROUP BY C.cliente_id, C.nombre, C.apellido, T.monto;

--8. Clientes y número de sucursales
--Enunciado: Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.
--NO EXISTE LA REACION CON SUCURSAL EN BD PERO SERIA ASI
CREATE VIEW numero_clientes_por_sucursal AS
SELECT S.sucursal_id, S.nombre AS sucursal_nombre, COUNT(C.cliente_id) AS numero_clientes
FROM sucursales S
JOIN suentas_sancarias B ON S.sucursal_id = B.sucursal_id
JOIN clientes C ON B.cliente_id = C.cliente_id
GROUP BY S.sucursal_id, S.nombre;

--9. Clientes con múltiples tipos de cuentas
--Enunciado: Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.
CREATE VIEW clientes_multiples_tipos_cuentas AS
SELECT C.cliente_id, C.nombre, C.apellido, COUNT(*) AS cant_cuentas 
FROM clientes C
JOIN cuentas_bancarias B ON B.cliente_id = C.cliente_id
GROUP BY C.cliente_id, C.nombre, C.apellido HAVING COUNT(*) > 1;

--10. Préstamos superiores al promedio
--Enunciado: Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.
CREATE VIEW prestamos_superiores_promedio AS
SELECT prestamo_id, cuenta_id, monto, tasa_interes,fecha_inicio, fecha_fin, estado
FROM prestamos 
WHERE monto > ( SELECT SUM(monto)/COUNT(prestamo_id) AS promedio FROM prestamos);