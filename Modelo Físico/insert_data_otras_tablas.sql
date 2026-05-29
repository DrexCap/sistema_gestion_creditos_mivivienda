
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

SELECT*FROM ubicacion;

--------------------------------------
-- UBICACIÓN
--------------------------------------

ALTER TABLE ubicacion
DROP CONSTRAINT UQ__ubicacio__3126FF0060AE6C90;

ALTER TABLE ubicacion
DROP COLUMN distrito;

ALTER TABLE ubicacion
DROP COLUMN departamento;

ALTER TABLE ubicacion
DROP COLUMN provincia;

ALTER TABLE ubicacion
ADD ubigeo CHAR(10) NOT NULL UNIQUE;

-- Script SQL Server — Ubigeos Oficiales de la Costa del Perú

INSERT INTO ubicacion (ubigeo)
VALUES

-- TUMBES
('240101'),('240102'),('240103'),('240104'),('240105'),('240106'),
('240201'),('240202'),('240203'),('240301'),('240302'),('240303'),

-- PIURA
('200101'),('200102'),('200103'),('200104'),('200105'),('200106'),('200107'),('200108'),('200109'),
('200201'),('200202'),('200203'),('200204'),('200205'),('200206'),('200207'),('200208'),('200209'),('200210'),
('200301'),('200302'),('200303'),('200304'),('200305'),('200306'),('200307'),('200308'),
('200401'),('200402'),('200403'),('200404'),('200405'),('200406'),('200407'),('200408'),
('200501'),('200502'),('200503'),('200504'),('200505'),('200506'),('200507'),('200508'),('200509'),('200510'),
('200601'),('200602'),('200603'),('200604'),('200605'),('200606'),
('200701'),('200702'),('200703'),('200704'),('200705'),('200706'),('200707'),('200708'),
('200801'),('200802'),('200803'),('200804'),('200805'),

-- LAMBAYEQUE
('140101'),('140102'),('140103'),('140104'),('140105'),('140106'),('140107'),('140108'),('140109'),('140110'),('140111'),('140112'),
('140201'),('140202'),('140203'),('140204'),('140205'),('140206'),
('140301'),('140302'),('140303'),('140304'),('140305'),('140306'),

-- LA LIBERTAD
('130101'),('130102'),('130103'),('130104'),('130105'),('130106'),('130107'),('130108'),('130109'),('130110'),('130111'),
('130201'),('130202'),('130203'),('130204'),('130205'),('130301'),('130302'),('130303'),('130304'),
('130401'),('130402'),('130403'),('130404'),('130405'),
('130501'),('130502'),('130503'),('130504'),('130505'),('130506'),('130507'),('130508'),
('130601'),('130602'),('130603'),('130604'),('130605'),('130606'),('130607'),('130608'),
('130701'),('130702'),('130703'),('130704'),('130705'),('130706'),
('130801'),('130802'),('130803'),('130804'),
('130901'),('130902'),('130903'),('130904'),('130905'),('130906'),('130907'),('130908'),('130909'),('130910'),('130911'),('130912'),('130913'),
('131001'),('131002'),('131003'),('131004'),('131005'),('131101'),('131102'),('131103'),('131104'),('131105'),('131201'),('131202'),('131203'),('131204'),('131205'),('131301'),('131302'),('131303'),('131304'),('131305'),

-- ANCASH
('020101'),('020102'),('020103'),('020104'),('020105'),('020106'),('020107'),('020108'),('020109'),('020110'),('020111'),('020112'),
('020201'),('020202'),('020203'),('020204'),('020205'),('020206'),('020301'),('020302'),('020303'),('020304'),('020305'),
('020401'),('020402'),('020403'),('020404'),('020405'),('020406'),('020407'),('020408'),('020409'),('020410'),('020411'),
('020501'),('020502'),('020503'),('020504'),('020505'),('020601'),('020602'),('020603'),('020604'),('020605'),('020606'),
('020701'),('020702'),('020703'),('020704'),('020705'),('020706'),('020801'),('020802'),('020803'),('020804'),('020805'),('020806'),('020807'),('020808'),('020809'),('020810'),
('020901'),('020902'),('020903'),('020904'),('020905'),('020906'),('020907'),('021001'),('021002'),('021003'),('021004'),('021005'),
('021101'),('021102'),('021103'),('021104'),('021105'),('021106'),('021107'),('021108'),('021109'),
('021201'),('021202'),('021203'),('021204'),('021205'),('021206'),('021207'),('021208'),('021209'),('021210'),
('021301'),('021302'),('021303'),('021304'),('021305'),('021306'),
('021401'),('021402'),('021403'),('021404'),('021405'),('021406'),('021407'),('021408'),('021409'),('021410'),('021411'),('021412'),('021413'),('021414'),('021415'),('021416'),
('021501'),('021502'),('021503'),('021504'),('021505'),('021506'),('021507'),('021508'),('021509'),('021510'),
('021601'),('021602'),('021603'),('021604'),('021605'),('021606'),('021607'),('021608'),('021609'),('021610'),('021611'),
('021701'),('021702'),('021703'),('021704'),('021705'),('021706'),
('021801'),('021802'),('021803'),('021804'),('021805'),('021806'),('021807'),('021808'),('021809'),('021810'),
('021901'),('021902'),('021903'),('021904'),('021905'),('021906'),('021907'),('021908'),('021909'),('021910'),
('022001'),('022002'),('022003'),('022004'),('022005'),('022006'),('022007'),('022008'),('022009'),('022010'),

-- LIMA
('150101'),('150102'),('150103'),('150104'),('150105'),('150106'),('150107'),('150108'),('150109'),('150110'),('150111'),('150112'),('150113'),('150114'),('150115'),('150116'),('150117'),('150118'),('150119'),('150120'),('150121'),('150122'),('150123'),('150124'),('150125'),('150126'),('150127'),('150128'),('150129'),('150130'),('150131'),('150132'),('150133'),('150134'),('150135'),('150136'),('150137'),('150138'),('150139'),('150140'),('150141'),('150142'),('150143'),
('150201'),('150202'),('150203'),('150204'),('150205'),('150206'),('150301'),('150302'),('150303'),('150304'),('150305'),('150306'),('150307'),('150308'),('150309'),('150310'),('150311'),('150312'),
('150401'),('150402'),('150403'),('150404'),('150405'),('150406'),('150407'),('150408'),('150409'),('150410'),('150411'),('150412'),('150413'),('150414'),('150415'),('150416'),
('150501'),('150502'),('150503'),('150504'),('150505'),('150506'),
('150601'),('150602'),('150603'),('150604'),('150605'),('150606'),('150607'),('150608'),('150609'),('150610'),('150611'),('150612'),('150613'),('150614'),('150615'),
('150701'),('150702'),('150703'),('150704'),('150705'),('150706'),('150707'),('150708'),('150709'),('150710'),('150711'),('150712'),('150713'),('150714'),('150715'),('150716'),
('150801'),('150802'),('150803'),('150804'),('150805'),('150806'),('150807'),('150808'),('150809'),('150810'),('150811'),('150812'),
('150901'),('150902'),('150903'),('150904'),('150905'),('150906'),('150907'),('150908'),('150909'),('150910'),('150911'),('150912'),('150913'),('150914'),('150915'),('150916'),('150917'),('150918'),('150919'),('150920'),('150921'),('150922'),('150923'),('150924'),('150925'),('150926'),('150927'),('150928'),('150929'),('150930'),('150931'),('150932'),
('151001'),('151002'),('151003'),('151004'),('151005'),('151006'),('151007'),('151008'),('151009'),('151010'),('151011'),('151012'),

-- CALLAO
('070101'),('070102'),('070103'),('070104'),('070105'),('070106'),('070107'),

-- ICA
('110101'),('110102'),('110103'),('110104'),('110105'),('110106'),('110107'),('110108'),('110109'),('110110'),('110111'),('110112'),('110113'),('110114'),
('110201'),('110202'),('110203'),('110204'),('110205'),
('110301'),('110302'),('110303'),('110304'),('110305'),('110401'),('110402'),('110403'),('110404'),('110405'),('110501'),('110502'),('110503'),('110504'),('110505');

--------------------------------------
-- PROPIEDAD
--------------------------------------

DELETE FROM propiedad;

DBCC CHECKIDENT ('propiedad', RESEED, 0);

;WITH numeros AS
(
    SELECT TOP 100
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS numero
    FROM sys.objects
)

INSERT INTO propiedad
(
    ubicacion_id,
    tipo_vivienda,
    direccion,
    valor_comercial,
    area_m2,
    estado_vivienda
)

SELECT

    ((numero - 1) % (SELECT COUNT(*) FROM ubicacion)) + 1,

    CASE ABS(CHECKSUM(NEWID())) % 5
        WHEN 0 THEN 'Casa'
        WHEN 1 THEN 'Departamento'
        WHEN 2 THEN 'Terreno'
        WHEN 3 THEN 'Duplex'
        ELSE 'Penthouse'
    END,

    CASE ABS(CHECKSUM(NEWID())) % 8
        WHEN 0 THEN 'Av. Primavera'
        WHEN 1 THEN 'Jr. Los Olivos'
        WHEN 2 THEN 'Calle Las Flores'
        WHEN 3 THEN 'Av. Grau'
        WHEN 4 THEN 'Jr. Independencia'
        WHEN 5 THEN 'Av. Central'
        WHEN 6 THEN 'Av. Los Ingenieros'
        ELSE 'Calle San Martin'
    END
    + ' '
    + CAST((ABS(CHECKSUM(NEWID())) % 9999) + 1 AS VARCHAR)
    + ' - Urb. '
    +
    CASE ABS(CHECKSUM(NEWID())) % 8
        WHEN 0 THEN 'San Pedro'
        WHEN 1 THEN 'Los Pinos'
        WHEN 2 THEN 'Santa Rosa'
        WHEN 3 THEN 'Miraflores'
        WHEN 4 THEN 'Las Palmeras'
        WHEN 5 THEN 'Villa Norte'
        WHEN 6 THEN 'Los Jardines'
        ELSE 'Santa Catalina'
    END,

    CAST(
        ((ABS(CHECKSUM(NEWID())) % 900000) + 50000)
        AS DECIMAL(18,2)
    ),

    (ABS(CHECKSUM(NEWID())) % 350) + 35,

    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'Nueva'
        WHEN 1 THEN 'Usada'
        WHEN 2 THEN 'En proyecto'
        ELSE 'Remodelada'
    END

FROM numeros;

select * from cuotas;


--------------------------------------
-- USUARIO
--------------------------------------

DELETE FROM usuario;

DBCC CHECKIDENT ('usuario', RESEED, 0);

INSERT INTO usuario
(
    nombres,
    apellidos,
    correo,
    telefono,
    rol,
    estado
)

VALUES

(
    'Ricardo Manuel',
    'Navarro',
    'ricardo.navarro@empresa.com',
    912345681,
    'ASESOR',
    'ACTIVO'
),

(
    'Patricia Elena',
    'Gutierrez',
    'patricia.gutierrez@empresa.com',
    912345682,
    'SUPERVISOR',
    'ACTIVO'
),

(
    'Javier Alonso',
    'Mendoza',
    'javier.mendoza@empresa.com',
    912345683,
    'ANALISTA',
    'ACTIVO'
),

(
    'Daniela Rocio',
    'Cabrera',
    'daniela.cabrera@empresa.com',
    912345684,
    'ASESOR',
    'INACTIVO'
),

(
    'Luis Enrique',
    'Pacheco',
    'luis.pacheco@empresa.com',
    912345685,
    'SUPERVISOR',
    'ACTIVO'
),

(
    'Karen Milagros',
    'Ortega',
    'karen.ortega@empresa.com',
    912345686,
    'ASESOR',
    'ACTIVO'
),

(
    'Sergio Adrian',
    'Velasquez',
    'sergio.velasquez@empresa.com',
    912345687,
    'ANALISTA',
    'SUSPENDIDO'
),

(
    'Fiorella Andrea',
    'Campos',
    'fiorella.campos@empresa.com',
    912345688,
    'SUPERVISOR',
    'ACTIVO'
),

(
    'Martin Alejandro',
    'Reyes',
    'martin.reyes@empresa.com',
    912345689,
    'ASESOR',
    'ACTIVO'
),

(
    'Claudia Beatriz',
    'Morales',
    'claudia.morales@empresa.com',
    912345690,
    'ANALISTA',
    'ACTIVO'
);
 

SELECT * FROM usuario;

--------------------------------------
-- SOLICITUD_CREDITICIA
--------------------------------------

DELETE FROM solicitud_crediticia;

DBCC CHECKIDENT ('solicitud_crediticia', RESEED, 0);

;WITH numeros AS
(
    SELECT TOP 75
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
),
asesores AS
(
    SELECT
        id,
        ROW_NUMBER() OVER(ORDER BY id) AS fila
    FROM usuario
    WHERE rol = 'ASESOR'
)

INSERT INTO solicitud_crediticia
(
    cliente_id,
    producto_crediticio_id,
    propiedad_id,
    asesor_id,
    codigo_solicitud,
    fecha_solicitud,
    monto_solicitado,
    moneda_solicitada,
    estado
)

SELECT

    ((n - 1) % 36) + 1,

    ((n - 1) % 4) + 1,

    ((n - 1) % 100) + 1,

    a.id,

    'SOL-' + RIGHT('00000' + CAST(n AS VARCHAR), 5),

    DATEADD
    (
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 365),
        GETDATE()
    ),

    CAST
    (
        (ABS(CHECKSUM(NEWID())) % 150000) + 5000
        AS DECIMAL(18,2)
    ),

    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'PEN'
        WHEN 1 THEN 'USD'
        ELSE 'EUR'
    END,

    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'ingresado'
        WHEN 1 THEN 'en evaluacion'
        WHEN 2 THEN 'aprobada'
        ELSE 'desestimado'
    END

FROM numeros n

JOIN asesores a
ON a.fila =
(
    ((n - 1) % (SELECT COUNT(*) FROM usuario WHERE rol = 'ASESOR')) + 1
);

--------------------------------------
-- CREDITOS
--------------------------------------

DELETE FROM creditos;

DBCC CHECKIDENT ('creditos', RESEED, 0);

;WITH numeros AS
(
    SELECT TOP 50
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)

INSERT INTO creditos
(
    solicitud_crediticia_id,
    cuenta_id,
    monto,
    plazo_meses,
    tea,
    tcea,
    valor_cuota,
    fecha_inicio,
    fecha_fin,
    fecha_desembolso,
    numero_credito,
    fecha_vencimiento,
    estado,
    saldo_credito,
    desgravamen
)

SELECT

    ((n - 1) % 75) + 1,

    ((n - 1) % 100) + 1,

    datos.monto_base,

    datos.plazo,

    datos.tea_valor,

    datos.tea_valor + 2.50,

    CAST
    (
        (datos.monto_base / datos.plazo)
        +
        ((datos.monto_base * (datos.tea_valor / 100.0)) / 12)
        AS DECIMAL(18,2)
    ),

    datos.fecha_ini,

    DATEADD(MONTH, datos.plazo, datos.fecha_ini),

    DATEADD(DAY, -2, datos.fecha_ini),

    800000 + n,

    DATEADD(MONTH, datos.plazo, datos.fecha_ini),

    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'desembolsado'
        WHEN 1 THEN 'vigente'
        WHEN 2 THEN 'Cancelado'
        ELSE 'refinanciado'
    END,

    CAST
    (
        datos.monto_base *
        (0.30 + (RAND(CHECKSUM(NEWID())) * 0.60))
        AS DECIMAL(18,2)
    ),

    CAST
    (
        datos.monto_base * 0.015
        AS DECIMAL(18,2)
    )

FROM numeros

CROSS APPLY
(
    SELECT

        CAST
        (
            ((ABS(CHECKSUM(NEWID())) % 250000) + 20000)
            AS DECIMAL(18,2)
        ) AS monto_base,

        CASE ABS(CHECKSUM(NEWID())) % 5
            WHEN 0 THEN 12
            WHEN 1 THEN 24
            WHEN 2 THEN 36
            WHEN 3 THEN 48
            ELSE 60
        END AS plazo,

        CAST
        (
            ((ABS(CHECKSUM(NEWID())) % 18) + 7)
            AS DECIMAL(10,2)
        ) AS tea_valor,

        CAST
        (
            DATEADD
            (
                DAY,
                -(ABS(CHECKSUM(NEWID())) % 700),
                GETDATE()
            )
            AS DATE
        ) AS fecha_ini

) datos;

select * from clientes;

--------------------------------------
-- CRONOGRAMAS
--------------------------------------

DELETE FROM cronogramas;

DBCC CHECKIDENT ('cronogramas', RESEED, 0);

INSERT INTO cronogramas
(
    credito_id,
    fecha_generacion,
    cantidad_cuotas,
    monto_total
)

SELECT

    c.id,

    DATEADD
    (
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 30),
        GETDATE()
    ),

    c.plazo_meses,

    CAST
    (
        c.valor_cuota * c.plazo_meses
        AS DECIMAL(18,2)
    )

FROM creditos c;


--------------------------------------
-- CUOTAS
--------------------------------------

DELETE FROM cuotas;

DBCC CHECKIDENT ('cuotas', RESEED, 0);

;WITH numeros AS
(
    SELECT TOP 60
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)

INSERT INTO cuotas
(
    cronograma_id,
    nro_cuota,
    fecha_vencimiento,
    monto,
    intereses,
    seguros,
    total_cuota,
    estado,
    tasa_mora,
    saldo_cuota
)

SELECT

    c.id,

    n.n,

    DATEADD
    (
        MONTH,
        n.n,
        c.fecha_generacion
    ),

    datos.monto_base,

    datos.interes_base,

    datos.seguro_base,

    -- total_cuota = monto + intereses + seguros
    CAST
    (
        datos.monto_base
        + datos.interes_base
        + datos.seguro_base
        AS DECIMAL(18,2)
    ),

    -- estados válidos según CHECK
    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'pagada'
        WHEN 1 THEN 'pendiente'
        WHEN 2 THEN 'pagada parcialmente'
        ELSE 'refinanciada'
    END,

    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 15) + 1)
        AS DECIMAL(10,2)
    ),

    -- saldo <= total_cuota
    CAST
    (
        (
            datos.monto_base
            + datos.interes_base
            + datos.seguro_base
        )
        *
        RAND(CHECKSUM(NEWID()))
        AS DECIMAL(18,2)
    )

FROM cronogramas c

JOIN creditos cr
ON cr.id = c.credito_id

CROSS JOIN numeros n

CROSS APPLY
(
    SELECT

        CAST
        (
            (cr.valor_cuota * 0.80)
            AS DECIMAL(18,2)
        ) AS monto_base,

        CAST
        (
            (cr.valor_cuota * 0.15)
            AS DECIMAL(18,2)
        ) AS interes_base,

        CAST
        (
            (cr.valor_cuota * 0.05)
            AS DECIMAL(18,2)
        ) AS seguro_base

) datos

WHERE n.n <= cr.plazo_meses;

select * from pagos;

--------------------------------------
-- PAGOS
--------------------------------------

DELETE FROM pagos;

DBCC CHECKIDENT ('pagos', RESEED, 0);

;WITH numeros AS
(
    SELECT TOP 120
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)

INSERT INTO pagos
(
    num_operacion,
    monto_pagado,
    fecha_pago,
    metodo_pago,
    observaciones
)

SELECT

    -- numero de operación único
    'PAGO-' + RIGHT('000000' + CAST(n AS VARCHAR), 6),

    -- monto pagado aleatorio
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 4500) + 150)
        AS DECIMAL(18,2)
    ),

    -- fecha de pago aleatoria
    DATEADD
    (
        DAY,
        -(ABS(CHECKSUM(NEWID())) % 365),
        GETDATE()
    ),

    -- métodos de pago variados
    CASE ABS(CHECKSUM(NEWID())) % 5
        WHEN 0 THEN 'Transferencia'
        WHEN 1 THEN 'Yape'
        WHEN 2 THEN 'Plin'
        WHEN 3 THEN 'Deposito'
        ELSE 'Debito automatico'
    END,

    -- observaciones variadas
    CASE ABS(CHECKSUM(NEWID())) % 5
        WHEN 0 THEN 'Pago realizado dentro de la fecha'
        WHEN 1 THEN 'Pago parcial de cuota'
        WHEN 2 THEN 'Cliente solicito refinanciamiento'
        WHEN 3 THEN 'Pago adelantado'
        ELSE 'Pago procesado correctamente'
    END

FROM numeros;

--------------------------------------
-- DETALLES_CUOTAS_PAGOS
--------------------------------------

DELETE FROM detalle_cuotas_pagos;

DBCC CHECKIDENT ('detalle_cuotas_pagos', RESEED, 0);

;WITH numeros AS
(
    SELECT TOP 120
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)

INSERT INTO detalle_cuotas_pagos
(
    cuota_id,
    pago_id,
    monto_cuota
)

SELECT

    -- cuota relacionada
    ((n - 1) % (SELECT COUNT(*) FROM cuotas)) + 1,

    -- pago relacionado
    ((n - 1) % (SELECT COUNT(*) FROM pagos)) + 1,

    -- monto tomado parcialmente de la cuota
    CAST
    (
        (
            SELECT TOP 1 total_cuota
            FROM cuotas q
            WHERE q.id =
            (
                ((n - 1) % (SELECT COUNT(*) FROM cuotas)) + 1
            )
        )
        *
        (0.50 + RAND(CHECKSUM(NEWID())) * 0.50)
        AS DECIMAL(18,2)
    )

FROM numeros;

SELECT * FROM evaluaciones_crediticias;

--------------------------------------
-- EVALUACIONES_CREDITICIAS
--------------------------------------

DELETE FROM evaluaciones_crediticias;

DBCC CHECKIDENT ('evaluaciones_crediticias', RESEED, 0);

;WITH numeros AS
(
    SELECT TOP 75
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
),
supervisores AS
(
    SELECT
        id,
        ROW_NUMBER() OVER(ORDER BY id) AS fila
    FROM usuario
    WHERE rol = 'SUPERVISOR'
)

INSERT INTO evaluaciones_crediticias
(
    solicitud_crediticia_id,
    supervisor_id,
    score_riesgo,
    nivel_endeudamiento,
    deuda_activa,
    deuda_activa_otras_entidades,
    linea_credito,
    linea_credito_otras_entidades,
    valor_patrimonio,
    ingresos_mensuales,
    resultado
)

SELECT

    -- solicitud
    ((n - 1) % 75) + 1,

    -- supervisor real
    s.id,

    -- score riesgo
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 500) + 300)
        AS DECIMAL(10,2)
    ),

    -- nivel endeudamiento %
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 70) + 10)
        AS DECIMAL(10,2)
    ),

    -- deuda activa
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 120000) + 5000)
        AS DECIMAL(18,2)
    ),

    -- deuda otras entidades
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 90000))
        AS DECIMAL(18,2)
    ),

    -- línea crédito
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 250000) + 10000)
        AS DECIMAL(18,2)
    ),

    -- línea crédito otras entidades
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 180000))
        AS DECIMAL(18,2)
    ),

    -- patrimonio
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 950000) + 50000)
        AS DECIMAL(18,2)
    ),

    -- ingresos mensuales
    CAST
    (
        ((ABS(CHECKSUM(NEWID())) % 18000) + 1500)
        AS DECIMAL(18,2)
    ),

    -- resultado evaluación
    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'Aprobado'
        WHEN 1 THEN 'Observado'
        WHEN 2 THEN 'Rechazado'
        ELSE 'En revision'
    END

FROM numeros n

JOIN supervisores s
ON s.fila =
(
    ((n - 1) % (SELECT COUNT(*) FROM usuario WHERE rol = 'SUPERVISOR')) + 1
);

select * from evaluaciones_crediticias;