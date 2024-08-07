Consultas con vistas 
1. create view vista_saldoClientes as
   select cli.cliente_id, cu.saldo  from clientes cli 
   join cuentas cu 
   on cli.cliente_id = cu.cliente_id
   
   select * from vista_saldoClientes

2.create view vista_transaccionesRecientes as
  select cli.cliente_id, tr.* from clientes cli
  join cuentas cu 
  on cli.cliente_id = cu.cliente_id
  join transacciones tr
  on cu.cuenta_id = tr.cuenta_id
  where tr.fecha_transaccion >= CURRENT_DATE - INTERVAL '9 month'

  select * from vista_transaccionesRecientes

3.create view vista_clientesSucursales as
  select cu.cliente_id, count(distinct cu.cuenta_id) as cuentas, count(distinct cu.sucursal_id) as sucursales
  from cuentas cu 
  left join sucursales su 
  on cu.sucursal_id = su.sucursal_id
  group by cu.cliente_id
  having count(distinct cu.sucursal_id) > 1

select * from vista_clientesSucursales

4.create view vista_cuentasSaldos as
  select tr.tipo_transaccion, cu.cuenta_id, cu.saldo from transacciones tr join cuentas cu
  on cu.cuenta_id = tr.cuenta_id
  where cu.saldo > 5000

  select * from vista_cuentasSaldos
  
5.create view vista_clientesPrestamo as
  select cli.nombre, cu.numero_cuenta, cu.tipo_cuenta, pr.prestamo_id, pr.monto from clientes cli join cuentas cu 
  on cli.cliente_id = cu.cliente_id join
  prestamos pr on pr.cuenta_id = cu.cuenta_id
  
  select * from vista_clientesPrestamo
  
6.create view vista_cuentasActividadReciente as
  select cuenta_id from transacciones 
  where fecha_transaccion >= CURRENT_DATE - INTERVAL '12 month'
  group by cuenta_id having count(cuenta_id) > 1
  
  select * from vista_cuentasActividadReciente
  
  
7.create view vista_RetirosAltos as
  select cli.cliente_id, cli.nombre, tr.* from clientes cli
  join cuentas cu 
  on cli.cliente_id = cu.cliente_id
  join transacciones tr
  on cu.cuenta_id = tr.cuenta_id
  where tr.tipo_transaccion = 'RETIRO' and tr.monto > 1000
  
  select * from vista_RetirosAltos
  
8.create view vista_SucursalesyClientes as 
  select s.sucursal_id, count(distinct cu.cliente_id) from sucursales s 
  left join cuentas cu
  on s.sucursal_id = cu.sucursal_id 
  group by s.sucursal_id
  
  select * from vista_SucursalesyClientes
  
9.create view vista_ClientesCuentas as  
  SELECT cliente_id
  FROM cuentas
  GROUP BY cliente_id
  HAVING COUNT(DISTINCT tipo_cuenta) > 1
  
  select * from vista_ClientesCuentas
  
10.create view vista_PromedioPrestamos as
   select * from prestamos 
   where monto > (select avg(monto) from prestamos)
   
   select * from vista_PromedioPrestamos
   
