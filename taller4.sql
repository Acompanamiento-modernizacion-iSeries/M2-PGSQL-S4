--1. Enunciado: Selecciona todos los clientes junto con los detalles de sus cuentas.
Create Or Replace View clientes_detalle_cuentas As
Select T1.cliente_id, T1.nombre, T1.apellido, T1.direccion, T1.telefono, T1.correo_electronico, T1.fecha_nacimiento,
T1.estado As estado_cliente, T2.numero_cuenta, T2.tipo_cuenta, T2.saldo, T2.fecha_apertura, T2.estado As estado_cuenta
from Clientes As T1
Join Cuentas As T2 On T1.cliente_id = T2.cliente_id;

Select * from clientes_detalle_cuentas;

--2. Enunciado: Selecciona todos los empleados y las sucursales donde trabajan, incluyendo aquellos empleados que no están asignados a ninguna sucursal.
Create Or Replace View Empleado_y_sucursales As
Select T1.empleado_id, T1.nombre, T1.apellido, T1.direccion, T1.telefono, T1.correo_electronico, T1.fecha_contratacion,
T1.posicion, T1.salario, T2.nombre As Nom_sucursal, T2.direccion As Dir_sucursal, T2.telefono As Tel_sucursal
from Empleados As T1
Left Join Sucursales As T2 On T1.sucursal_id = T2.sucursal_id;

Select * from Empleado_y_sucursales;

--3. Enunciado: Selecciona todos los clientes y sus transacciones, incluyendo aquellas transacciones que no tienen clientes asignados.
Create Or Replace View clientes_y_transaciones As
Select T1.cliente_id, T1.nombre, T1.apellido, T1.direccion, T1.telefono, T1.correo_electronico, T1.fecha_nacimiento,
T1.estado As estado_cliente, T2.numero_cuenta, T2.tipo_cuenta, T2.saldo, T2.fecha_apertura, T2.estado As estado_cuenta,
T3.tipo_transaccion, T3.monto, T3.fecha_transaccion, T3.descripcion
from Clientes As T1
Left Join Cuentas As T2 On T1.cliente_id = T2.cliente_id
Left Join  Transacciones As T3 On T2.numero_cuenta = T3.cuenta_id;

Select * from clientes_y_transaciones;

--4. Enunciado: Selecciona todos los empleados y los departamentos, incluyendo aquellos empleados que no están asignados a un departamento y aquellos departamentos sin empleados.

--5. Enunciado: Selecciona los clientes que tienen cuentas con un saldo mayor a 5000.
Create Or Replace View clientes_saldo_mator_de_5000 As
Select T1.cliente_id, T1.nombre, T1.apellido, T1.direccion, T1.telefono, T1.correo_electronico, T1.fecha_nacimiento,
T1.estado As estado_cliente, T2.numero_cuenta, T2.tipo_cuenta, T2.saldo, T2.fecha_apertura, T2.estado As estado_cuenta
from Clientes As T1
Join Cuentas As T2 On T1.cliente_id = T2.cliente_id
Where saldo > 5000;

Select * from clientes_saldo_mator_de_5000;
--6. Enunciado: Selecciona todos los empleados y las sucursales donde trabajan, incluyendo aquellos empleados que no están asignados a ninguna sucursal, pero solo si la sucursal está en "New York".
INSERT INTO Sucursales (sucursal_id, nombre, direccion, telefono)
Values(6, 'New York', 'Avenue', '555777863')
INSERT INTO Empleados (empleado_id, nombre, apellido, direccion, telefono, correo_electronico, fecha_contratacion, posicion, salario, sucursal_id)
Values (995488623, 'Andres', 'Emilio', 'Avenue 6 # 7 - 58', '5557778886', 'Andres_Emilio@bancoquito.com', '2020-05-24', 'Asistente',1500000, 6);

Create Or Replace View empleados_de_newyork As
Select empleado_id, T1.nombre, T1.apellido, T1.direccion, T1.telefono, T1.correo_electronico, T1.fecha_contratacion,
T1.posicion, T1.salario, T2.nombre As Nom_sucursal, T2.direccion As Dir_sucursal, T2.telefono As Tel_sucursal 
from Empleados As T1
Left Join Sucursales As T2 On T1.sucursal_id = T2.sucursal_id
Where T2.nombre = 'New York';

Select * from empleados_de_newyork;

--7. Enunciado: Selecciona todas las transacciones y los clientes asociados, incluyendo aquellas transacciones sin clientes, pero solo si el monto de la transacción es menor a 100.
Create Or Replace View Trx_menor_100000 As
Select T1.tipo_transaccion, T1.monto, T1.fecha_transaccion, T1.descripcion, T2.numero_cuenta, T2.tipo_cuenta, T2.saldo, T2.fecha_apertura, T2.estado As estado_cuenta,
T3.cliente_id, T3.nombre, T3.apellido, T3.direccion, T3.telefono, T3.correo_electronico, T3.fecha_nacimiento, T3.estado As estado_cliente
from Transacciones As T1
Left Join Cuentas As T2 On T1.cuenta_id = T2.numero_cuenta
Join Clientes As T3 On T2.cliente_id = T3.cliente_id
where T1.monto < 100000;

Select * from Trx_menor_100000;

--8. Enunciado: Selecciona todos los empleados y los departamentos, incluyendo aquellos empleados que no están asignados a un departamento y aquellos departamentos sin empleados, pero solo si el departamento está en "HR".

--9. Enunciado: Selecciona las cuentas, los clientes y las transacciones asociadas a cada cuenta.
Create Or Replace View trx_asociadas_cuentas As 
Select T2.cliente_id, T1.numero_cuenta, T3.tipo_transaccion
from Cuentas As t1
Join Clientes As T2 On T1.cliente_id = T2.cliente_id
Join Transacciones As T3 On T1.numero_cuenta = t3.cuenta_id;

Select * from trx_asociadas_cuentas;

--10. Enunciado: Selecciona todas las transacciones, los clientes y las cuentas, incluyendo aquellas transacciones que no están asignadas a ningún cliente o cuenta.
Create Or Replace View Trx_cliente_cuenta As
Select T1.tipo_transaccion, T2.numero_cuenta, T3.cliente_id, T3.nombre, T3.apellido
from Transacciones As T1
Left Join Cuentas As T2 On T1.cuenta_id = T2.numero_cuenta
Join Clientes As T3 On T2.cliente_id = T3.cliente_id;

Select * from Trx_cliente_cuenta;