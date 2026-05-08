# 📘 Caso de Estudio: Sistema de Información para Colocaciones de Créditos Mivivienda

## 🏦 1. Contexto del negocio

En el Perú, el acceso a vivienda formal es promovido mediante programas de financiamiento hipotecario administrados por el Fondo MIVIVIENDA S.A., los cuales permiten a distintas entidades financieras ofrecer productos orientados a la adquisición de viviendas.

Con el objetivo de fomentar la transparencia y acceso a la información, diversas instituciones publican datasets abiertos relacionados con las colocaciones de créditos Mivivienda. Estos datasets contienen información agregada y operacional sobre:

- Créditos desembolsados
- Entidades financieras participantes
- Productos crediticios
- Ubicación geográfica de las viviendas
- Montos, tasas y plazos de financiamiento

Sin embargo, estos datos suelen encontrarse en estructuras planas y desnormalizadas, orientadas principalmente al análisis estadístico y consulta pública, mas no al modelamiento de un sistema transaccional bancario.

Ante esta situación, una entidad académica desea desarrollar un proyecto de modelamiento de datos que permita transformar esta información en un modelo conceptual, lógico y físico más cercano al funcionamiento real de un sistema de gestión de créditos hipotecarios.

El propósito del proyecto es diseñar un sistema capaz de representar de manera estructurada el proceso de colocación de créditos Mivivienda, incorporando no solo la información disponible en el dataset abierto, sino también entidades y procesos adicionales propios del negocio bancario, tales como:

- Clientes
- Solicitudes de crédito
- Evaluaciones crediticias
- Créditos hipotecarios
- Cronogramas de pago
- Seguimiento de operaciones

De esta manera, el proyecto combinará:

- Datos reales provenientes de fuentes abiertas del Perú
- Expansión académica del dominio bancario
- Aplicación de técnicas de modelamiento conceptual y relacional

---

# 🎯 2. Objetivos del sistema

El sistema tendrá como objetivos principales:

- Centralizar la información relacionada con colocaciones de créditos Mivivienda
- Gestionar el ciclo de vida de las solicitudes de crédito
- Registrar información de clientes, propiedades y entidades financieras
- Modelar la evaluación y aprobación de créditos hipotecarios
- Administrar créditos desembolsados y cronogramas de pago
- Permitir consultas y análisis sobre montos colocados, tasas y distribución geográfica
- Transformar información desnormalizada en un modelo relacional estructurado

---

# 👥 3. Actores involucrados

| Actor | Descripción |
|---|---|
| Cliente | Persona natural que solicita un crédito hipotecario |
| Asesor de crédito | Registra solicitudes y orienta al cliente |
| Analista de riesgos | Evalúa capacidad de pago y riesgo crediticio |
| Entidad financiera | Institución que otorga el crédito |
| Fondo Mivivienda | Programa que regula los productos hipotecarios |
| Sistema de información | Plataforma encargada de gestionar los procesos y datos |
| Usuario analista | Usuario que consulta reportes e indicadores |

---

# 🔄 4. Procesos principales del negocio

## 4.1 Registro de clientes

El sistema almacena información personal y financiera de los clientes interesados en solicitar un crédito hipotecario.

---

## 4.2 Registro de solicitudes de crédito

El asesor financiero registra la solicitud del cliente indicando:

- Tipo de producto Mivivienda
- Monto solicitado
- Valor de la vivienda
- Ubicación del inmueble
- Entidad financiera participante

---

## 4.3 Evaluación crediticia

El analista de riesgos revisa:

- Ingresos del cliente
- Nivel de endeudamiento
- Historial crediticio
- Capacidad de pago

Como resultado, la solicitud puede ser:

- Aprobada
- Rechazada
- Observada

---

## 4.4 Gestión de propiedades

El sistema registra información de las viviendas asociadas al crédito:

- Departamento
- Provincia
- Distrito
- Código UBIGEO
- Valor del inmueble

---

## 4.5 Generación del crédito

Si la solicitud es aprobada:

- Se genera el crédito hipotecario
- Se registra la tasa de interés
- Se define el plazo del financiamiento
- Se registra la fecha de desembolso

---

## 4.6 Gestión del cronograma de pagos

El sistema administra:

- Cuotas mensuales
- Fechas de vencimiento
- Estado de pago
- Seguimiento del crédito

---

## 4.7 Consultas y análisis

Los usuarios pueden realizar consultas relacionadas con:

- Créditos colocados por departamento
- Distribución por entidad financiera
- Montos desembolsados
- Tasas promedio
- Productos más utilizados

---

# 📏 5. Reglas de negocio

- Un cliente puede registrar múltiples solicitudes de crédito
- Cada solicitud pertenece a un único cliente
- Una solicitud debe estar asociada a una propiedad
- Una propiedad pertenece a una única ubicación geográfica
- Un crédito solo puede generarse si la solicitud es aprobada
- Cada crédito pertenece a una entidad financiera
- Todo crédito debe tener un cronograma de pagos
- Los productos crediticios deben estar regulados por el programa Mivivienda
- El monto del crédito no debe superar el valor de la vivienda
- Toda ubicación debe estar identificada mediante código UBIGEO

---

# 📌 6. Alcance del sistema

## Incluye:

- Gestión de clientes
- Gestión de solicitudes de crédito
- Evaluación crediticia
- Gestión de propiedades
- Gestión de entidades financieras
- Administración de créditos hipotecarios
- Registro de cronogramas y cuotas
- Consultas y reportes analíticos
- Modelamiento de datos basado en información real

---

## No incluye:

- Integración con centrales de riesgo
- Validaciones biométricas
- Pagos en línea
- Gestión contable bancaria
- Procesos notariales completos

---

# 🧩 7. Consideraciones sobre la fuente de datos

El proyecto toma como referencia un dataset público de colocaciones de créditos Mivivienda proveniente de plataformas de datos abiertos del Perú.

Dicho dataset contiene información relevante como:

- Fecha de desembolso
- Producto financiero
- Departamento, provincia y distrito
- Código UBIGEO
- Entidad financiera
- Tipo de IFI
- Monto del crédito
- Tasa de interés
- Plazo
- Valor de vivienda

Sin embargo, debido a que la fuente original posee una estructura desnormalizada y orientada al análisis estadístico, será necesario realizar un proceso de abstracción y modelamiento para transformarla en un sistema relacional estructurado.

Por ello, el modelo conceptual incluirá entidades adicionales no presentes explícitamente en el dataset original, tales como:

- Cliente
- Solicitud de crédito
- Evaluación crediticia
- Cronograma de pagos
- Cuotas

Estas entidades permitirán representar de manera más completa el funcionamiento del negocio bancario.

---

# 🧠 8. Evolución hacia el modelo conceptual

A partir del caso de estudio, se podrán identificar entidades como:

- Cliente
- SolicitudCredito
- EvaluacionCrediticia
- Credito
- Propiedad
- Ubicacion
- EntidadFinanciera
- ProductoCredito
- CronogramaPago
- Cuota
- Asesor
- Analista

Así como relaciones entre ellas para la construcción del Diagrama Entidad-Relación (DER).

---

# 🗄️ 9. Evolución hacia el modelo lógico

Posteriormente, el modelo conceptual será transformado a un modelo lógico relacional mediante:

- Definición de tablas
- Claves primarias y foráneas
- Normalización
- Restricciones de integridad
- Tipos de datos
- Implementación SQL

Esto permitirá construir una base de datos estructurada y alineada con el contexto de negocio planteado.
