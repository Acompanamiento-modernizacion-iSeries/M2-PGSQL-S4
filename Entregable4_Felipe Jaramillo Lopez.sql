
1. Saldo total de cada cliente
CREATE VIEW saldo_total_cuentas AS
select clientes.cliente_id, nombre, apellido, sum (saldo) as saldo
	from public.clientes
	join public.cuentas on clientes.cliente_id   = cuentas.cliente_id
group by clientes.cliente_id, nombre, apellido;

SELECT * FROM saldo_total_cuentas;


2. Transacciones recientes de clientes
CREATE VIEW Transacciones_clientes AS
SELECT nombre, apellido, tipo_transaccion, monto, fecha_transaccion
FROM public.clientes
	join public.cuentas on clientes.cliente_id = cuentas.cliente_id
	join public.transacciones on cuentas.cuenta_id = transacciones.cuenta_id
WHERE fecha_transaccion >= NOW() - INTERVAL '30 days';
	
SELECT * FROM Transacciones_clientes;

3. Clientes con cuentas en múltiples sucursales
CREATE VIEW Clientes_con_cuentas_multiples_sucursales AS
	select sucursales.sucursal_id , sucursales.nombre, COUNT(clientes.cliente_id) AS numero_clientes
	from  sucursales
	left join clientes on sucursales.sucursal_id = clientes.sucursal_id
	group by sucursales.sucursal_id, sucursales.nombre;
		
select * from Clientes_con_cuentas_multiples_sucursales ;

4. Transacciones de cuentas con saldo alto
CREATE VIEW Transacciones_saldo_alto AS
select numero_cuenta, tipo_transaccion, monto, fecha_transaccion
	from public.cuentas
	join public.transacciones on cuentas.cuenta_id = transacciones.cuenta_id
	where transacciones.monto > 5000
	order by numero_cuenta; 
	
SELECT * FROM Transacciones_saldo_alto;

5. Préstamos y total adeudado por cliente
CREATE VIEW Prestamos_por_cliente AS
select nombre, apellido, numero_cuenta, monto as "saldo credito", tasa_interes, fecha_inicio, fecha_fin
from public.clientes
join public.cuentas on clientes.cliente_id = cuentas.cliente_id
join public.prestamos on cuentas.cuenta_id = prestamos.cuenta_id

SELECT * FROM Prestamos_por_cliente ;

6. Cuentas con alta actividad reciente
Enunciado: Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
CREATE VIEW transacciones_mayores_3 AS
select numero_cuenta, count(transacciones.cuenta_id)
from public.cuentas
join public.transacciones on cuentas.cuenta_id = transacciones.cuenta_id
where fecha_transaccion >= NOW() - INTERVAL '1 month'
group by numero_cuenta
having count(transacciones.cuenta_id) > 3;

SELECT * FROM transacciones_mayores_3;

7. Clientes con retiros altos
CREATE VIEW Clientes_retiros_altos AS 
select nombre, apellido, SUM(monto) --numero_cuenta, tipo_transaccion--, 
	from public.clientes
	join public.cuentas on clientes.cliente_id = cuentas.cliente_id
	join public.transacciones on cuentas.cuenta_id = transacciones.cuenta_id
	where tipo_transaccion = 'Retiro' and monto > 100
	group by nombre, apellido;

SELECT * FROM Clientes_retiros_altos ;

8. Clientes y número de sucursales
CREATE VIEW sucursales_clientes AS
	select sucursales.sucursal_id , sucursales.nombre, COUNT(clientes.cliente_id) AS numero_clientes
	from  sucursales
	left join clientes on sucursales.sucursal_id = clientes.sucursal_id
	group by sucursales.sucursal_id, sucursales.nombre;
		
select * from sucursales_clientes ;

9. Clientes con múltiples tipos de cuentas
CREATE VIEW Clientes_multiples_tipos_cuentas AS 
	select   nombre, apellido--, count(cuentas.cliente_id)
	from public.clientes
	join public.cuentas on clientes.cliente_id = cuentas.cliente_id
	group by  nombre, apellido
	having count(cuentas.cliente_id) > 1;

select * from Clientes_multiples_tipos_cuentas;

10. Préstamos superiores al promedio
CREATE VIEW Prestamos_superiores_al_promedio AS 
select nombre, apellido, numero_cuenta, monto
	from public.clientes
	join public.cuentas on clientes.cliente_id = cuentas.cliente_id
	join public.prestamos on cuentas.cuenta_id = prestamos.cuenta_id
	where monto > (SELECT AVG(monto) FROM prestamos);

select * from Prestamos_superiores_al_promedio ;