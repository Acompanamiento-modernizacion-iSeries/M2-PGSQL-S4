-- 1.
create or replace view saldo_total as
select cl.cliente_id, cl.nombre, cl.apellido, sum(cu.saldo) 
from clientes as cl 
join cuentas_bancarias as cu on cl.cliente_id = cu.cliente_id
group by cl.cliente_id, cl.nombre, cl.apellido
order by cl.cliente_id;

-- 2.
create or replace view transacciones_clientes as
select cl.cliente_id, cl.nombre, cl.apellido, cb.numero_cuenta, cb.tipo_cuenta, tr.tipo_transaccion, tr.monto
from transacciones as tr
join cuentas_bancarias as cb on tr.cuenta_id = cb.cuenta_id
join clientes as cl on cl.cliente_id = cb.cliente_id where tr.fecha_transaccion > CURRENT_DATE - INTERVAL '30 days';

-- 3.
create or replace view Cuentas_X_Sucursal as
select cl.cliente_id, cl.nombre, cl.apellido, cu.numero_cuenta, cu.tipo_cuenta 
from clientes as cl 
join cuentas_bancarias as cu on cl.cliente_id = cu.cliente_id;

-- 4. 
create or replace view Transacciones_saldo_alto as
select cb.cuenta_id, cb.numero_cuenta, cb.tipo_cuenta, cb.saldo, tr.tipo_transaccion, tr.monto
from transacciones as tr
join cuentas_bancarias as cb on tr.cuenta_id = cb.cuenta_id where cb.saldo > 5000;

-- 5. 
create or replace view Préstamos_y_total_adeudado as
select cl.cliente_id, cl.nombre, cl.apellido, sum(pr.monto) as total_adeudado
from prestamos as pr
join cuentas_bancarias as cu on cu.cuenta_id = pr.cuenta_id
join clientes as cl on cl.cliente_id = cu.cliente_id
group by cl.cliente_id, cl.nombre, cl.apellido
order by cl.cliente_id;

-- 6.
create or replace view cuentas_alta_actividad as
select cb.cuenta_id, cb.numero_cuenta, cb.tipo_cuenta
from transacciones as tr
join cuentas_bancarias as cb on tr.cuenta_id = cb.cuenta_id
where tr.fecha_transaccion > CURRENT_DATE - INTERVAL '30 days'
group by cb.cuenta_id, cb.numero_cuenta, cb.tipo_cuenta
having COUNT(cb.cuenta_id) > 3;

-- 7.
create or replace view retiros_altos as
select cl.cliente_id, cl.nombre, cl.apellido, tr.tipo_transaccion, tr.monto, tr.fecha_transaccion
from transacciones as tr
join cuentas_bancarias as cb on tr.cuenta_id = cb.cuenta_id
join clientes as cl on cl.cliente_id = cb.cliente_id
where tr.tipo_transaccion = 'retiro' and tr.monto > 1000;

-- 8.
create or replace view cuentas_clientes as
select cl.cliente_id, cl.nombre, cl.apellido, cu.numero_cuenta, cu.tipo_cuenta 
from clientes as cl 
join cuentas_bancarias as cu on cl.cliente_id = cu.cliente_id;

--9. 
create or replace view multiples_cuentas as
select cl.cliente_id, cl.nombre, cl.apellido, count(cb.tipo_cuenta) as Cantidad_cuentas 
from clientes as cl
join cuentas_bancarias as cb on cl.cliente_id = cb.cliente_id
group by cl.cliente_id, cl.nombre, cl.apellido having count(cb.tipo_cuenta) >= 2;

-- 10.
create or replace view prestamos_superior_promedio as
select *
from prestamos
where monto > (select avg(monto) from prestamos);

select * from prestamos_superior_promedio