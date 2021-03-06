--SOLUCIONARIO EXAMEN FINAL
--1
DELETE TB_EQUIPO
WHERE ESTADO != 'A'

SET IDENTITY_INSERT TB_EQUIPO ON; 
INSERT INTO TB_EQUIPO (IDEQUIPO, NOMBRE_EQUIPO, ESTADO)
SELECT 33, 'Bolivia', 'A' UNION ALL
SELECT 34, 'Italia', 'A'
SET IDENTITY_INSERT TB_EQUIPO OFF; 

SELECT * FROM TB_EQUIPO
--2
CREATE VIEW v_CantidadPaises
AS
SELECT 
CASE
    WHEN COUNT(NOMBRE_EQUIPO) = 0 THEN 'No hay paises'
    ELSE CONVERT(VARCHAR,COUNT(NOMBRE_EQUIPO))
END AS CANTIDAD_PAISES, 

c.DET_CONTINENTE
FROM  TB_EQUIPO e RIGHT JOIN TB_CONTINENTE c
ON e.IDCONTINENTE = c.IDCONTINENTE
GROUP BY e.IDCONTINENTE, c.DET_CONTINENTE

select * from v_CantidadPaises

--3
CREATE PROCEDURE sp_EQUIPO_Registrar
@nombre varchar(50),
@idcontinente int
AS

INSERT INTO TB_EQUIPO (NOMBRE_EQUIPO,ESTADO, IDCONTINENTE)
VALUES (@nombre,'A',@idcontinente)

exec sp_EQUIPO_Registrar 'pais nuevo','1'

--4
CREATE PROCEDURE sp_FIXTURE_updateScore
@IDEQUIPOA int,
@IDEQUIPOB int,
@SCOREA int,
@SCOREB int
AS

UPDATE TB_FIXTURE
SET SCOREA = @SCOREA,
    SCOREB = @SCOREB
WHERE 
IDEQUIPOA = @IDEQUIPOA AND IDEQUIPOB = @IDEQUIPOB

exec sp_FIXTURE_updateScore '2','1','2','0'
exec sp_FIXTURE_updateScore '3','4','5','0'
exec sp_FIXTURE_updateScore '10','12','1','1'
select * from TB_FIXTURE

--5
CREATE FUNCTION f_EquipoMasGoles ()
RETURNS TABLE
as
return(
SELECT TOP 1 eA.NOMBRE_EQUIPO AS EA,eB.NOMBRE_EQUIPO AS EB, (f.SCOREA+f.SCOREB) AS GOLES
FROM TB_FIXTURE f INNER JOIN TB_EQUIPO eA 
ON f.IDEQUIPOA = eA.IDEQUIPO INNER JOIN TB_EQUIPO eB 
ON f.IDEQUIPOB = eb.IDEQUIPO
GROUP BY eA.NOMBRE_EQUIPO,eB.NOMBRE_EQUIPO,IDFIXTURE,f.SCOREA,f.SCOREB
ORDER BY GOLES DESC)

SELECT * FROM f_EquipoMasGoles()

--6
CREATE PROCEDURE dbo.reporteEquipos
as
select e.NOMBRE_EQUIPO,f.NOMBRE_EQUIPO,f.SCOREA,f.SCOREB,
ROW_NUMBER() OVER (PARTITION BY e.NOMBRE_EQUIPO ORDER BY SCOREA DESC) as fila
from dbo.TB_EQUIPO as e
outer apply
(
  select top (2) IDFIXTURE,SCOREA,e0.NOMBRE_EQUIPO,SCOREB from TB_FIXTURE f0
  join TB_EQUIPO e0 on f0.IDEQUIPOB=e0.IDEQUIPO
  where f0.IDEQUIPOA=e.IDEQUIPO
  order by SCOREA DESC
) as f
where SCOREA IS NOT NULL AND SCOREB IS NOT NULL
order by e.NOMBRE_EQUIPO,SCOREA DESC

--7
--7.a
select 
IDEQUIPO as '@id',
NOMBRE_EQUIPO as '@nombre',
ESTADO as '@estado'
from TB_EQUIPO
WHERE NOMBRE_EQUIPO LIKE '%ENE%' or  NOMBRE_EQUIPO LIKE '%AL%'
FOR XML PATH('equipo'),root('equipos')--elemento con nombre

--7.b
select 
IDEQUIPO as [equipo.id],
NOMBRE_EQUIPO as [equipo.nombre],
ESTADO as [equipo.estado]
from TB_EQUIPO
WHERE NOMBRE_EQUIPO LIKE '%ENE%' or  NOMBRE_EQUIPO LIKE '%AL%'
FOR JSON PATH,root('equipos_json')--elemento con nombre
