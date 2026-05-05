# 📘 Caso de Estudio: Sistema de Colocación de Créditos Mivivienda

## 🏦 1. Contexto del negocio

En el Perú, el acceso a vivienda formal es promovido por el Estado a través del Fondo MIVIVIENDA S.A., el cual facilita el financiamiento de viviendas mediante entidades financieras (bancos, cajas municipales, financieras).

Las entidades financieras actúan como intermediarios, evaluando a los clientes interesados en adquirir un crédito hipotecario bajo este programa. Estas colocaciones implican un proceso estructurado que incluye:

- Evaluación crediticia del cliente  
- Validación de requisitos del programa Mivivienda  
- Registro de la propiedad a adquirir  
- Aprobación y desembolso del crédito  
- Seguimiento del estado del crédito  

Actualmente, una entidad financiera desea desarrollar un sistema que permita **gestionar de manera integral el proceso de colocación de créditos Mivivienda**, debido a problemas como:

- Información dispersa en múltiples sistemas o archivos  
- Dificultad para hacer seguimiento al estado de las solicitudes  
- Inconsistencias en los datos de clientes y propiedades  
- Falta de trazabilidad en el proceso de aprobación  

---

## 🎯 2. Objetivos del sistema

El sistema tendrá como objetivos:

- Centralizar la información de clientes, solicitudes y propiedades  
- Gestionar el ciclo completo de colocación de créditos  
- Controlar el estado de cada solicitud (evaluación, aprobación, rechazo, desembolso)  
- Facilitar la evaluación crediticia  
- Mantener trazabilidad de las operaciones  
- Permitir consultas y reportes para la toma de decisiones  

---

## 👥 3. Actores involucrados

| Actor                | Descripción |
|---------------------|------------|
| Cliente             | Persona natural que solicita un crédito |
| Asesor de crédito   | Registra y gestiona la solicitud |
| Analista de riesgos | Evalúa la capacidad de pago |
| Entidad financiera  | Institución que otorga el crédito |
| Fondo Mivivienda    | Regula el programa |
| Notaría             | Formaliza la compra |
| Registro Público    | Inscribe la propiedad |

---

## 🔄 4. Procesos principales del negocio

### 4.1 Registro de cliente
- El cliente proporciona sus datos personales y financieros  
- Se valida si ya existe en el sistema  

### 4.2 Registro de solicitud de crédito
- Se registra una solicitud asociada a un cliente  
- Se define monto, tipo de vivienda y valor del inmueble  

### 4.3 Evaluación crediticia
- Se analizan ingresos, deudas e historial crediticio  
- Se asigna una calificación de riesgo  

### 4.4 Evaluación de la propiedad
- Se registran datos como ubicación, valor y tipo  

### 4.5 Aprobación o rechazo
- Estados posibles:
  - Aprobado  
  - Rechazado  
  - En observación  

### 4.6 Desembolso del crédito
- Se genera el crédito  
- Se crea el cronograma de pagos  
- Se realiza el desembolso  

### 4.7 Seguimiento del crédito
- Estados del crédito:
  - Vigente  
  - Moroso  
  - Cancelado  

---

## 📏 5. Reglas de negocio

- Un cliente puede tener múltiples solicitudes  
- Cada solicitud pertenece a un único cliente  
- Una solicitud está asociada a una sola propiedad  
- El monto del crédito no puede exceder un porcentaje del valor del inmueble  
- El cliente debe cumplir requisitos del programa  
- Toda solicitud debe pasar por evaluación crediticia  
- Un crédito solo se genera si la solicitud es aprobada  
- Todo crédito tiene un cronograma de pagos  
- Se debe mantener historial de estados de la solicitud  

---

## 📌 6. Alcance del sistema

### Incluye:
- Gestión de clientes  
- Registro y seguimiento de solicitudes  
- Evaluación crediticia  
- Gestión de propiedades  
- Generación de créditos  
- Cronogramas de pago  
- Reportes básicos  

### No incluye:
- Integración con centrales de riesgo  
- Procesos legales completos  
- Pagos en línea  
- Sistemas contables  
