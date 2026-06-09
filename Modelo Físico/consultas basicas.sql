
USE bd_sistema_creditos_mivivienda;
GO

-- EJEMPLOS DE LA BD DEL PROFESOR

--Mostrar todos los clientes naturales con sus nombres completos y situación laboral.
SELECT
CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres) AS 'nombre_completo',
nt.situacion_laboral
FROM personas_naturales nt;

--Mostrar todas las empresas activas y su sector económico.
SELECT razon_social, sector_economico FROM personas_juridicas WHERE estado_empresa='Activo';

--Listar todas las cuentas en moneda PEN.
SELECT num_cuenta
FROM cuentas
WHERE moneda='PEN';

--Mostrar todas las solicitudes ingresadas durante el último año.
select codigo_solicitud 
from solicitud_crediticia 
where convert(date,fecha_solicitud) between '2025-01-01' and '2025-12-31';

SELECT codigo_solicitud, fecha_solicitud, monto_solicitado, moneda_solicitada, estado
FROM solicitud_crediticia
WHERE fecha_solicitud >= '2025/05/25'
ORDER BY fecha_solicitud;

--- Solicitudes del ultimo año
SELECT *
FROM solicitud_crediticia
WHERE YEAR(fecha_solicitud)=YEAR(GETDATE());

--- Solicitudes de los ultimos 365(1 año) dias
SELECT *
FROM solicitud_crediticia
WHERE fecha_solicitud>=DATEADD(DAY,-365,GETDATE());

--Listar todos los productos crediticios activos.
select nombre from productos_crediticios where estado='ACTIVO';

--Mostrar todos los créditos con estado vigente.
select id, numero_credito from creditos where estado='VIGENTE';

--Mostrar todos los pagos realizados mediante transferencia.
select * from pagos where metodo_pago ='Transferencia';

--Mostrar el listado de clientes junto con el tipo de cliente (N o J).
SELECT
CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres) AS 'nombre_completo', c.tipo_cliente
FROM personas_naturales nt INNER JOIN clientes c 
ON nt.cliente_id=c.id AND c.tipo_cliente='N'
UNION
SELECT
razon_social AS 'nombre_completo', c.tipo_cliente
FROM personas_juridicas pj INNER JOIN clientes c 
ON pj.cliente_id=c.id AND c.tipo_cliente='J'
ORDER BY 2 DESC;


select * from personas_juridicas;

SELECT c.id,
CASE 
WHEN pj.razon_social IS NULL 
	THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres)
ELSE pj.razon_social END AS 'cliente',
c.tipo_cliente
FROM clientes c
LEFT JOIN personas_naturales nt ON nt.cliente_id=c.id 
LEFT JOIN personas_juridicas pj ON pj.cliente_id=c.id 
ORDER BY 2 DESC;

SELECT * FROM clientes WHERE id IN (36,26,16);

SELECT * FROM personas_juridicas WHERE id IN(16,36)
SELECT * FROM personas_naturales WHERE id IN(18,20)

--Mostrar las cuentas creadas ordenadas por saldo de mayor a menor.
Select * from cuentas order by saldo desc







