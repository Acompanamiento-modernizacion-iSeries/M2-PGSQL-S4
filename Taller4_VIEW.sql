--CREATE VIEW Saldo_Cliente AS
select a.nombre, a.apellido, a.cliente_id, sum(b.saldo) as Saldo_Total
from clientes as a join cuentas_bancarias as b
on a.cliente_id = b.cliente_id group by a.nombre, a.apellido, a.cliente_id;

--CREATE VIEW Transacciones_recientes
select * from transacciones as a join cuentas_bancarias as b 
on a.cuenta_id = b.cuenta_id 
join clientes as c on c.cliente_id = b.cliente_id
where a.fecha_transaccion >= '2024-07-05' and a.fecha_transaccion <= '2024-08-05';

CREATE VIEW Trans_recientes AS
select  c.nombre, c.apellido, c.cliente_id, 
a.fecha_transaccion 
from transacciones as a join cuentas_bancarias as b 
on a.cuenta_id = b.cuenta_id 
join clientes as c on c.cliente_id = b.cliente_id
where a.fecha_transaccion >= current_date - 30;

select  a.nombre, a.apellido, a.cliente_id, b.cuenta_id, b.sucursal_id
from clientes as a join cuentas_bancarias as b 
on a.cuenta_id = b.cuenta_id
having sucursal_id count(*) > 1;


select * from clientes;
select * from sucursales;
select * from cuentas_bancarias;

--Clientes con cuentas en múltiples sucursales
CREATE VIEW multiples_suc as 
sELECT a.cliente_id, count(b.sucursal_id)                
from clientes a JOIN cuentas_bancarias b ON          
a.a.cliente_id = b.a.cliente_id                             
group by a.cliente_id                                  
having count(distinct B.sucursal_id) > 1               
order by a.cliente_id;

--Transacciones de cuentas con saldo alto

CREATE VIEW saldo_alto as 
select a.cuenta_id, b.saldo, a.tipo_transaccion from transacciones as a join cuentas_bancarias as b 
on a.cuenta_id = b.cuenta_id 
where b.saldo >5000;

--Préstamos y total adeudado por cliente

select * from clientes; 
select * from préstamos;
select * from cuentas_bancarias;

--Préstamos y total adeudado por cliente

create view Deuda_cliente as
select c.cliente_id,c.nombre, c.apellido, sum(a.monto) 
from  préstamos as a join cuentas_bancarias as b on 
a.cuenta_id = b.cuenta_id
join clientes as c on c.cliente_id = b.cliente_id
group by c.cliente_id, c.nombre, c.apellido;

--
select * from transacciones;

---Cuentas con alta actividad reciente
create view alta_actividad as
select a.cuenta_id, a.fecha_transaccion 
from transacciones as a join cuentas_bancarias as b 
on a.cuenta_id = b.cuenta_id
where fecha_transaccion >= current_date - 30 
group by a.cuenta_id, a.fecha_transaccion
having count(1) >= 1; 

--- Clientes con retiros altos
select * from transacciones;
select * from clientes;
select *from cuentas_bancarias;

--- Clientes con retiros altos
create view retiros_altos as 
select a.nombre, a.apellido, a.cliente_id, b.cuenta_id, c.tipo_transaccion, 
c.monto
from clientes as a join cuentas_bancarias as b
on a.cliente_id = b.cliente_id
join transacciones as c  on b.cuenta_id = c.cuenta_id
where c.monto > 1000 and c.tipo_transaccion = 'retiro' ; 

-- Clientes y número de sucursales

sELECT count(a.cliente_id), b.sucursal_id                
from clientes a JOIN cuentas_bancarias b ON          
a.a.cliente_id = b.a.cliente_id                             
group by a.cliente_id, b.sucursal_id                                  
order by a.cliente_id, b.sucursal_id;

--- Clientes con múltiples tipos de cuentas

select a.nombre, a.apellido, a.cliente_id, b.tipo_cuenta
from clientes as a join cuentas_bancarias as b
on a.cliente_id = b.cliente_id
group by a.cliente_id, b.tipo_cuenta
having count(1) > 1 ; 

---Préstamos superiores al promedio
select * from préstamos
where monto > (select AVG(monto) from préstamos);










	




