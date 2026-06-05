USE bd_sistema_creditos_mivivienda;
GO

/*
Vista 1: vw_solicitudes_crediticias

Enunciado:
Mostrar las solicitudes crediticias junto con el cliente, producto crediticio, monto solicitado y estado de la solicitud
*/
GO
CREATE VIEW vw_solicitudes_crediticias AS
SELECT
    sc.codigo_solicitud AS 'Código Solicitud',

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

    sc.estado AS 'Estado Solicitud'

FROM solicitud_crediticia sc

INNER JOIN clientes c
    ON sc.cliente_id = c.id

INNER JOIN productos_crediticios pc
    ON sc.producto_crediticio_id = pc.id

LEFT JOIN personas_naturales nt
    ON nt.cliente_id = c.id

LEFT JOIN personas_juridicas pj
    ON pj.cliente_id = c.id;
GO


SELECT * FROM vw_solicitudes_crediticias;


/*
Vista 2: vw_creditos_activos

Enunciado:
Mostrar el listado de créditos que se encuentran actualmente activos.
*/
GO
CREATE VIEW vw_creditos_activos AS
SELECT
    numero_credito AS 'Número Crédito',
    monto AS 'Monto',
    tea AS 'TEA',
    tcea AS 'TCEA',
    fecha_desembolso AS 'Fecha Desembolso',
    estado AS 'Estado'
FROM creditos
WHERE estado = 'ACTIVO';
GO

SELECT * FROM vw_creditos_activos;

/*
Función 1: fn_indice_endeudamiento

Enunciado:
Calcular el porcentaje de endeudamiento de un cliente en función de su deuda e ingresos.
*/
GO
CREATE FUNCTION fn_indice_endeudamiento
(
    @deuda DECIMAL(12,2),
    @ingresos DECIMAL(12,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN

    RETURN
    (
        (@deuda * 100.0) / @ingresos
    );

END;
GO

SELECT dbo.fn_indice_endeudamiento(2500,8000)
AS 'Indice Endeudamiento';

/*
Función 2: fn_porcentaje_financiado

Enunciado:
Calcular qué porcentaje del valor de una propiedad será financiado mediante un crédito hipotecario.
*/
GO
CREATE FUNCTION fn_porcentaje_financiado
(
    @monto_solicitado DECIMAL(12,2),
    @valor_propiedad DECIMAL(12,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN

    RETURN
    (
        (@monto_solicitado * 100.0)
        /
        @valor_propiedad
    );

END;
GO

SELECT dbo.fn_porcentaje_financiado
(
    180000,
    250000
)
AS 'Porcentaje Financiado';

/*
Procedimiento 1: sp_solicitudes_cliente

Enunciado:
Consultar todas las solicitudes crediticias realizadas por un cliente específico.
*/
GO
CREATE PROCEDURE sp_solicitudes_cliente
(
    @cliente_id INT
)
AS
BEGIN

    SELECT
        codigo_solicitud,
        monto_solicitado,
        estado
    FROM solicitud_crediticia
    WHERE cliente_id=@cliente_id;

END;
GO

EXEC sp_solicitudes_cliente 5;

/*
Procedimiento 2: sp_creditos_estado

Enunciado:
Mostrar los créditos según el estado indicado por el usuario.
*/
GO
CREATE PROCEDURE sp_creditos_estado
(
    @estado VARCHAR(20)
)
AS
BEGIN

    SELECT
        numero_credito,
        monto,
        fecha_desembolso
    FROM creditos
    WHERE estado=@estado;

END;
GO

EXEC sp_creditos_estado 'ACTIVO';

/*
Vista Avanzada: vw_financiamiento_propiedades

Enunciado:
Mostrar el porcentaje de financiamiento de cada solicitud comparando el monto solicitado con el valor comercial de la propiedad.
*/
GO
CREATE VIEW vw_financiamiento_propiedades AS
SELECT
    sc.codigo_solicitud AS 'Solicitud',

    pc.nombre AS 'Producto',

    p.valor_comercial AS 'Valor Propiedad',

    sc.monto_solicitado AS 'Monto Solicitado',

    CAST(
    (
        sc.monto_solicitado * 100.0
    )
    /
    p.valor_comercial
    AS DECIMAL(10,2))
    AS 'Porcentaje Financiado'

FROM solicitud_crediticia sc

INNER JOIN propiedad p
    ON sc.propiedad_id=p.id

INNER JOIN productos_crediticios pc
    ON sc.producto_crediticio_id=pc.id;
GO


SELECT * FROM vw_financiamiento_propiedades;


/*
VISTA

Enunciado
Mostrar las evaluaciones crediticias junto con el cliente y el resultado obtenido.
*/
GO
CREATE VIEW vw_evaluaciones_crediticias AS
SELECT
    sc.codigo_solicitud AS 'Código Solicitud',

    CASE
        WHEN pj.razon_social IS NULL
            THEN CONCAT(nt.apellido_paterno,' ',nt.apellido_materno,' ',nt.nombres)
        ELSE pj.razon_social
    END AS 'Cliente',

    ec.score_riesgo AS 'Score Riesgo',
    ec.nivel_endeudamiento AS 'Nivel Endeudamiento',
    ec.resultado AS 'Resultado'

FROM evaluaciones_crediticias ec

INNER JOIN solicitud_crediticia sc
    ON ec.solicitud_crediticia_id=sc.id

INNER JOIN clientes c
    ON sc.cliente_id=c.id

LEFT JOIN personas_naturales nt
    ON nt.cliente_id=c.id

LEFT JOIN personas_juridicas pj
    ON pj.cliente_id=c.id;
GO

SELECT * FROM vw_evaluaciones_crediticias;

/*
FUNCIÓN

Enunciado
Calcular la cuota inicial aportada por el cliente.

Fórmula
Valor Propiedad - Monto Solicitado
*/
GO
CREATE FUNCTION fn_cuota_inicial
(
    @valor_propiedad DECIMAL(18,2),
    @monto_solicitado DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    RETURN
    (
        @valor_propiedad - @monto_solicitado
    )

END;
GO

SELECT dbo.fn_cuota_inicial
(
    300000,
    240000
) AS 'Cuota Inicial';

/*
PROCEDIMIENTO ALMACENADO

Enunciado
Mostrar el cronograma de pagos de un crédito indicando el número de cuota, 
fecha de vencimiento, monto de la cuota, saldo pendiente y estado de pago.
*/
GO
CREATE PROCEDURE sp_cronograma_credito
(
    @credito_id INT
)
AS
BEGIN

    SELECT
        c.numero_credito,
        c.monto,
        c.plazo_meses,
        cu.nro_cuota,
        cu.fecha_vencimiento,
        cu.total_cuota,
        cu.saldo_cuota,
        cu.estado
    FROM creditos c
    INNER JOIN cronogramas cr
        ON cr.credito_id = c.id
    INNER JOIN cuotas cu
        ON cu.cronograma_id = cr.id
    WHERE c.id = @credito_id
    ORDER BY cu.nro_cuota;

END;
GO

EXEC sp_cronograma_credito 1;