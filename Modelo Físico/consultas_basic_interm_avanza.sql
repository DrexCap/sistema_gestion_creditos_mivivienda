
USE bd_sistema_creditos_mivivienda;
GO

-- 1. Mostrar todos los clientes naturales con su edad YES
SELECT
    CONCAT(apellido_paterno,' ',apellido_materno,' ',nombres) AS cliente,
    DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) AS edad
FROM personas_naturales;

-- 2. Mostrar todas las empresas activas
SELECT
    razon_social,
    sector_economico
FROM personas_juridicas
WHERE estado_empresa='Activo';

-- 3. Mostrar las cuentas con saldo mayor a 5000
SELECT
    num_cuenta,
    moneda,
    saldo
FROM cuentas
WHERE saldo > 5000;

-- 4. Mostrar solicitudes pendientes o en evaluacion
SELECT
    codigo_solicitud,
    monto_solicitado,
    estado
FROM solicitud_crediticia
WHERE estado='en evaluacion';

-- 5. Mostrar las cuotas cuyo saldo pendiente supere el promedio de saldos.

select id, cronograma_id, nro_cuota, saldo_cuota,(select AVG(saldo_cuota) monto from cuotas) as promedioSaldos
from cuotas
where estado ='pendiente' and saldo_cuota > (select AVG(saldo_cuota) monto from cuotas);

-- 6. Contar clientes por tipo 
SELECT
	CASE WHEN tipo_cliente = 'J' 
		THEN 'Cliente Juridico'
		ELSE 'Cliente Persona Natural' 
	END AS 'Tipo cliente', 
	COUNT(*) AS 'Num_clientes'
FROM clientes
GROUP BY tipo_cliente;

-- 7. Detectar clientes con sobreendeudamiento
SELECT
    sc.cliente_id,
    AVG(ec.nivel_endeudamiento) promedio_endeudamiento
FROM evaluaciones_crediticias ec
INNER JOIN solicitud_crediticia sc
    ON sc.id=ec.solicitud_crediticia_id
GROUP BY sc.cliente_id
HAVING AVG(ec.nivel_endeudamiento) > 60;

-- 8. Calcular el monto total solicitado por moneda en 2025 
SELECT
    moneda_solicitada,
    SUM(monto_solicitado) AS total,
    YEAR(fecha_solicitud) AS anio
FROM solicitud_crediticia
WHERE fecha_solicitud >= '2025-01-01' AND fecha_solicitud < '2026-01-01'
GROUP BY moneda_solicitada, YEAR(fecha_solicitud);

-- 9. Mostrar los clientes que poseen más de una cuenta en diferentes monedas.

select cli.id, cli.tipo_cliente, count(cuent.num_cuenta) NUM_CUENTAS, moneda
from clientes cli inner join cuentas cuent on cli.id = cuent.clientes_id 
group by cli.id,cli.tipo_cliente,cuent.moneda
having count(num_cuenta)>1

-- 10. Mostrar cuántas solicitudes tiene cada cliente 
SELECT
    c.id,
    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(nt.apellido_paterno, ' ', nt.apellido_materno, ' ', nt.nombres)
        ELSE pj.razon_social
    END AS cliente,
    COUNT(*) cantidad_solicitudes
FROM clientes c
LEFT JOIN solicitud_crediticia sc ON sc.cliente_id = c.id
LEFT JOIN personas_naturales nt ON nt.cliente_id=c.id 
LEFT JOIN personas_juridicas pj ON pj.cliente_id=c.id 
GROUP BY
    c.id,
    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(nt.apellido_paterno, ' ', nt.apellido_materno, ' ', nt.nombres)
        ELSE pj.razon_social
    END
ORDER BY cantidad_solicitudes DESC;

-- 11. Clientes cuyo score de riesgo supera el promedio general 
SELECT
    c.id,
    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(nt.apellido_paterno, ' ', nt.apellido_materno, ' ', nt.nombres)
        ELSE pj.razon_social
    END AS cliente,
    ec.score_riesgo,
    CAST(
        (
            SELECT AVG(score_riesgo)
            FROM evaluaciones_crediticias
        )
    AS DECIMAL(10,2)) AS promedio_general
FROM evaluaciones_crediticias ec
INNER JOIN solicitud_crediticia sc
    ON ec.solicitud_crediticia_id = sc.id
INNER JOIN clientes c
    ON sc.cliente_id = c.id
LEFT JOIN personas_naturales nt
    ON nt.cliente_id = c.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id
WHERE ec.score_riesgo >
(
    SELECT AVG(score_riesgo)
    FROM evaluaciones_crediticias
)
ORDER BY ec.score_riesgo DESC;

-- 12. Cuotas morosas por producto crediticio
SELECT
    pc.nombre,
    COUNT(*) cuotas_vencidas
FROM cuotas cu
INNER JOIN cronogramas cr
    ON cu.cronograma_id=cr.id
INNER JOIN creditos c
    ON cr.credito_id=c.id
INNER JOIN solicitud_crediticia sc
    ON c.solicitud_crediticia_id=sc.id
INNER JOIN productos_crediticios pc
    ON sc.producto_crediticio_id=pc.id
WHERE cu.estado='pendiente'
AND cu.fecha_vencimiento < GETDATE()
GROUP BY pc.nombre
ORDER BY cuotas_vencidas DESC;

-- 13. Mostrar qué porcentaje del valor de la vivienda está siendo financiado en cada solicitud de crédito. (1ra FORMA)
SELECT
    sc.codigo_solicitud,
    pc.nombre AS producto_crediticio,
    p.valor_comercial,
    sc.monto_solicitado,
    ROUND(
        (sc.monto_solicitado * 100.0)
        / p.valor_comercial
    ,2) AS porcentaje_financiado,
    CASE
        WHEN (sc.monto_solicitado * 100.0) / p.valor_comercial >= 90
            THEN 'Alto'
        WHEN (sc.monto_solicitado * 100.0) / p.valor_comercial >= 70
            THEN 'Medio'
        ELSE 'Bajo'
    END AS nivel_financiamiento
FROM solicitud_crediticia sc
INNER JOIN propiedad p
    ON sc.propiedad_id = p.id
INNER JOIN productos_crediticios pc
    ON sc.producto_crediticio_id = pc.id
ORDER BY porcentaje_financiado DESC;

-- 14. Identificar los créditos otorgados por encima del monto promedio de su producto financiero.
SELECT
    c.numero_credito,
    c.monto,
    pc.nombre
FROM creditos c
INNER JOIN solicitud_crediticia sc
    ON c.solicitud_crediticia_id=sc.id
INNER JOIN productos_crediticios pc
    ON pc.id=sc.producto_crediticio_id
WHERE c.monto >
(
    SELECT AVG(c2.monto)
    FROM creditos c2
    INNER JOIN solicitud_crediticia sc2
        ON c2.solicitud_crediticia_id=sc2.id
    WHERE sc2.producto_crediticio_id=pc.id
);

-- 15. Identificar los clientes que recibieron créditos por encima del promedio de su producto crediticio
SELECT
    c.numero_credito,
    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(nt.apellido_paterno, ' ', nt.apellido_materno, ' ', nt.nombres)
        ELSE pj.razon_social
    END AS cliente,
    pc.nombre AS producto_crediticio,
    c.monto,
    CAST(
        (
            SELECT AVG(c2.monto)
            FROM creditos c2
            INNER JOIN solicitud_crediticia sc2
                ON c2.solicitud_crediticia_id = sc2.id
            WHERE sc2.producto_crediticio_id = pc.id
        )
    AS DECIMAL(18,2)) AS promedio_producto
FROM creditos c
INNER JOIN solicitud_crediticia sc
    ON c.solicitud_crediticia_id = sc.id
INNER JOIN clientes cli
    ON sc.cliente_id = cli.id
INNER JOIN productos_crediticios pc
    ON sc.producto_crediticio_id = pc.id
LEFT JOIN personas_naturales nt
    ON nt.cliente_id = cli.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = cli.id
WHERE c.monto >
(
    SELECT AVG(c2.monto)
    FROM creditos c2
    INNER JOIN solicitud_crediticia sc2
        ON c2.solicitud_crediticia_id = sc2.id
    WHERE sc2.producto_crediticio_id = pc.id
)
ORDER BY c.monto DESC;

-- 16. Mostrar el cliente con el mayor monto total solicitado.
select c.tipo_cliente, max(monto_solicitado) as MontoMayor 
from clientes c 
inner join solicitud_crediticia sc on c.id=sc.cliente_id
group by c.tipo_cliente

SELECT c.*, s.monto_solicitado,
CASE 
	WHEN pj.razon_social IS NULL 
		THEN CONCAT(nt.apellido_paterno,' ', nt.apellido_materno, ' ', nt.nombres)
	ELSE pj.razon_social END AS 'cliente'
FROM clientes c
INNER JOIN solicitud_crediticia s ON s.cliente_id=c.id
LEFT JOIN personas_naturales nt ON nt.cliente_id=c.id AND c.tipo_cliente='N'
LEFT JOIN personas_juridicas pj ON pj.cliente_id=c.id AND c.tipo_cliente='J'
WHERE
s.monto_solicitado IN 
	(SELECT MAX(s1.monto_solicitado) from clientes a inner join solicitud_crediticia s1 on a.id=s1.cliente_id group by a.tipo_cliente)
AND (pj.id IS NOT NULL OR nt.id IS NOT NULL);

-- 17. Determinar el nivel de endeudamiento de los clientes. (Mide la capacidad de pago actual)
/*
Fórmula:
    (deuda_activa / ingresos_mensuales) * 100
Clasificar:
    Bajo
    Medio
    Alto

Esta consulta responde una sola pregunta:
¿Qué porcentaje de sus ingresos ya está comprometido por deudas?
*/
;WITH endeudamiento AS
(
    SELECT
        ec.id,
        sc.cliente_id,
        ec.ingresos_mensuales,
        ec.deuda_activa,
        CAST(
        (
            (ec.deuda_activa * 100.0)
            / ec.ingresos_mensuales
        )
        AS DECIMAL(10,2)) indice_endeudamiento
    FROM evaluaciones_crediticias ec
    INNER JOIN solicitud_crediticia sc
        ON ec.solicitud_crediticia_id = sc.id
)
SELECT *,
CASE
    WHEN indice_endeudamiento < 30
        THEN 'Bajo'
    WHEN indice_endeudamiento < 60
        THEN 'Medio'
    ELSE 'Alto'
END nivel
FROM endeudamiento;

-- 18. Construir un score crediticio simplificado:
/*
    Determinar el nivel de riesgo de las solicitudes de crédito hipotecario mediante un score crediticio 
    simplificado que considere el historial financiero, la capacidad de ingresos y el nivel 
    de endeudamiento del solicitante.

    score_final = (score_riesgo * 0.5)
    +
    ((ingresos_mensuales / 1000) * 0.3)
    -
    (nivel_endeudamiento * 0.2)

    Clasificar el resultado en:
    - Bajo Riesgo
    - Riesgo Medio
    - Alto Riesgo

    Esta consulta responde una sola pregunta:
    ¿Qué tan riesgosa es una solicitud de crédito considerando el perfil financiero del solicitante?
*/
;WITH scores AS
(
    SELECT 
    id, solicitud_crediticia_id, score_riesgo, ingresos_mensuales, nivel_endeudamiento,
    (score_riesgo * 0.5)+((ingresos_mensuales / 1000) * 0.3)-(nivel_endeudamiento * 0.2) AS 'Score_final'
    FROM evaluaciones_crediticias
)
SELECT sc.*,
    CASE 
    WHEN Score_final<200 THEN 'Alto Riesgo'
    WHEN Score_final<400 THEN 'Riesgo Medio'
    ELSE 'Riesgo Bajo' END AS 'clasificacion'
FROM solicitud_crediticia s
INNER JOIN scores sc ON sc.solicitud_crediticia_id=s.id;

-- 19. Construir un indicador de incumplimiento simplificado 
/*
Índice Integral de Riesgo Hipotecario = (score_riesgo * 0.4) +
    ((ingresos_mensuales/1000) * 0.3)
    -
    (nivel_endeudamiento * 0.2)
    -
    (porcentaje_financiado * 0.1)

Donde: porcentaje_financiado = (monto_solicitado / valor_comercial) * 100

Esta consulta responde algo más amplio:
¿Qué tan riesgosa es esta solicitud hipotecaria considerando al cliente y al inmueble?

Analiza simultáneamente:
- Score de riesgo
- Ingresos
- Endeudamiento
- Valor de la propiedad
- Monto solicitado
*/
;WITH riesgo_hipotecario AS
(
    SELECT
        sc.codigo_solicitud,
        ec.score_riesgo,
        ec.ingresos_mensuales,
        ec.nivel_endeudamiento,
        p.valor_comercial,
        sc.monto_solicitado,

        CAST(
        (
            (sc.monto_solicitado * 100.0)
            / p.valor_comercial
        )
        AS DECIMAL(10,2)) AS porcentaje_financiado,

        CAST(
        (
            (ec.score_riesgo * 0.4)
            +
            ((ec.ingresos_mensuales / 1000.0) * 0.3)
            -
            (ec.nivel_endeudamiento * 0.2)
            -
            (
                ((sc.monto_solicitado * 100.0) / p.valor_comercial) * 0.1
            )
        )
        AS DECIMAL(10,2)) AS indice_riesgo

    FROM evaluaciones_crediticias ec
    INNER JOIN solicitud_crediticia sc
        ON ec.solicitud_crediticia_id = sc.id
    INNER JOIN propiedad p
        ON sc.propiedad_id = p.id
)
SELECT *,
CASE
    WHEN indice_riesgo >= 300
        THEN 'Riesgo Bajo'
    WHEN indice_riesgo >= 150
        THEN 'Riesgo Medio'
    ELSE 'Riesgo Alto'
END AS clasificacion
FROM riesgo_hipotecario
ORDER BY indice_riesgo DESC;


-- 20. Calcular qué porcentaje del valor de la propiedad representa el monto solicitado. (2da FORMA) EXTRA
/*
Clasificar:
    Financiamiento Bajo (< 60%)
    Financiamiento Medio (60%-80%)
    Financiamiento Alto (> 80%)
*/
;WITH financiamiento AS
(
    SELECT
        sc.id,
        sc.codigo_solicitud,
        pc.nombre AS producto,
        p.valor_comercial,
        sc.monto_solicitado,
        ROUND(
            (sc.monto_solicitado * 100.0)
            / p.valor_comercial
        ,2) porcentaje_financiado
    FROM solicitud_crediticia sc
    INNER JOIN propiedad p
        ON sc.propiedad_id = p.id
    INNER JOIN productos_crediticios pc
        ON sc.producto_crediticio_id = pc.id
)
SELECT *,
CASE
    WHEN porcentaje_financiado < 60
        THEN 'Financiamiento Bajo'
    WHEN porcentaje_financiado <= 80
        THEN 'Financiamiento Medio'
    ELSE 'Financiamiento Alto'
END AS nivel_financiamiento
FROM financiamiento
ORDER BY porcentaje_financiado DESC;









