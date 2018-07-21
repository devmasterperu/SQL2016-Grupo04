--Parte 03: Uso de procedimientos almacenados
--1 Crear un procedimiento de lectura sin parametros
alter procedure produccion.usp_selReporteEmprendimientos
as
begin
select 
e.id,
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
end

execute produccion.usp_selReporteEmprendimientos
--2 Crear un procedimiento de lectura con parametros
create procedure produccion.usp_selReportexEmprendimiento(@id int)
as
begin
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
where e.id=@id
order by e.id
end

execute produccion.usp_selReportexEmprendimiento 1