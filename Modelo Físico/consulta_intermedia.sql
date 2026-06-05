
USE bd_sistema_creditos_mivivienda;
GO

--Contar cuántos clientes existen por tipo de cliente.
SELECT
	CASE WHEN tipo_cliente = 'J' 
		THEN 'Cliente Juridico'
		ELSE 'Cliente Persona Natural' 
	END AS 'Tipo cliente', 
	COUNT(*) AS 'Num_clientes'
FROM clientes
GROUP BY tipo_cliente;


--Mostrar cuántas cuentas tiene cada cliente.
SELECT  
	cliente.id,
	CASE 
	WHEN pj.razon_social IS NULL 
		THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_paterno, ' ', nt.nombres)
	ELSE pj.razon_social END AS 'cliente',
    cliente.tipo_cliente,
    COUNT(cc.cuenta_id) AS cantidad_cuentas
FROM clientes cliente
LEFT JOIN cuentas_clientes cc ON cliente.id = cc.cliente_id
LEFT JOIN personas_naturales nt ON nt.cliente_id=cliente.id AND cliente.tipo_cliente='N'
LEFT JOIN personas_juridicas pj ON pj.cliente_id=cliente.id AND cliente.tipo_cliente='J'
WHERE pj.id IS NOT NULL OR nt.id IS NOT NULL
GROUP BY 
	cliente.id,
	cliente.tipo_cliente,
	pj.razon_social,
	nt.apellido_paterno, 
	nt.apellido_paterno,
	nt.nombres
ORDER BY cantidad_cuentas DESC;
