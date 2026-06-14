
CREATE DATABASE DW_CREDITOS_MIVIVIENDA;
GO

USE DW_CREDITOS_MIVIVIENDA;
GO

CREATE TABLE dim_tiempo
(
    tiempo_key INT PRIMARY KEY,
    fecha DATE,
    dia INT,
    mes INT,
    nombre_mes VARCHAR(20),
    trimestre INT,
    anio INT
);

CREATE TABLE dim_cliente
(
    cliente_key INT IDENTITY PRIMARY KEY,
    cliente_id INT,
    tipo_cliente VARCHAR(20),
    nombre_cliente VARCHAR(150)
);

CREATE TABLE dim_producto
(
    producto_key INT IDENTITY PRIMARY KEY,
    producto_id INT,
    nombre_producto VARCHAR(100)
);

CREATE TABLE dim_propiedad
(
    propiedad_key INT IDENTITY PRIMARY KEY,
    propiedad_id INT,
    tipo_propiedad VARCHAR(50),
    distrito VARCHAR(100),
    valor_comercial DECIMAL(18,2)
);

CREATE TABLE dim_riesgo
(
    riesgo_key INT IDENTITY PRIMARY KEY,
    score_riesgo INT,
    nivel_endeudamiento DECIMAL(10,2),
    clasificacion_riesgo VARCHAR(30)
);

CREATE TABLE fact_creditos
(
    fact_id INT IDENTITY PRIMARY KEY,

    cliente_key INT NOT NULL,
    producto_key INT NOT NULL,
    propiedad_key INT NOT NULL,
    tiempo_key INT NOT NULL,
    riesgo_key INT NOT NULL,

    monto_credito DECIMAL(18,2),
    saldo_credito DECIMAL(18,2),
    tea DECIMAL(10,2),
    tcea DECIMAL(10,2),
    plazo_meses INT,
    porcentaje_financiado DECIMAL(10,2),

    CONSTRAINT fk_fact_cliente
        FOREIGN KEY (cliente_key)
        REFERENCES dim_cliente(cliente_key),

    CONSTRAINT fk_fact_producto
        FOREIGN KEY (producto_key)
        REFERENCES dim_producto(producto_key),

    CONSTRAINT fk_fact_propiedad
        FOREIGN KEY (propiedad_key)
        REFERENCES dim_propiedad(propiedad_key),

    CONSTRAINT fk_fact_tiempo
        FOREIGN KEY (tiempo_key)
        REFERENCES dim_tiempo(tiempo_key),

    CONSTRAINT fk_fact_riesgo
        FOREIGN KEY (riesgo_key)
        REFERENCES dim_riesgo(riesgo_key)
);

ALTER TABLE dim_cliente
ADD CONSTRAINT chk_tipo_cliente_dw
CHECK (tipo_cliente IN ('Natural','Juridico'));
GO

ALTER TABLE dim_riesgo
ADD CONSTRAINT chk_clasificacion_riesgo
CHECK (clasificacion_riesgo IN ('Bajo','Medio','Alto'));
GO

ALTER TABLE dim_tiempo
ADD CONSTRAINT chk_mes
CHECK (mes BETWEEN 1 AND 12);
GO

ALTER TABLE dim_tiempo
ADD CONSTRAINT chk_anio
CHECK (anio BETWEEN 2020 AND 2050);
GO

ALTER TABLE fact_creditos
ADD CONSTRAINT chk_monto_credito
CHECK (monto_credito > 0);
GO

ALTER TABLE fact_creditos
ADD CONSTRAINT chk_saldo_credito
CHECK (saldo_credito >= 0);
GO

INSERT INTO dim_cliente
(cliente_id, tipo_cliente, nombre_cliente)
VALUES
(1,'Natural','Juan Perez Gomez'),
(2,'Natural','Maria Torres Diaz'),
(3,'Natural','Luis Ramirez Soto'),
(11,'Juridico','Constructora Horizonte SA'),
(12,'Juridico','Tecnologias Andinas SAC');
GO

INSERT INTO dim_producto
(producto_id, nombre_producto)
VALUES
(1,'Nuevo Credito MiVivienda'),
(2,'Techo Propio'),
(3,'MiTerreno'),
(4,'Credito Hipotecario Tradicional');
GO

INSERT INTO dim_propiedad
(propiedad_id, tipo_propiedad, distrito, valor_comercial)
VALUES
(1,'Departamento','San Borja',350000),
(2,'Casa','Surco',480000),
(3,'Departamento','Miraflores',620000),
(4,'Casa','La Molina',800000),
(5,'Departamento','San Miguel',290000);
GO

INSERT INTO dim_tiempo
(tiempo_key, fecha, dia, mes, nombre_mes, trimestre, anio)
VALUES
(20250115,'2025-01-15',15,1,'Enero',1,2025),
(20250210,'2025-02-10',10,2,'Febrero',1,2025),
(20250305,'2025-03-05',5,3,'Marzo',1,2025),
(20250420,'2025-04-20',20,4,'Abril',2,2025),
(20250518,'2025-05-18',18,5,'Mayo',2,2025);
GO

INSERT INTO dim_riesgo
(score_riesgo, nivel_endeudamiento, clasificacion_riesgo)
VALUES
(780,25,'Bajo'),
(650,40,'Medio'),
(520,55,'Medio'),
(450,70,'Alto'),
(820,18,'Bajo');
GO

INSERT INTO fact_creditos
(
cliente_key,
producto_key,
propiedad_key,
tiempo_key,
riesgo_key,
monto_credito,
saldo_credito,
tea,
tcea,
plazo_meses,
porcentaje_financiado
)
VALUES
(1,1,1,20250115,1,250000,230000,8.50,9.20,240,71.43),

(2,2,2,20250210,2,300000,285000,9.00,9.75,180,62.50),

(3,1,3,20250305,3,500000,470000,8.75,9.50,300,80.65),

(4,4,4,20250420,4,700000,690000,10.20,11.00,360,87.50),

(5,3,5,20250518,5,200000,185000,7.95,8.60,120,68.97);
GO

-- CONSULTA ESTRELLA
SELECT
    dc.nombre_cliente,
    dp.nombre_producto,
    dpr.distrito,
    dt.nombre_mes,
    dr.clasificacion_riesgo,
    fc.monto_credito
FROM fact_creditos fc
INNER JOIN dim_cliente dc
    ON fc.cliente_key = dc.cliente_key
INNER JOIN dim_producto dp
    ON fc.producto_key = dp.producto_key
INNER JOIN dim_propiedad dpr
    ON fc.propiedad_key = dpr.propiedad_key
INNER JOIN dim_tiempo dt
    ON fc.tiempo_key = dt.tiempo_key
INNER JOIN dim_riesgo dr
    ON fc.riesgo_key = dr.riesgo_key;