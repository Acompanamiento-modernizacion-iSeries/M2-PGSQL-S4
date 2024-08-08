--1
CREATE VIEW saldo_total AS 
SELECT cl.cliente_id, cl.nombre AS cliente_nombre, SUM(ctab.saldo) AS saldo_total FROM clientes cl INNER JOIN clientes_cuentas ccta ON cl.cliente_id = ccta.cliente_id INNER JOIN cuentas_bancarias ctab ON ccta.cuenta_id = ctab.cuenta_id GROUP BY cl.cliente_id, cl.nombre;
SELECT * from saldo_total

SELECT * FROM Clientes_transacciones
SELECT * FROM transacciones
SELECT * FROM Clientes_cuentas
SELECT * FROM Cuentas_bancarias

--2
UPDATE transacciones SET fecha_transaccion = '2024-08-01' WHERE transaccion_id = 1
CREATE VIEW trx_ult30 AS SELECT cl.nombre, trx.tipo_transaccion, trx.monto, trx.fecha_transaccion FROM clientes cl INNER JOIN clientes_transacciones ct ON cl.cliente_id = ct.cliente_id INNER JOIN transacciones trx ON ct.transaccion_id = trx.transaccion_id WHERE trx.fecha_transaccion >= CURRENT_DATE - INTERVAL '30 days';
SELECT * FROM trx_ult30

--3 NO EXISTE UNA RELACIÓN ENTRE CLIENTE Y SUCURSAL

--4 
CREATE VIEW trx_saldo_mayor AS SELECT cta.numero_cuenta, trx.tipo_transaccion, trx.monto, trx.fecha_transaccion, cta.saldo FROM transacciones trx JOIN cuentas_bancarias cta ON trx.cuenta_id = cta.cuenta_id WHERE cta.saldo > 5000;
SELECT * FROM trx_saldo_mayor

--5
CREATE VIEW prestamos_total AS 
SELECT  cl.nombre, SUM(pr.monto) AS total_adeudado FROM clientes cl INNER JOIN clientes_prestamos cp ON cl.cliente_id = cp.cliente_id INNER JOIN prestamos pr ON cp.prestamo_id = pr.prestamo_id GROUP BY cl.cliente_id, cl.nombre;
SELECT * FROM prestamos_total

--6
INSERT INTO Transacciones (cuenta_id, tipo_transaccion, monto, fecha_transaccion, descripcion) VALUES
(1, 'depósito', 500.00, '2024-08-01 10:00:00', 'Depósito inicial'),
(1, 'retiro', 200.00, '2024-08-02 11:00:00', 'Retiro en efectivo'),
(1, 'transferencia', 300.00, '2024-08-03 12:00:00', 'Transferencia a otra cuenta')

CREATE VIEW cuentas_trx_ultimo_mes AS SELECT cb.cuenta_id, cb.numero_cuenta, COUNT(trx.transaccion_id) AS numero_transacciones FROM cuentas_bancarias cb INNER JOIN transacciones trx ON cb.cuenta_id = trx.cuenta_id WHERE trx.fecha_transaccion >= CURRENT_DATE - INTERVAL '1 month' GROUP BY cb.cuenta_id, cb.numero_cuenta HAVING COUNT(trx.transaccion_id) > 3;
SELECT * FROM cuentas_trx_ultimo_mes

--7
UPDATE Transacciones SET monto = 3000 WHERE monto = 200
CREATE VIEW retiros_mayores1000 AS SELECT cl.nombre AS cliente_nombre, trx.tipo_transaccion, trx.monto FROM clientes cl INNER JOIN clientes_transacciones ct ON cl.cliente_id = ct.cliente_id INNER JOIN transacciones trx ON ct.transaccion_id = trx.transaccion_id WHERE trx.tipo_transaccion = 'retiro' AND trx.monto > 1000;
SELECT * FROM retiros_mayores1000

--8

CREATE VIEW sucursales_clientes AS SELECT s.sucursal_id, s.nombre AS sucursal_nombre, COUNT(DISTINCT c.cliente_id) AS numero_de_clientes FROM sucursales s LEFT JOIN empleados e ON s.sucursal_id = e.sucursal_id LEFT JOIN cuentas_bancarias cb ON e.empleado_id = cb.cliente_id LEFT JOIN clientes c ON cb.cliente_id = c.cliente_id GROUP BY s.sucursal_id, s.nombre;
SELECT * FROM sucursales_clientes

--9
INSERT INTO Clientes_cuentas (cliente_id, cuenta_id, fecha_adquisicion) VALUES
(1, 2, '2024-08-01')
select cliente_id from Clientes_cuentas WHERE COUNT(cuenta_id) > 1 GROUP BY cliente_id

CREATE VIEW clientes_totalCta AS SELECT cl.cliente_id, cl.nombre AS cliente_nombre, COUNT(cta.tipo_cuenta) AS total_cuenta FROM clientes cl INNER JOIN clientes_cuentas cc ON cl.cliente_id = cc.cliente_id INNER JOIN cuentas_bancarias cta ON cc.cuenta_id = cta.cuenta_id GROUP BY cl.cliente_id, cl.nombre HAVING COUNT(cta.tipo_cuenta) > 1;
SELECT * FROM clientes_totalCta

--10 
select * from prestamos

CREATE VIEW prestamos_mayor_prom AS SELECT cuenta_id, monto FROM prestamos WHERE monto > (SELECT AVG(monto) FROM prestamos);
SELECT * FROM prestamos_mayor_prom