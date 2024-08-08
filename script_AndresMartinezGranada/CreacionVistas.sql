--1. Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.
CREATE VIEW saldo_total AS 
  SELECT CL.cliente_id, CL.nombre, CL.apellido, SUM(CB.saldo) AS saldo_total
    FROM clientes CL
    JOIN cuentas_bancarias CB ON CB.cliente_id = CL.cliente_id
    GROUP BY CL.cliente_id, CL.nombre, CL.apellido;

SELECT * FROM saldo_total;

--2. Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.
CREATE VIEW transacciones_30_dias AS 
  SELECT CL.cliente_id, CL.nombre, CL.apellido, CB.numero_cuenta, TR.descripcion, TR.monto, TR.fecha_transaccion
    FROM clientes CL
    JOIN cuentas_bancarias CB ON CB.cliente_id = CL.cliente_id
    JOIN transacciones TR ON TR.cuenta_id = CB.cuenta_id
    WHERE TR.fecha_transaccion >= CURRENT_TIMESTAMP - INTERVAL '30 days';

SELECT * FROM transacciones_30_dias;

--*. Adicionar campo sucursal_id a Tabla cuentas_bancarias.
ALTER TABLE cuentas_bancarias 
  ADD COLUMN sucursal_id INT REFERENCES sucursales (sucursal_id);

--3. Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.
CREATE VIEW multiples_cuentas AS 
  SELECT CL.cliente_id, CL.nombre, CL.apellido, COUNT(DISTINCT CB.sucursal_id) AS numero_sucursales
    FROM clientes CL
    JOIN cuentas_bancarias CB ON CB.cliente_id = CL.cliente_id 
	GROUP BY CL.cliente_id, CL.nombre, CL.apellido
	HAVING COUNT(DISTINCT CB.sucursal_id) > 1;

SELECT * FROM multiples_cuentas;

--4. Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.
CREATE VIEW transac_cuentas_mayor5000 AS 
  SELECT CB.cuenta_id, CB.numero_cuenta, CB.saldo, TR.monto, TR.descripcion
    FROM cuentas_bancarias CB
	JOIN transacciones TR ON TR.cuenta_id = CB.cuenta_id
    WHERE CB.saldo > 5000;

SELECT * FROM transac_cuentas_mayor5000;
  
--5. Crear una vista que muestre los clientes con préstamos y el total adeudado.
CREATE VIEW deuda_clientes AS 
  SELECT CL.cliente_id, CL.nombre, CL.apellido, COUNT(PR.prestamo_id) AS numero_prestamos, SUM(PR.monto) AS total_adeudado
    FROM clientes CL
	JOIN cuentas_bancarias CB ON CB.cliente_id = CL.cliente_id
	JOIN prestamos PR ON PR.cuenta_id = CB.cuenta_id
    WHERE PR.estado = 'activo'
	GROUP BY CL.cliente_id, CL.nombre, CL.apellido;

SELECT * FROM deuda_clientes;
  
--6. Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
CREATE VIEW numero_transacciones AS 
  SELECT CB.cuenta_id, CB.numero_cuenta, COUNT(TR.transaccion_id) AS numero_transacciones
    FROM cuentas_bancarias CB
    JOIN transacciones TR ON TR.cuenta_id = CB.cuenta_id
	WHERE TR.fecha_transaccion >= CURRENT_TIMESTAMP - INTERVAL '30 days'
    GROUP BY CB.cuenta_id, CB.numero_cuenta
	HAVING COUNT(TR.transaccion_id) > 3;

SELECT * FROM numero_transacciones;
  
--7. Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.
CREATE VIEW retiros_clientes AS 
  SELECT CL.cliente_id, CL.nombre, CL.apellido, SUM(TR.monto) AS total_retirado
    FROM clientes CL
	JOIN cuentas_bancarias CB ON CB.cliente_id = CL.cliente_id
    JOIN transacciones TR ON TR.cuenta_id = CB.cuenta_id
    WHERE TR.tipo_transaccion = 'retiro' AND TR.monto > 1000
	GROUP BY CL.cliente_id, CL.nombre, CL.apellido;

SELECT * FROM retiros_clientes;
  
--8. Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.
CREATE VIEW clientes_sucursal AS 
  SELECT SC.sucursal_id, SC.nombre, COUNT(DISTINCT CL.cliente_id) AS numero_clientes
   FROM clientes CL
	JOIN cuentas_bancarias CB ON CB.cliente_id = CL.cliente_id
    JOIN sucursales SC ON SC.sucursal_id = CB.sucursal_id
   GROUP BY SC.sucursal_id, SC.nombre;

SELECT * FROM clientes_sucursal;
  
--9. Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.
CREATE VIEW clientes_productos AS 
  SELECT CL.cliente_id, CL.nombre, CL.apellido, COUNT(DISTINCT REL_CL_PR.producto_id) AS num_productos
  FROM clientes CL
  JOIN relacion_clientes_productos REL_CL_PR ON REL_CL_PR.cliente_id = CL.cliente_id
  GROUP BY CL.cliente_id, CL.nombre, CL.apellido
  HAVING COUNT(DISTINCT REL_CL_PR.producto_id) > 1; 

SELECT * FROM clientes_productos;
  
--10. Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.
CREATE VIEW prestamos_mayor_promedio AS 
  SELECT *
  FROM prestamos
  WHERE monto > (SELECT AVG(monto) FROM Prestamos); 

SELECT * FROM prestamos_mayor_promedio;