--1. Saldo total de cada cliente
--Enunciado: Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.
create or replace view total_saldo_cliente as
select cliente_id, sum(saldo) 
from cuentas_bancarias
group by cliente_id;

select * from total_saldo_cliente;

--2. Transacciones recientes de clientes
--Enunciado: Crear una vista que muestre las transacciones realizadas 
--por los clientes en los últimos 30 días.

create or replace view ulimas_transacciones_Cliente_30_dias as
select c.cliente_id, c.nombre, c.apellido, a.*  from transacciones a
join cuentas_bancarias b on b.cuenta_id = a.cuenta_id
join clientes c on c.cliente_id = b.cliente_id
where fecha_transaccion > current_date - interval '1 month';

select * from  ulimas_transacciones_Cliente_30_dias;

--3. Clientes con cuentas en múltiples sucursales
--Enunciado: Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.

create or replace view cantidad_sucursales_por_cliente as
select a.cliente_id, a.nombre, a.apellido, count(*) as cantidad_sucursales from clientes a
join cuentas_bancarias b on b.cliente_id = a.cliente_id
join sucursales c on c.sucursal_id = b.sucursal_id
group by a.cliente_id, a.nombre, a.apellido having count(*) > 1; 

select * from cantidad_sucursales_por_cliente;

--4. Transacciones de cuentas con saldo alto
--Enunciado: Crear una vista que muestre las transacciones de cuentas con saldo mayor a 5000.

create or replace view transacciones_saldo_mayor_5000 as
select a.* from transacciones a 
join cuentas_bancarias b on b.cuenta_id = a.cuenta_id
where saldo > 5000;

select * from transacciones_saldo_mayor_5000;


--5. Préstamos y total adeudado por cliente
--Enunciado: Crear una vista que muestre los clientes con préstamos y el total adeudado.
create or replace view total_adeudado_pestamos as
select a.cliente_id, a.nombre, a.apellido, sum(monto) as total_adeudado  from clientes a
 join  cuentas_bancarias b on b.cliente_id = a.cliente_id
 join  prestamos c on c.cuenta_id = b.cuenta_id
 where c.estado = 'ACTIVO'
 GROUP BY a.cliente_id, a.nombre, a.apellido;
 
 select * from  total_adeudado_pestamos;

--6. Cuentas con alta actividad reciente
--Enunciado: Crear una vista que muestre las cuentas que han realizado 
--más de 3 transacciones en el último mes.

create or replace view cuentas_alta_actividda_reciente as
select b.cuenta_id, b.numero_cuenta, count(*) as numero_transacciones from transacciones a
join cuentas_bancarias b on b.cuenta_id = a.cuenta_id
where fecha_transaccion > current_date - interval '1 month'
group by b.cuenta_id, b.numero_cuenta having count(*) > 3;

select * from cuentas_alta_actividda_reciente;

--7. Clientes con retiros altos
--Enunciado: Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.

create or replace view clientes_retiros_montos_altos as
select  c.cliente_id, c.nombre, c.apellido, a.monto  
from transacciones a
join cuentas_bancarias b on b.cuenta_id = a.cuenta_id
join clientes c on c.cliente_id = b.cliente_id
where a.tipo_transaccion = 'RETIRO' and monto > 1000;

select * from clientes_retiros_montos_altos;

--8. Clientes y número de sucursales
--Enunciado: Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.

create or replace view numero_clientes_por_sucursal as
select a.sucursal_id, a.nombre, count(*) as numero_clientes
from sucursales a
join cuentas_bancarias b on b.sucursal_id = a.sucursal_id
join clientes c on c.cliente_id = b.cliente_id
group by a.sucursal_id, a.nombre;

select * from numero_clientes_por_sucursal;


--9. Clientes con múltiples tipos de cuentas
--Enunciado: Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.

create or replace view clientes_multiples_tipos_cuentas as
select a.cliente_id, a.nombre, a.apellido, count(*) as tipos_cuentas from clientes a
join cuentas_bancarias b on b.cliente_id = a.cliente_id
group by a.cliente_id, a.nombre, a.apellido 
having count(*) > 1;

select * from  clientes_multiples_tipos_cuentas;


--10. Préstamos superiores al promedio
--Enunciado: Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.

create or replace view prestamos_superiores_al_promedio as
select c.prestamo_id, b.cuenta_id, c.monto  
from   cuentas_bancarias b
 join  prestamos c on c.cuenta_id = b.cuenta_id
 where c.monto > (select AVG(monto) from prestamos);
 
 select * from prestamos_superiores_al_promedio;


