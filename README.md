# 📘 Caso de Estudio: Sistema de Información para Colocaciones de Créditos Mivivienda

## 🏦 1. Descripción del Proyecto

Este proyecto tiene como objetivo diseñar un sistema OLTP (Online Transaction Processing) orientado a la gestión de colocaciones de créditos hipotecarios Mivivienda dentro de una entidad financiera.

El sistema busca representar de manera estructurada los principales procesos operativos relacionados con:

- Registro de clientes
- Solicitudes de crédito hipotecario
- Evaluación crediticia
- Gestión de propiedades
- Desembolso de créditos
- Administración de cronogramas y cuotas

El proyecto toma como referencia información real proveniente de datasets públicos de colocaciones de créditos Mivivienda del Perú, complementando dicha información con una expansión académica del dominio bancario para fines de modelamiento conceptual, lógico y físico.

---

# 🎯 2. Objetivos del sistema

El sistema tendrá como objetivos principales:

- Centralizar la información relacionada con colocaciones de créditos Mivivienda
- Gestionar el ciclo de vida de las solicitudes de crédito
- Registrar información de clientes y propiedades
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
| Supervisor | Supervisa y valida operaciones |
| Fondo Mivivienda | Programa que regula los productos hipotecarios |
| Usuario analista | Usuario que consulta reportes e indicadores |

---

# 🏠 4. Productos Financieros Considerados

El sistema contempla productos hipotecarios asociados al programa Mivivienda:

| Código | Producto |
|---|---|
| NCMV | Nuevo Crédito MIVIVIENDA |
| FCTP | Financiamiento Complementario Techo Propio |
| S-CRC | Servicio de Cobertura de Riesgo Crediticio |
| MT | Mi Terreno |

---

# 🧠 5. Contexto del Negocio

En el Perú, las entidades financieras ofrecen productos hipotecarios asociados al programa Mivivienda para facilitar la adquisición de viviendas.

Cuando un cliente desea adquirir una vivienda mediante financiamiento hipotecario, la entidad financiera realiza un proceso que incluye:

1. Registro del cliente
2. Registro de la solicitud de crédito
3. Evaluación crediticia
4. Validación de la propiedad
5. Aprobación o rechazo de la solicitud
6. Generación y desembolso del crédito
7. Administración del cronograma de pagos

El sistema propuesto modela dichos procesos mediante un enfoque OLTP, orientado al registro y gestión operativa de las transacciones del negocio.

---

# 📌 6. Alcance del sistema

## Incluye:

- Gestión de clientes
- Gestión de solicitudes de crédito
- Evaluación crediticia
- Gestión de propiedades
- Administración de créditos hipotecarios
- Registro de cronogramas y cuotas
- Consultas y reportes analíticos
- Modelamiento de datos basado en información real

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
