
USE bd_sistema_creditos_mivivienda;
GO

ALTER TABLE productos_crediticios
DROP CONSTRAINT CK__productos__codig__2739D489;

ALTER TABLE productos_crediticios
DROP COLUMN codigo_producto;

--------------------------------------
-- PRODUCTOS CREDITICIOS
--------------------------------------

INSERT INTO productos_crediticios
(
nombre,
monto_minimo,
monto_maximo,
tasa_interes_minima,
tasa_interes_maxima,
plazo_minimo_meses,
plazo_maximo_meses,
estado,
created_at,
updated_at
)

VALUES

(
'NCMV',
1000,
50000,
10.50,
35.00,
6,
60,
'activo',
GETDATE(),
GETDATE()
),

(
'FCTP',
50000,
500000,
7.50,
15.00,
60,
360,
'activo',
GETDATE(),
GETDATE()
),

(
'MT',
10000,
120000,
8.50,
18.00,
12,
72,
'activo',
GETDATE(),
GETDATE()
),

(
'S-CRC',
3000,
80000,
12.00,
25.00,
12,
48,
'activo',
GETDATE(),
GETDATE()
);

GO

SELECT*FROM productos_crediticios;