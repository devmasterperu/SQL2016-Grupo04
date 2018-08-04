--1 Procedimiento de inserci�n
select * from produccion.tbEmprendimiento
select * from produccion.tbActividadEconomica

CREATE PROCEDURE produccion.InsActividadEconomica(@ciiu varchar(4),@descripcion varchar(500),@estado bit)
as
begin
	declare @numAct int--Validar si existe la actividad econ�mica
	set     @numAct=(select count(1) from produccion.tbActividadEconomica where ciiu=@ciiu)

	if @numAct>0--Si existe
	begin
		print 'C�digo de ciiu ya existente'
	end
	else--No existe
	begin
		insert into produccion.tbActividadEconomica(ciiu,descripcion,estado)
		values (@ciiu,@descripcion,@estado)
	end
end

--Validar
exec produccion.InsActividadEconomica '9700','Asesor�a para emprendimiento tecnol�gico',1
exec produccion.InsActividadEconomica '9999','Asesor�a para emprendimiento tecnol�gico',1

--2 Procedimiento de actualizaci�n
ALTER PROCEDURE produccion.ActActividadEconomica(@ciiu varchar(4),@descripcion varchar(500),@estado bit)
as
begin
	declare @numAct int--Validar si existe la actividad econ�mica
	set     @numAct=(select count(1) from produccion.tbActividadEconomica where ciiu=@ciiu)
	declare @numCar int--Validar el numero de caracteres
	select  @numCar=len(@descripcion) from produccion.tbActividadEconomica where ciiu=@ciiu--Igual a set
	 
	if @numAct>0--Si existe
	begin
		if @numCar<10
		begin
			print 'Descripci�n de ciiu debe ser mayor o igual a 10'
		end
		else
		begin
			update produccion.tbActividadEconomica
			set    descripcion=@descripcion,estado=@estado
			where  ciiu=@ciiu 
		end
	end
	else--No existe
	begin
		print 'C�digo de ciiu no existente'
	end
end

--select len(descripcion),descripcion from produccion.tbActividadEconomica
--order by  len(descripcion) desc

exec produccion.ActActividadEconomica '9999','Asesor�a Tecnol�gica y Desarrollo de Software',1

--3 Proc. de act+inserci�n
CREATE PROCEDURE produccion.MantenerActividadEconomica(@ciiu varchar(4),@descripcion varchar(500),@estado bit)
as
begin
	declare @numAct int--Validar si existe la actividad econ�mica
	set     @numAct=(select count(1) from produccion.tbActividadEconomica where ciiu=@ciiu)
	declare @numCar int--Validar el numero de caracteres
	select  @numCar=len(@descripcion) from produccion.tbActividadEconomica where ciiu=@ciiu--Igual a set
	 
	if @numAct>0--Si existe
	begin
		if @numCar<10
		begin
			print 'Descripci�n de ciiu debe ser mayor o igual a 10'
		end
		else
		begin
			update produccion.tbActividadEconomica
			set    descripcion=@descripcion,estado=@estado
			where  ciiu=@ciiu 
		end
	end
	else--No existe
	begin
		--print 'C�digo de ciiu no existente'
		insert into produccion.tbActividadEconomica(ciiu,descripcion,estado)
		values (@ciiu,@descripcion,@estado)

		print 'Registrado satisfactoriamente'

	end
end

--4 Procedimiento de eliminac��n
ALTER PROCEDURE produccion.EliminarActividadEconomica(@ciiu varchar(4),@tipo char(1))
as
begin
    if @tipo='L'
	begin
		
		update produccion.tbActividadEconomica
		set    estado=0
		where  ciiu=@ciiu

	end

	if @tipo='F'
	begin
		
		delete from produccion.tbActividadEconomica
		where ciiu=@ciiu

	end

end

execute produccion.EliminarActividadEconomica '9900','L'
SELECT * FROM produccion.tbActividadEconomica where ciiu='9900'

sp_helptext 'produccion.EliminarActividadEconomica'

--5 Procedure dentro de procedure

create procedure  produccion.EliminarActividadEconomicaPadre (@ciiu varchar(4),@tipo char(1))
as
begin
	--Paso 1
	execute produccion.EliminarActividadEconomica @ciiu,@tipo
	--Paso n

end

execute produccion.EliminarActividadEconomicaPadre '9900','F'