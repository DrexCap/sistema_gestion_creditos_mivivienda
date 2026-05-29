
USE bd_sistema_creditos_mivivienda;
GO

EXEC SP_HELP cuotas;

ALTER TABLE personas_naturales
ADD CHECK (genero IN ('M', 'F'));

ALTER TABLE personas_naturales
ADD CHECK (estado_civil IN('S','C','D'));

ALTER TABLE personas_naturales
ADD CHECK (situacion_laboral IN('Empleado','Independiente','Desempleado', 'No consigna'));

ALTER TABLE personas_juridicas
ADD CHECK (tipo_empresa IN ('SA','SAC','SRL','EIRL','SAA'));

ALTER TABLE clientes
ADD CHECK (tipo_cliente IN ('N','J'));

ALTER TABLE cuentas
ADD CHECK (moneda IN ('PEN', 'USD', 'EUR'));

ALTER TABLE cuotas
ADD CHECK (estado IN('pagada','pendiente','pagada parcialmente','refinanciada'));

ALTER TABLE creditos
ADD CHECK (estado IN ('desembolsado','vigente','Cancelado','refinanciado'));

ALTER TABLE solicitud_crediticia
ADD CHECK (estado IN ('ingresado','aprobada','desestimado','en evaluacion'));

ALTER TABLE productos_crediticios
ADD CHECK (estado IN ('activo','inactivo','implementandose'));

ALTER TABLE cuotas
ADD CONSTRAINT UQ_cronograma_num_cuota UNIQUE(cronograma_id, nro_cuota);

ALTER TABLE productos_crediticios
ADD CHECK (codigo_producto IN ('NCMV','FCTP','MT','S-CRC'));