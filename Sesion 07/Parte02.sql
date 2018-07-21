--Uso de XML/JSON
--1 Uso de XML RAW
select * from produccion.tbActividadEconomica
FOR XML RAW

select *,
ROW_NUMBER() OVER(ORDER BY nombrecomercial) as posicion1,
RANK() OVER(ORDER BY nombrecomercial) as posicion2,
DENSE_RANK() OVER(ORDER BY nombrecomercial) as posicion3,
NTILE(4) OVER(ORDER BY nombrecomercial) as posicion4
from produccion.tbEmprendimiento
order by nombrecomercial
FOR XML RAW

--2 Uso de XML AUTO
select 
u.departamento,e.razonsocial,ae.descripcion,u.provincia,u.distrito
from produccion.tbEmprendimientoActividad ea
inner join produccion.tbEmprendimiento e on ea.idemprendimiento=e.id
inner join produccion.tbActividadEconomica ae on ea.ciiu=ae.ciiu
inner join produccion.tbUbigeo u on e.idubigeo=u.id
order by e.id
FOR XML AUTO

--3 Uso de XML PATH
select 
e.razonsocial as '@razonsocial',
u.departamento as '@departamento',
u.provincia as '@provincia',
u.distrito as '@distrito',
ae.descripcion
from produccion.tbEmprendimientoActividad ea
inner join produccion.tbEmprendimiento e on ea.idemprendimiento=e.id
inner join produccion.tbActividadEconomica ae on ea.ciiu=ae.ciiu
inner join produccion.tbUbigeo u on e.idubigeo=u.id
order by e.id
FOR XML PATH('miemprendimiento'),root('emprendimientos')--elemento con nombre

--3.2
select 
e.razonsocial as '@razonsocial',
u.departamento as 'ubigeo/@departamento',
u.provincia as 'ubigeo/@provincia',
u.distrito as 'ubigeo/@distrito',
ae.descripcion
from produccion.tbEmprendimientoActividad ea
inner join produccion.tbEmprendimiento e on ea.idemprendimiento=e.id
inner join produccion.tbActividadEconomica ae on ea.ciiu=ae.ciiu
inner join produccion.tbUbigeo u on e.idubigeo=u.id
order by e.id
FOR XML PATH('miemprendimiento'),root('emprendimientos')--elemento con nombre

select 
e.razonsocial as '@razonsocial',
u.departamento as 'ubigeo/departamento',
u.provincia as 'ubigeo/provincia',
u.distrito as 'ubigeo/distrito',
ae.descripcion
from produccion.tbEmprendimientoActividad ea
inner join produccion.tbEmprendimiento e on ea.idemprendimiento=e.id
inner join produccion.tbActividadEconomica ae on ea.ciiu=ae.ciiu
inner join produccion.tbUbigeo u on e.idubigeo=u.id
order by e.id
FOR XML PATH('miemprendimiento'),root('emprendimientos')--elemento con nombre

select 
e.razonsocial as '@razonsocial',
u.departamento as 'ubigeo/departamento',
u.provincia as 'ubigeo/provincia',
u.distrito as 'ubigeo/distrito',
ae.descripcion as 'ubigeo/descripcion'
from produccion.tbEmprendimientoActividad ea
inner join produccion.tbEmprendimiento e on ea.idemprendimiento=e.id
inner join produccion.tbActividadEconomica ae on ea.ciiu=ae.ciiu
inner join produccion.tbUbigeo u on e.idubigeo=u.id
order by e.id
FOR XML PATH('miemprendimiento'),--elemento con nombre
root('emprendimientos')--padre de los padres

--4 Uso de JSON AUTO
--4.1
select * from produccion.tbEmprendimiento
FOR JSON AUTO,INCLUDE_NULL_VALUES
--4.2
select 
e.razonsocial,
ae.descripcion,
u.departamento,
u.provincia,
u.distrito
from produccion.tbEmprendimientoActividad ea
inner join produccion.tbEmprendimiento e on ea.idemprendimiento=e.id
inner join produccion.tbActividadEconomica ae on ea.ciiu=ae.ciiu
inner join produccion.tbUbigeo u on e.idubigeo=u.id
order by e.id
FOR JSON AUTO,INCLUDE_NULL_VALUES,root('resultado')

--5 Uso de JSON PATH
select 
e.razonsocial as [emprendimiento.razon],
e.ruc as [emprendimiento.ruc],
/*
u.departamento as [emprendimiento.ubigeo.departamento],
u.provincia as [emprendimiento.ubigeo.provincia],
u.distrito as [emprendimiento.ubigeo.distrito],
*/
u.departamento as [ubigeo.departamento],
u.provincia as [ubigeo.provincia],
u.distrito as [ubigeo.distrito],
ae.descripcion as [actividad.nombre]
from produccion.tbEmprendimientoActividad ea
inner join produccion.tbEmprendimiento e on ea.idemprendimiento=e.id
inner join produccion.tbActividadEconomica ae on ea.ciiu=ae.ciiu
inner join produccion.tbUbigeo u on e.idubigeo=u.id
order by e.id
FOR JSON PATH,
WITHOUT_ARRAY_WRAPPER--Resultados sin corchetes.
