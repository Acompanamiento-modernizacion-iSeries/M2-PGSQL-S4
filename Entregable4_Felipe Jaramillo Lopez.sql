
1. Saldo total de cada cliente
CREATE VIEW saldo_total_cuentas AS
select clientes.cliente_id, nombre, apellido, sum (saldo) as saldo
	from public.clientes
	join public.cuentas on clientes.cliente_id   = cuentas.cliente_id
group by clientes.cliente_id, nombre, apellido;

SELECT * FROM saldo_total_cuentas;


2. Transacciones recientes de clientes
Enunciado: Crear una vista que muestre las transacciones realizadas por los clientes en los últimos 30 días.

3. Clientes con cuentas en múltiples sucursales
Enunciado: Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.

4. Transacciones de cuentas con saldo alto
Enunciado: Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.

5. Préstamos y total adeudado por cliente
Enunciado: Crear una vista que muestre los clientes con préstamos y el total adeudado.

6. Cuentas con alta actividad reciente
Enunciado: Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.

7. Clientes con retiros altos
Enunciado: Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.

8. Clientes y número de sucursales
Enunciado: Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.

9. Clientes con múltiples tipos de cuentas
Enunciado: Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.

10. Préstamos superiores al promedio
Enunciado: Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.