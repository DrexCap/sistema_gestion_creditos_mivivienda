
-----------------------------------------------------------
-- EJERCICIO PENDIENTES - AVANZADOS
-----------------------------------------------------------

-- Mostrar el crédito con la mayor cantidad de cuotas pendientes.
SELECT TOP 1
    c.id AS credito_id,
    c.numero_credito,
    COUNT(*) AS cuotas_pendientes
FROM creditos c
INNER JOIN cuotas cu
    ON cu.credito_id = c.id
WHERE cu.estado IN ('pendiente', 'pagada parcialmente')
GROUP BY
    c.id,
    c.numero_credito
ORDER BY cuotas_pendientes DESC;

--Obtener el ranking de clientes según monto total desembolsado.
SELECT
    RANK() OVER (
        ORDER BY SUM(cr.monto) DESC
    ) AS ranking,
    cl.id AS cliente_id,
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres,' ',
            pn.apellido_paterno,' ',
            pn.apellido_materno
        )
    END AS cliente,
    SUM(cr.monto) AS monto_total_desembolsado
FROM clientes cl
INNER JOIN solicitudes s
    ON s.cliente_id = cl.id
INNER JOIN evaluaciones_crediticias ec
    ON ec.solicitud_id = s.id
INNER JOIN creditos cr
    ON cr.evaluacion_crediticia_id = ec.id
LEFT JOIN personas_naturales pn
    ON pn.cliente_id = cl.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = cl.id
GROUP BY
    cl.id,
    pj.razon_social,
    pn.nombres,
    pn.apellido_paterno,
    pn.apellido_materno
ORDER BY ranking;

--Mostrar el porcentaje de endeudamiento promedio por producto crediticio.
SELECT
    pc.id,
    pc.nombre AS producto_crediticio,
    CAST(
        AVG(
            (ec.deuda_activa * 100.0)
            / NULLIF(ec.ingresos_mensuales,0)
        )
    AS DECIMAL(10,2)) AS promedio_endeudamiento
FROM productos_crediticios pc
INNER JOIN solicitudes s
    ON s.producto_crediticio_id = pc.id
INNER JOIN evaluaciones_crediticias ec
    ON ec.solicitud_id = s.id
GROUP BY
    pc.id,
    pc.nombre
ORDER BY promedio_endeudamiento DESC;

--Encontrar clientes que nunca solicitaron un crédito.
SELECT
    cl.id,
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres,' ',
            pn.apellido_paterno,' ',
            pn.apellido_materno
        )
    END AS cliente
FROM clientes cl
LEFT JOIN solicitudes s
    ON s.cliente_id = cl.id
LEFT JOIN personas_naturales pn
    ON pn.cliente_id = cl.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = cl.id
WHERE s.id IS NULL;

--Mostrar los clientes cuyo patrimonio supere tres veces sus ingresos anuales.
;WITH ultima_evaluacion AS
(
    SELECT
        cl.id AS cliente_id,
        CASE
            WHEN pj.razon_social IS NOT NULL
                THEN pj.razon_social
            ELSE CONCAT(
                pn.nombres,' ',
                pn.apellido_paterno,' ',
                pn.apellido_materno
            )
        END AS cliente,
        ec.valor_patrimonio,
        ec.ingresos_mensuales,
        ROW_NUMBER() OVER(
            PARTITION BY cl.id
            ORDER BY s.fecha_solicitud DESC
        ) AS rn
    FROM clientes cl
    INNER JOIN solicitudes s
        ON s.cliente_id = cl.id
    INNER JOIN evaluaciones_crediticias ec
        ON ec.solicitud_id = s.id
    LEFT JOIN personas_naturales pn
        ON pn.cliente_id = cl.id
    LEFT JOIN personas_juridicas pj
        ON pj.cliente_id = cl.id
)
SELECT
    cliente_id,
    cliente,
    valor_patrimonio,
    ingresos_mensuales,
    ingresos_mensuales * 12 AS ingresos_anuales
FROM ultima_evaluacion
WHERE rn = 1
    AND valor_patrimonio >
        (ingresos_mensuales * 12 * 3)
ORDER BY valor_patrimonio DESC;

--Calcular la mora potencial por crédito:
----Saldo pendiente + intereses
SELECT
    c.numero_credito,
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres,' ',
            pn.apellido_paterno,' ',
            pn.apellido_materno
        )
    END AS cliente,
    CAST(
        SUM(cu.saldo_cuota + cu.intereses)
    AS DECIMAL(18,2)) AS mora_potencial
FROM creditos c
INNER JOIN evaluaciones_crediticias ec
    ON ec.id = c.evaluacion_crediticia_id
INNER JOIN solicitudes s
    ON s.id = ec.solicitud_id
INNER JOIN clientes cl
    ON cl.id = s.cliente_id
INNER JOIN cuotas cu
    ON cu.credito_id = c.id
LEFT JOIN personas_naturales pn
    ON pn.cliente_id = cl.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = cl.id
WHERE cu.estado IN ('pendiente', 'pagada parcialmente')
GROUP BY
    c.numero_credito,
    pj.razon_social,
    pn.nombres,
    pn.apellido_paterno,
    pn.apellido_materno
ORDER BY mora_potencial DESC;

--Mostrar los créditos cuyo saldo actual represente más del 50% del monto inicial.
SELECT
    id AS credito_id,
    numero_credito,
    monto,
    saldo_credito,
    CAST(
        (saldo_credito * 100.0) / monto
    AS DECIMAL(10,2)) AS porcentaje_saldo
FROM creditos
WHERE (saldo_credito * 100.0) / monto > 50
ORDER BY porcentaje_saldo DESC;

--Mostrar las cuotas pagadas fuera de su fecha de vencimiento.
SELECT
    cu.id AS cuota_id,
    cr.numero_credito,
    cu.num_cuota,
    cu.fecha_vencimiento,
    p.fecha_pago,
    DATEDIFF(
        DAY,
        cu.fecha_vencimiento,
        p.fecha_pago
    ) AS dias_retraso,
    dcp.monto_pagado
FROM cuotas cu
INNER JOIN creditos cr
    ON cr.id = cu.credito_id
INNER JOIN detalle_cuotas_pagos dcp
    ON dcp.cuota_id = cu.id
INNER JOIN pagos p
    ON p.id = dcp.pago_id
WHERE p.fecha_pago > cu.fecha_vencimiento
ORDER BY dias_retraso DESC;

-----------------------------------------------------------
-- EJERCICIO PENDIENTES - EXPERTOS
-----------------------------------------------------------

/*
===========================================================
EJERCICIO 2
===========================================================

Calcular la tasa de aprobación de solicitudes.

Formula:

(Aprobadas / Total Solicitudes) * 100

Mostrar:

- Total solicitudes
- Total aprobadas
- Porcentaje de aprobación
*/
SELECT
    COUNT(*) AS total_solicitudes,

    SUM(
        CASE
            WHEN estado = 'aprobada'
            THEN 1
            ELSE 0
        END
    ) AS total_aprobadas,

    CAST(
        (
            SUM(
                CASE
                    WHEN estado = 'aprobada'
                    THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / COUNT(*)
    AS DECIMAL(10,2)) AS porcentaje_aprobacion
FROM solicitudes;


/*
===========================================================
EJERCICIO 3
===========================================================

Calcular el ratio de morosidad.

Formula:

(Cuotas Pendientes / Total Cuotas) * 100

Mostrar:

- Total cuotas
- Cuotas pendientes
- Ratio de morosidad
*/
SELECT
    COUNT(*) AS total_cuotas,

    SUM(
        CASE
            WHEN estado IN ('pendiente','pagada parcialmente')
            THEN 1
            ELSE 0
        END
    ) AS cuotas_pendientes,

    CAST(
        (
            SUM(
                CASE
                    WHEN estado IN ('pendiente','pagada parcialmente')
                    THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / COUNT(*)
    AS DECIMAL(10,2)) AS ratio_morosidad
FROM cuotas;


/*
===========================================================
EJERCICIO 4
===========================================================

Identificar clientes de alto riesgo.

Condiciones:

- Score de riesgo menor a 500
- Nivel de endeudamiento mayor a 70
- Deuda activa en otras entidades mayor a 20,000

Mostrar:

- Cliente
- Score
- Nivel endeudamiento
- Deuda externa
*/
;WITH clientes_riesgo AS
(
    SELECT
        cl.id AS cliente_id,

        CASE
            WHEN pj.razon_social IS NOT NULL
                THEN pj.razon_social
            ELSE CONCAT(
                pn.nombres,' ',
                pn.apellido_paterno,' ',
                pn.apellido_materno
            )
        END AS cliente,

        ec.score_riesgo,
        ec.nivel_endeudamiento,
        ec.deuda_activa_otras_entidades
    FROM clientes cl
    INNER JOIN solicitudes s
        ON s.cliente_id = cl.id
    INNER JOIN evaluaciones_crediticias ec
        ON ec.solicitud_id = s.id
    LEFT JOIN personas_naturales pn
        ON pn.cliente_id = cl.id
    LEFT JOIN personas_juridicas pj
        ON pj.cliente_id = cl.id
)
SELECT *
FROM clientes_riesgo
WHERE score_riesgo < 500
    AND nivel_endeudamiento > 70
    AND deuda_activa_otras_entidades > 20000
ORDER BY score_riesgo;


/*
===========================================================
EJERCICIO 5
===========================================================

Construir un ranking de exposición crediticia.

Formula:

Exposición =
Saldo Crédito
+
Deuda Activa
+
Deuda Activa Otras Entidades

Ordenar de mayor a menor.
*/
;WITH exposicion_crediticia AS
(
    SELECT
        cl.id AS cliente_id,

        CASE
            WHEN pj.razon_social IS NOT NULL
                THEN pj.razon_social
            ELSE CONCAT(
                pn.nombres,' ',
                pn.apellido_paterno,' ',
                pn.apellido_materno
            )
        END AS cliente,

        c.numero_credito,

        c.saldo_credito,
        ec.deuda_activa,
        ec.deuda_activa_otras_entidades,

        (
            c.saldo_credito
            + ec.deuda_activa
            + ec.deuda_activa_otras_entidades
        ) AS exposicion_total

    FROM creditos c
    INNER JOIN evaluaciones_crediticias ec
        ON ec.id = c.evaluacion_crediticia_id
    INNER JOIN solicitudes s
        ON s.id = ec.solicitud_id
    INNER JOIN clientes cl
        ON cl.id = s.cliente_id
    LEFT JOIN personas_naturales pn
        ON pn.cliente_id = cl.id
    LEFT JOIN personas_juridicas pj
        ON pj.cliente_id = cl.id
)
SELECT
    DENSE_RANK() OVER(
        ORDER BY exposicion_total DESC
    ) AS ranking,
    *
FROM exposicion_crediticia
ORDER BY exposicion_total DESC;

/*
===========================================================
EJERCICIO 7
===========================================================

Calcular el ingreso mensual recomendado.

Formula:

Ingreso Recomendado =
Total Cuotas Activas * 3

Mostrar:

- Cliente
- Cuotas activas
- Ingreso recomendado
*/
;WITH cuotas_activas AS
(
    SELECT
        cl.id AS cliente_id,

        CASE
            WHEN pj.razon_social IS NOT NULL
                THEN pj.razon_social
            ELSE CONCAT(
                pn.nombres,' ',
                pn.apellido_paterno,' ',
                pn.apellido_materno
            )
        END AS cliente,

        SUM(cu.total_cuota) AS total_cuotas_activas
    FROM clientes cl
    INNER JOIN solicitudes s
        ON s.cliente_id = cl.id
    INNER JOIN evaluaciones_crediticias ec
        ON ec.solicitud_id = s.id
    INNER JOIN creditos c
        ON c.evaluacion_crediticia_id = ec.id
    INNER JOIN cuotas cu
        ON cu.credito_id = c.id
    LEFT JOIN personas_naturales pn
        ON pn.cliente_id = cl.id
    LEFT JOIN personas_juridicas pj
        ON pj.cliente_id = cl.id
    WHERE cu.estado IN ('pendiente','pagada parcialmente')
    GROUP BY
        cl.id,
        pj.razon_social,
        pn.nombres,
        pn.apellido_paterno,
        pn.apellido_materno
)
SELECT
    cliente,
    total_cuotas_activas,
    CAST(
        total_cuotas_activas * 3
    AS DECIMAL(18,2)) AS ingreso_recomendado
FROM cuotas_activas
ORDER BY ingreso_recomendado DESC;

/*
===========================================================
EJERCICIO 8
===========================================================

Calcular la concentración de cartera por producto.

Formula:

(Monto Producto / Total Cartera) * 100

Mostrar:

- Producto
- Total desembolsado
- Participación %
*/
SELECT
    pc.nombre AS producto,
    SUM(c.monto) AS total_desembolsado,

    CAST(
        (
            SUM(c.monto) * 100.0
        ) /
        SUM(SUM(c.monto)) OVER ()
    AS DECIMAL(10,2)) AS participacion_porcentaje

FROM productos_crediticios pc
INNER JOIN solicitudes s
    ON s.producto_crediticio_id = pc.id
INNER JOIN evaluaciones_crediticias ec
    ON ec.solicitud_id = s.id
INNER JOIN creditos c
    ON c.evaluacion_crediticia_id = ec.id
GROUP BY
    pc.nombre
ORDER BY participacion_porcentaje DESC;

/*
===========================================================
EJERCICIO 9
===========================================================

Calcular el porcentaje de utilización de línea.

Formula:

(Deuda Activa / Línea Crédito) * 100

Mostrar:

- Cliente
- Línea de crédito
- Deuda activa
- Utilización %
*/
SELECT
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres, ' ',
            pn.apellido_paterno, ' ',
            pn.apellido_materno
        )
    END AS cliente,

    ec.linea_credito,
    ec.deuda_activa,

    CAST(
        ec.deuda_activa * 100.0
        / NULLIF(ec.linea_credito, 0)
    AS DECIMAL(10,2)) AS utilizacion_porcentaje

FROM evaluaciones_crediticias ec
INNER JOIN solicitudes s
    ON s.id = ec.solicitud_id
INNER JOIN clientes c
    ON c.id = s.cliente_id
LEFT JOIN personas_naturales pn
    ON pn.cliente_id = c.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id

ORDER BY utilizacion_porcentaje DESC;

/*
===========================================================
EJERCICIO 10
===========================================================

Detectar clientes potencialmente sobreendeudados.

Formula:

(Deuda Total / Ingresos Mensuales)

Considerar:

Deuda Total =
Deuda Activa
+
Deuda Activa Otras Entidades

Mostrar únicamente clientes cuyo ratio sea mayor a 0.50
*/
SELECT
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres, ' ',
            pn.apellido_paterno, ' ',
            pn.apellido_materno
        )
    END AS cliente,

    ec.ingresos_mensuales,

    (ec.deuda_activa + ec.deuda_activa_otras_entidades) AS deuda_total,

    CAST(
        (
            ec.deuda_activa
            + ec.deuda_activa_otras_entidades
        ) * 1.0
        / NULLIF(ec.ingresos_mensuales, 0)
    AS DECIMAL(10,2)) AS ratio_endeudamiento

FROM evaluaciones_crediticias ec
INNER JOIN solicitudes s
    ON s.id = ec.solicitud_id
INNER JOIN clientes c
    ON c.id = s.cliente_id
LEFT JOIN personas_naturales pn
    ON pn.cliente_id = c.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id

WHERE
    (
        ec.deuda_activa
        + ec.deuda_activa_otras_entidades
    ) * 1.0
    / NULLIF(ec.ingresos_mensuales, 0) > 0.50

ORDER BY ratio_endeudamiento DESC;

/*
===========================================================
EJERCICIO 11
===========================================================

Construir un ranking de empresas por exposición financiera.

Considerar solamente personas jurídicas.

Ordenar por:

- Saldo crédito
- Deuda activa
- Deuda externa
*/
SELECT
    DENSE_RANK() OVER (
        ORDER BY
            c.saldo_credito DESC,
            ec.deuda_activa DESC,
            ec.deuda_activa_otras_entidades DESC
    ) AS ranking,

    pj.ruc,
    pj.razon_social,

    c.numero_credito,
    c.saldo_credito,
    ec.deuda_activa,
    ec.deuda_activa_otras_entidades,

    CAST(
        c.saldo_credito
        + ec.deuda_activa
        + ec.deuda_activa_otras_entidades
    AS DECIMAL(18,2)) AS exposicion_financiera

FROM personas_juridicas pj
INNER JOIN clientes cl
    ON cl.id = pj.cliente_id
INNER JOIN solicitudes s
    ON s.cliente_id = cl.id
INNER JOIN evaluaciones_crediticias ec
    ON ec.solicitud_id = s.id
INNER JOIN creditos c
    ON c.evaluacion_crediticia_id = ec.id

ORDER BY
    c.saldo_credito DESC,
    ec.deuda_activa DESC,
    ec.deuda_activa_otras_entidades DESC;

/*
===========================================================
EJERCICIO 12
===========================================================

Encontrar clientes que tienen cuentas bancarias
pero nunca han solicitado créditos.

Mostrar:

- Cliente
- Número de cuentas
*/
SELECT
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres, ' ',
            pn.apellido_paterno, ' ',
            pn.apellido_materno
        )
    END AS cliente,

    COUNT(DISTINCT cc.cuenta_id) AS numero_cuentas

FROM clientes c
INNER JOIN cuentas_clientes cc
    ON cc.cliente_id = c.id

LEFT JOIN personas_naturales pn
    ON pn.cliente_id = c.id

LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id

LEFT JOIN solicitudes s
    ON s.cliente_id = c.id

WHERE s.id IS NULL

GROUP BY
    pj.razon_social,
    pn.nombres,
    pn.apellido_paterno,
    pn.apellido_materno

ORDER BY numero_cuentas DESC, cliente;

/*
===========================================================
EJERCICIO 13
===========================================================

Encontrar clientes que poseen créditos
pero no registran ningún pago.

Mostrar:

- Cliente
- Número de crédito
- Monto del crédito
*/
SELECT
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres, ' ',
            pn.apellido_paterno, ' ',
            pn.apellido_materno
        )
    END AS cliente,

    c.numero_credito,
    c.monto

FROM creditos c
INNER JOIN evaluaciones_crediticias ec
    ON ec.id = c.evaluacion_crediticia_id
INNER JOIN solicitudes s
    ON s.id = ec.solicitud_id
INNER JOIN clientes cl
    ON cl.id = s.cliente_id

LEFT JOIN personas_naturales pn
    ON pn.cliente_id = cl.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = cl.id

WHERE NOT EXISTS
(
    SELECT 1
    FROM cuotas cu
    INNER JOIN detalle_cuotas_pagos dcp
        ON dcp.cuota_id = cu.id
    WHERE cu.credito_id = c.id
)

ORDER BY c.monto DESC;

/*
===========================================================
EJERCICIO 14
===========================================================

Detectar anomalías crediticias.

Regla:

Monto Crédito > Valor Patrimonio

Mostrar:

- Cliente
- Patrimonio
- Monto crédito
*/
SELECT
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres, ' ',
            pn.apellido_paterno, ' ',
            pn.apellido_materno
        )
    END AS cliente,

    ec.valor_patrimonio,
    c.monto AS monto_credito,

    CAST(
        c.monto - ec.valor_patrimonio
    AS DECIMAL(18,2)) AS exceso_financiamiento

FROM creditos c
INNER JOIN evaluaciones_crediticias ec
    ON ec.id = c.evaluacion_crediticia_id
INNER JOIN solicitudes s
    ON s.id = ec.solicitud_id
INNER JOIN clientes cl
    ON cl.id = s.cliente_id

LEFT JOIN personas_naturales pn
    ON pn.cliente_id = cl.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = cl.id

WHERE c.monto > ec.valor_patrimonio

ORDER BY exceso_financiamiento DESC;

/*
===========================================================
EJERCICIO 15
===========================================================

Identificar clientes con patrimonio comprometido.

Formula:

Patrimonio Neto Simulado =
Valor Patrimonio
-
(Deuda Activa + Deuda Externa)

Mostrar los clientes cuyo patrimonio neto
sea negativo.
*/
SELECT
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres, ' ',
            pn.apellido_paterno, ' ',
            pn.apellido_materno
        )
    END AS cliente,

    ec.valor_patrimonio,
    ec.deuda_activa,
    ec.deuda_activa_otras_entidades,

    CAST(
        ec.valor_patrimonio
        - (
            ec.deuda_activa
            + ec.deuda_activa_otras_entidades
        )
    AS DECIMAL(18,2)) AS patrimonio_neto_simulado

FROM evaluaciones_crediticias ec
INNER JOIN solicitudes s
    ON s.id = ec.solicitud_id
INNER JOIN clientes cl
    ON cl.id = s.cliente_id

LEFT JOIN personas_naturales pn
    ON pn.cliente_id = cl.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = cl.id

WHERE
    ec.valor_patrimonio
    - (
        ec.deuda_activa
        + ec.deuda_activa_otras_entidades
    ) < 0

ORDER BY patrimonio_neto_simulado ASC;

/*
===========================================================
EJERCICIO 16
===========================================================

Construir un Dashboard General utilizando
una única consulta.

Indicadores requeridos:

- Total Clientes
- Total Solicitudes
- Total Créditos
- Total Desembolsado
- Total Pagos
- Total Cuotas
- Ratio Morosidad
*/
WITH kpi_clientes AS
(
    SELECT COUNT(*) AS total_clientes
    FROM clientes
),
kpi_solicitudes AS
(
    SELECT COUNT(*) AS total_solicitudes
    FROM solicitudes
),
kpi_creditos AS
(
    SELECT COUNT(*) AS total_creditos,
           SUM(monto) AS total_desembolsado
    FROM creditos
),
kpi_pagos AS
(
    SELECT
        COUNT(*) AS total_pagos,
        SUM(monto) AS monto_total_pagado
    FROM pagos
),
kpi_cuotas AS
(
    SELECT
        COUNT(*) AS total_cuotas,
        SUM(
            CASE
                WHEN estado IN ('pendiente','pagada parcialmente')
                THEN 1
                ELSE 0
            END
        ) AS cuotas_morosas
    FROM cuotas
)
SELECT
    c.total_clientes,
    s.total_solicitudes,
    cr.total_creditos,
    cr.total_desembolsado,
    p.total_pagos,
    cu.total_cuotas,

    CAST(
        cu.cuotas_morosas * 100.0
        / NULLIF(cu.total_cuotas, 0)
    AS DECIMAL(10,2)
    ) AS ratio_morosidad

FROM kpi_clientes c
CROSS JOIN kpi_solicitudes s
CROSS JOIN kpi_creditos cr
CROSS JOIN kpi_pagos p
CROSS JOIN kpi_cuotas cu;

/*
===========================================================
EJERCICIO 17
===========================================================

Analizar la tendencia mensual de solicitudes.

Mostrar:

- Año
- Mes
- Cantidad solicitudes

Ordenar cronológicamente.
*/
SELECT
    YEAR(fecha_solicitud) AS anio,
    MONTH(fecha_solicitud) AS numero_mes,
    DATENAME(MONTH, fecha_solicitud) AS mes,
    COUNT(*) AS cantidad_solicitudes
FROM solicitudes
GROUP BY
    YEAR(fecha_solicitud),
    MONTH(fecha_solicitud),
    DATENAME(MONTH, fecha_solicitud)
ORDER BY
    anio,
    numero_mes;

/*
===========================================================
EJERCICIO 18
===========================================================

Determinar el mes con mayor desembolso.

Mostrar:

- Año
- Mes
- Total desembolsado

Ordenar de mayor a menor.
*/
SELECT TOP (1)
    YEAR(c.fecha_desembolso) AS anio,
    MONTH(c.fecha_desembolso) AS numero_mes,
    DATENAME(MONTH, c.fecha_desembolso) AS mes,
    SUM(c.monto) AS total_desembolsado
FROM creditos c
GROUP BY
    YEAR(c.fecha_desembolso),
    MONTH(c.fecha_desembolso),
    DATENAME(MONTH, c.fecha_desembolso)
ORDER BY
    total_desembolsado DESC;

/*
===========================================================
EJERCICIO 19
===========================================================

Proyectar ingresos futuros por intereses.

Considerar únicamente:

- Cuotas pendientes
- Cuotas parcialmente pagadas

Mostrar:

- Crédito
- Intereses pendientes
- Total proyectado
*/
SELECT
    c.numero_credito,

    CAST(
        SUM(cu.intereses)
    AS DECIMAL(18,2)) AS intereses_pendientes,

    CAST(
        SUM(cu.intereses)
    AS DECIMAL(18,2)) AS total_proyectado

FROM creditos c
INNER JOIN cuotas cu
    ON cu.credito_id = c.id

WHERE cu.estado IN ('pendiente', 'pagada parcialmente')

GROUP BY
    c.numero_credito

ORDER BY
    total_proyectado DESC;

/*
===========================================================
EJERCICIO 20
===========================================================

Construir un Semáforo Crediticio.

Reglas:

Verde:
Score > 700

Amarillo:
Score entre 500 y 700

Rojo:
Score < 500

Mostrar:

- Cliente
- Score
- Semáforo
*/
SELECT
    CASE
        WHEN pj.razon_social IS NOT NULL
            THEN pj.razon_social
        ELSE CONCAT(
            pn.nombres, ' ',
            pn.apellido_paterno, ' ',
            pn.apellido_materno
        )
    END AS cliente,

    ec.score_riesgo AS score,

    CASE
        WHEN ec.score_riesgo > 700 THEN 'Verde'
        WHEN ec.score_riesgo BETWEEN 500 AND 700 THEN 'Amarillo'
        ELSE 'Rojo'
    END AS semaforo

FROM evaluaciones_crediticias ec
INNER JOIN solicitudes s
    ON s.id = ec.solicitud_id
INNER JOIN clientes c
    ON c.id = s.cliente_id
LEFT JOIN personas_naturales pn
    ON pn.cliente_id = c.id
LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id

ORDER BY
    CASE
        WHEN ec.score_riesgo < 500 THEN 1
        WHEN ec.score_riesgo BETWEEN 500 AND 700 THEN 2
        ELSE 3
    END,
    ec.score_riesgo;


/*
EJERCICIO V03 - BÁSICO
Enunciado

Crear una vista que muestre todas las cuentas junto con:

Número cuenta
Moneda
Saldo
Tipo cuenta

*/

CREATE VIEW vw_cuentas AS
SELECT
    nro_cuenta AS 'Número Cuenta',
    moneda AS 'Moneda',
    saldo AS 'Saldo',
    tipo_cuenta AS 'Tipo Cuenta'
FROM cuentas;
GO

SELECT * FROM vw_cuentas;

/*
EJERCICIO V04 - INTERMEDIO
Enunciado

Crear una vista que muestre todas las solicitudes.
*/

CREATE VIEW vw_solicitudes AS
SELECT
    sc.codigo_solicitud AS 'Código Solicitud',
    sc.fecha_solicitud AS 'Fecha Solicitud',

    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(
                nt.apellido_paterno,' ',
                nt.apellido_materno,' ',
                nt.nombres
            )
        ELSE pj.razon_social
    END AS 'Cliente',

    pc.nombre AS 'Producto Crediticio',
    sc.monto_solicitado AS 'Monto Solicitado',
    sc.estado AS 'Estado'

FROM solicitud_crediticia sc

INNER JOIN clientes c
    ON c.id = sc.cliente_id

INNER JOIN productos_crediticios pc
    ON pc.id = sc.producto_crediticio_id

LEFT JOIN personas_naturales nt
    ON nt.cliente_id = c.id

LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id;
GO

SELECT * FROM vw_solicitudes;


/*
EJERCICIO V05 - INTERMEDIO
Enunciado

Crear una vista que muestre las evaluaciones crediticias.
*/

CREATE VIEW vw_evaluaciones_crediticias AS
SELECT

    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(
                nt.apellido_paterno,' ',
                nt.apellido_materno,' ',
                nt.nombres
            )
        ELSE pj.razon_social
    END AS 'Cliente',

    ec.score_riesgo AS 'Score Riesgo',
    ec.nivel_endeudamiento AS 'Nivel Endeudamiento',
    ec.ingresos_mensuales AS 'Ingresos Mensuales',
    ec.resultado AS 'Resultado Evaluación'

FROM evaluaciones_crediticias ec

INNER JOIN solicitud_crediticia sc
    ON sc.id = ec.solicitud_crediticia_id

INNER JOIN clientes c
    ON c.id = sc.cliente_id

LEFT JOIN personas_naturales nt
    ON nt.cliente_id = c.id

LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id;
GO

SELECT * FROM vw_evaluaciones_crediticias;

/*
EJERCICIO V06 - INTERMEDIO
Enunciado

Crear una vista denominada:
Mostrar únicamente créditos vigentes.
*/
CREATE VIEW vw_creditos_vigentes AS
SELECT
    numero_credito AS 'Número Crédito',
    monto AS 'Monto',
    plazo_meses AS 'Plazo',
    tea AS 'TEA',
    tcea AS 'TCEA',
    saldo_credito AS 'Saldo',
    fecha_desembolso AS 'Fecha Desembolso'
FROM creditos
WHERE estado = 'VIGENTE';
GO

SELECT * FROM vw_creditos_vigentes;

/*
EJERCICIO V07 - AVANZADO
Enunciado

Crear una vista de cartera crediticia.
*/
CREATE VIEW vw_cartera_crediticia AS
SELECT

    cr.numero_credito AS 'Número Crédito',

    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(
                nt.apellido_paterno,' ',
                nt.apellido_materno,' ',
                nt.nombres
            )
        ELSE pj.razon_social
    END AS 'Cliente',

    pc.nombre AS 'Producto',

    cr.monto AS 'Monto',
    cr.saldo_credito AS 'Saldo Crédito',
    cr.estado AS 'Estado'

FROM creditos cr

INNER JOIN solicitud_crediticia sc
    ON sc.id = cr.solicitud_crediticia_id

INNER JOIN productos_crediticios pc
    ON pc.id = sc.producto_crediticio_id

INNER JOIN clientes c
    ON c.id = sc.cliente_id

LEFT JOIN personas_naturales nt
    ON nt.cliente_id = c.id

LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id;
GO

SELECT * FROM vw_cartera_crediticia;

/*
EJERCICIO V08 - AVANZADO
Enunciado

Crear una vista de cuotas pendientes.
*/

CREATE VIEW vw_cuotas_pendientes AS
SELECT

    cr.numero_credito AS 'Crédito',

    cu.nro_cuota AS 'Número Cuota',

    cu.fecha_vencimiento AS 'Fecha Vencimiento',

    cu.total_cuota AS 'Total Cuota',

    cu.saldo_cuota AS 'Saldo Pendiente'

FROM cuotas cu

INNER JOIN cronogramas cg
    ON cg.id = cu.cronograma_id

INNER JOIN creditos cr
    ON cr.id = cg.credito_id

WHERE cu.estado = 'PENDIENTE';
GO

SELECT * FROM vw_cuotas_pendientes;

/*
EJERCICIO V10 - EXPERTO
Enunciado

Crear una vista de riesgo crediticio.

Clasificar clientes:

Riesgo Bajo
Riesgo Medio
Riesgo Alto

según score_riesgo.
*/

CREATE VIEW vw_riesgo_crediticio AS
SELECT

    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(
                nt.apellido_paterno,' ',
                nt.apellido_materno,' ',
                nt.nombres
            )
        ELSE pj.razon_social
    END AS 'Cliente',

    ec.score_riesgo AS 'Score Riesgo',

    CASE
        WHEN ec.score_riesgo >= 700
            THEN 'Riesgo Bajo'

        WHEN ec.score_riesgo >= 500
            THEN 'Riesgo Medio'

        ELSE 'Riesgo Alto'
    END AS 'Clasificación'

FROM evaluaciones_crediticias ec

INNER JOIN solicitud_crediticia sc
    ON sc.id = ec.solicitud_crediticia_id

INNER JOIN clientes c
    ON c.id = sc.cliente_id

LEFT JOIN personas_naturales nt
    ON nt.cliente_id = c.id

LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id;
GO

SELECT * FROM vw_riesgo_crediticio;


/*
-----------------------------------------------------------
EJERCICIO F02 - BÁSICO
-----------------------------------------------------------

Crear una función que reciba:

@monto

Y retorne:

IGV incluido.
*/
CREATE FUNCTION fn_igv_incluido (@monto DECIMAL(18,2))
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN ( @monto * 1.18 );
END;
GO

SELECT dbo.fn_igv_incluido(1000) AS 'Monto con IGV';

/*
-----------------------------------------------------------
EJERCICIO F04 - INTERMEDIO
-----------------------------------------------------------

Crear una función que reciba:

@saldo_credito

Y retorne:

Clasificación:

- Normal
- Observado
- Crítico
*/
CREATE FUNCTION fn_clasificar_credito
(
    @saldo_credito DECIMAL(18,2)
)
RETURNS VARCHAR(20)
AS
BEGIN

    RETURN
    (
        CASE
            WHEN @saldo_credito < 50000
                THEN 'Normal'

            WHEN @saldo_credito < 150000
                THEN 'Observado'

            ELSE 'Critico'
        END
    );

END;
GO

SELECT dbo.fn_clasificar_credito(30000) AS 'Clasificacion';

/*
-----------------------------------------------------------
EJERCICIO F05 - INTERMEDIO
-----------------------------------------------------------

Crear una función que reciba:

@ingresos
@deudas

Y retorne:

Porcentaje de endeudamiento.
*/

CREATE FUNCTION fn_porcentaje_endeudamiento
(
    @ingresos DECIMAL(18,2),
    @deudas DECIMAL(18,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN

    RETURN
    (
        (@deudas * 100.0) / @ingresos
    );

END;
GO

SELECT dbo.fn_porcentaje_endeudamiento ( 5000, 1500 ) AS 'Porcentaje Endeudamiento';

/*
-----------------------------------------------------------
EJERCICIO F06 - INTERMEDIO
-----------------------------------------------------------

Crear una función que reciba:

@capital
@intereses
@seguros

Y retorne:

Total cuota.
*/

CREATE FUNCTION fn_total_cuota
(
    @capital DECIMAL(18,2),
    @intereses DECIMAL(18,2),
    @seguros DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    RETURN
    (
        @capital +
        @intereses +
        @seguros
    );

END;
GO

SELECT dbo.fn_total_cuota ( 1200, 180, 45 ) AS 'Total Cuota';