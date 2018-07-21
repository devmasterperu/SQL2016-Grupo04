--1. Uso de UNION-UNION ALL
select * from produccion.tbEmprendimiento
--Replicar una estructura+Data
select * into dbo.tbEmprendimiento
from produccion.tbEmprendimiento

select *
--,'STMA.PRODUCCION' as sistema 
from produccion.tbEmprendimiento
--union 
union all
select *
--,'STMA.DESARROLLO' as sistema 
from dbo.tbEmprendimiento

--2 Uso de Union en la Clausula FROM
select ruc,count(ruc) as total from
(
	select *
	from produccion.tbEmprendimiento
	union
	select *
	from dbo.tbEmprendimiento
) tbConsolidado
group by ruc

--3 Uso de INTERSECT
--
insert into produccion.tbEmprendimiento
select '99999999990','Bodega Charito','BODEGACHARITO',1,getdate(),1,'Dedicado a abarrotes'
union
select '99999999991','Bodega del Pueblo','BODEGAPUEBLO',1,getdate(),1,'Dedicado a licores'
union
select '99999999992','Bodega Don Pepe','BODEGAPEPE',1,getdate(),1,'Dedicado a otros'

--Buscar los RUC, Nombre-Comercial común a tablas
select ruc,nombrecomercial from produccion.tbEmprendimiento
INTERSECT
select ruc,nombrecomercial from dbo.tbEmprendimiento

--Buscar las actividades economicas comunes
--select count(distinct ciiu) from produccion.tbActividadEconomica
select ciiu from produccion.tbActividadEconomica
intersect
--select count(distinct ciiu) from produccion.tbEmprendimientoActividad
select ciiu from produccion.tbEmprendimientoActividad

--Con IN/NOT IN
--Los ciiu que estan en ambas tablas
select ciiu 
from produccion.tbActividadEconomica
--where ciiu in
where ciiu not in
(
select ciiu from produccion.tbEmprendimientoActividad
)

--4 Uso de EXCEPT
select ciiu from produccion.tbActividadEconomica
except
select ciiu from produccion.tbEmprendimientoActividad

--5 Uso de ROW_NUMBER
--SIN PARTICION
select *,
ROW_NUMBER() OVER(ORDER BY nombrecomercial) as posicion1,
RANK() OVER(ORDER BY nombrecomercial) as posicion2,
DENSE_RANK() OVER(ORDER BY nombrecomercial) as posicion3,
NTILE(4) OVER(ORDER BY nombrecomercial) as posicion4
from produccion.tbEmprendimiento
order by nombrecomercial
--CON PARTICION
select *,
ROW_NUMBER() OVER(PARTITION BY idubigeo ORDER BY nombrecomercial) as posicion1,
RANK() OVER(PARTITION BY idubigeo ORDER BY nombrecomercial) as posicion2,
DENSE_RANK() OVER(PARTITION BY idubigeo ORDER BY nombrecomercial) as posicion3,
NTILE(4) OVER(PARTITION BY idubigeo ORDER BY nombrecomercial) as posicion4
from produccion.tbEmprendimiento
where idubigeo in (1,2)
order by idubigeo,nombrecomercial
--CON EMPATES
select * from produccion.tbEmprendimiento
insert into produccion.tbEmprendimiento
select '99999999980','Bodega Charito 2','BODEGACHARITO2',1664,getdate(),1,'Dedicado a abarrotes'
union
select '99999999981','Bodega del Pueblo 2','BODEGAPUEBLO2',1664,getdate(),1,'Dedicado a licores'
union
select '99999999982','Bodega Don Pepe 2','BODEGAPEPE2',1664,getdate(),1,'Dedicado a otros'

insert into produccion.tbEmprendimiento
select '99999999970','Canchas Milagro','CANCHAMILAGRO',1663,getdate(),1,'Deportes'

select * from produccion.tbEmprendimiento
--Agregando columna
alter table produccion.tbEmprendimiento add calificacion char(1)
--Actualizacion de calificacion
update produccion.tbEmprendimiento
set calificacion='A'
where idubigeo not in (1664,1663)

update produccion.tbEmprendimiento
set calificacion='B'
where idubigeo in (1664,1663)

--Consulta de resumen de información
select calificacion,idubigeo,count(distinct emp.id) as total
from produccion.tbEmprendimiento emp
group by calificacion,idubigeo

insert into produccion.tbEmprendimiento
select '99999999960','Canchas Ucayali','CANCHAUCAYALI',1662,getdate(),1,'Deportes','B'

select 
calificacion,
idubigeo,
total,
ROW_NUMBER() OVER(PARTITION BY calificacion ORDER BY total asc)as ROW_NUMBER,
RANK() OVER(PARTITION BY calificacion ORDER BY total asc)as RANK,
DENSE_RANK() OVER(PARTITION BY calificacion ORDER BY total asc) as DENSE_RANK
from
(
select calificacion,idubigeo,count(distinct emp.id) as total
from produccion.tbEmprendimiento emp
group by calificacion,idubigeo
) resumen 
order by calificacion asc,total asc

--6 Uso de CROSS APPLY

select ae.ciiu,ae.descripcion,td.razonsocial
from produccion.tbActividadEconomica as ae--Tabla Izquierda
cross apply
(
  select top (3) * from produccion.tbEmprendimientoActividad ea
  inner join produccion.tbEmprendimiento e
  on ea.idemprendimiento=e.id
  where ea.ciiu=ae.ciiu
  order by razonsocial
) as td--Tabla Derecha (Tabla Derivada)

--7 Uso de OUTER APPLY
--7.1 Crear la función de Tabla
 create function produccion.fn_ObtenerTop3(@ciiu varchar(4)) returns table
 return
 (
	  select top (3) * from produccion.tbEmprendimientoActividad ea
	  inner join produccion.tbEmprendimiento e
	  on ea.idemprendimiento=e.id
	  where ea.ciiu=@ciiu
	  order by razonsocial
 )

 select * from produccion.tbEmprendimientoActividad
 select * from  produccion.fn_ObtenerTop3('6201')
 --7.2 Crear el outer apply
select ae.ciiu,ae.descripcion,td.razonsocial
from produccion.tbActividadEconomica as ae--Tabla Izquierda
cross apply
produccion.fn_ObtenerTop3(ae.ciiu)
as td--Tabla Derecha (Tabla Derivada)
--7.3 Tabla derivada
	select * from
	(
		select ae.ciiu,ae.descripcion,td.razonsocial
		from produccion.tbActividadEconomica as ae--Tabla Izquierda
		cross apply
		produccion.fn_ObtenerTop3(ae.ciiu)
		as td--Tabla Derecha (Tabla Derivada)
		union 
		select '0000','-','-'
		union 
		select '0001','-','-'
	) resumen2

