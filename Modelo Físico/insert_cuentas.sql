
USE bd_sistema_creditos_mivivienda;
GO

INSERT INTO tipos_cuenta
(nombre,descripcion)
VALUES
('Cuenta Ahorro','Cuenta de ahorro para personas naturales'),
('Cuenta Corriente','Cuenta para operaciones frecuentes'),
('Cuenta Sueldo','Cuenta para depósitos de planilla'),
('Cuenta CTS','Cuenta de compensación por tiempo de servicio'),
('Cuenta Empresarial','Cuenta para empresas'),
('Cuenta Premium','Cuenta para clientes preferentes');
GO

;WITH numeros AS
(
    SELECT TOP 100
    ROW_NUMBER() OVER(ORDER BY (SELECT NULL))+1 numero
    FROM sys.objects
)

INSERT INTO cuentas
(
num_cuenta,
cci,
num_tarjeta,
fecha_creacion,
moneda,
saldo,
tipo_cuenta_id,
clientes_id
)

SELECT

'104500'+RIGHT('000000'+CAST(numero AS VARCHAR),6),

'002104500'+RIGHT('000000'+CAST(numero AS VARCHAR),6),

'453212345678'+RIGHT('0000'+CAST(numero AS VARCHAR),4),

DATEADD(
DAY,
-(ABS(CHECKSUM(NEWID()))%700),
GETDATE()
),

CASE numero%3
WHEN 0 THEN 'PEN'
WHEN 1 THEN 'USD'
ELSE 'EUR'
END,

CAST(
(ABS(CHECKSUM(NEWID()))%45000)+500
AS DECIMAL(18,2)
),

((numero-1)%6)+1,

((numero-1)%36)+1

FROM numeros;

GO

SELECT*FROM cuentas;

-- DELETE FROM cuentas;

-- DBCC CHECKIDENT ('cuentas', RESEED, 0);

