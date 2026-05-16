
--CREATE DATABASE bd_sistema_creditos_mivivienda;
--go

USE bd_sistema_creditos_mivivienda;
GO

--- Clientes
CREATE TABLE clientes (
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo_cliente VARCHAR(1) NOT NULL
);

--- Personas Naturales
CREATE TABLE personas_naturales(
	id INT IDENTITY(1,1) PRIMARY KEY,
	numero_documento VARCHAR(15) UNIQUE NOT NULL,
	nombres VARCHAR(255) NOT NULL,
	apellido_paterno VARCHAR(255) NOT NULL,
	apellido_materno VARCHAR(255) NOT NULL,
	celular VARCHAR(20) UNIQUE NOT NULL,
	direccion VARCHAR(255) NOT NULL,
	ubigeo CHAR(6) NULL,
	fecha_nacimiento DATE NOT NULL,
	estado_civil VARCHAR(10) NOT NULL,
	genero VARCHAR(10) NOT NULL,
	situacion_laboral VARCHAR(100) NULL,
	cliente_id INT UNIQUE NOT NULL,
	CONSTRAINT fk_clientes_persona_natural FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Personas juridicas
CREATE TABLE personas_juridicas( 
	id INT IDENTITY(1,1) PRIMARY KEY, 
	ruc VARCHAR(11) UNIQUE NOT NULL, 
	razon_social VARCHAR(255) NOT NULL, 
	nombre_comercial VARCHAR(255) NULL, 
	tipo_empresa VARCHAR(100) NOT NULL, 
	representante_legal VARCHAR(200) NOT NULL,
	sector_economico VARCHAR(100) NULL, 
	direccion VARCHAR(255) NOT NULL, 
	ubigeo CHAR(6) NULL, 
	telefono VARCHAR(20) NULL, 
	correo VARCHAR(255) NULL, 
	fecha_constitucion DATE NOT NULL, 
	estado_empresa VARCHAR(50) NOT NULL,	
	inicio_actividades DATE NOT NULL,
	numero_empleados INT NULL,
	cliente_id INT UNIQUE NOT NULL, 
	CONSTRAINT fk_clientes_persona_juridica FOREIGN KEY (cliente_id) REFERENCES clientes(id) 
);

-- Tipos_cuenta
CREATE TABLE tipos_cuenta (
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(100) UNIQUE NOT NULL,
	descripcion VARCHAR (255) NULL
);

-- Cuentas
CREATE TABLE cuentas(
	id INT IDENTITY(1,1) PRIMARY KEY,
	num_cuenta VARCHAR (50) UNIQUE NOT NULL,
	cci VARCHAR(55) UNIQUE NOT NULL,
	num_tarjeta VARCHAR(30) UNIQUE NOT NULL,
	fecha_creacion DATETIME NOT NULL,
	moneda VARCHAR(50) NOT NULL,
	saldo DECIMAL(18,2) NOT NULL,
	tipo_cuenta_id INT NOT NULL,
	clientes_id INT NOT NULL,
	CONSTRAINT fk_tipos_cuenta FOREIGN KEY (tipo_cuenta_id) REFERENCES tipos_cuenta(id),
	CONSTRAINT fk_clientes FOREIGN KEY (clientes_id) REFERENCES clientes(id),
);

-- Productos crediticios
CREATE TABLE productos_crediticios (
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(155) UNIQUE NOT NULL,
	codigo_producto VARCHAR(10) NOT NULL,
	monto_minimo DECIMAL(18,2) NOT NULL,
	monto_maximo DECIMAL(18,2) NOT NULL,
	tasa_interes_minima DECIMAL(9,2) NOT NULL,
	tasa_interes_maxima DECIMAL(9,2) NOT NULL,
	plazo_minimo_meses INT NOT NULL,
	plazo_maximo_meses INT NOT NULL,
	estado VARCHAR(55),
	created_at DATETIME NOT NULL,
	updated_at DATETIME NOT NULL,
	deleted_at DATETIME NULL
);

-- Usuario
CREATE TABLE usuario (
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombres VARCHAR(155) NOT NULL,
	apellidos VARCHAR(10) NOT NULL,
	correo VARCHAR(155) UNIQUE NOT NULL,
	telefono INT UNIQUE NOT NULL,
	rol VARCHAR(20) NOT NULL,
	estado VARCHAR(55) NOT NULL,
	CONSTRAINT CHK_rol CHECK (rol IN ('SUPERVISOR', 'ASESOR', 'ANALISTA')),
);

-- Ubicaciones
CREATE TABLE ubicacion (
	id INT IDENTITY(1,1) PRIMARY KEY,
	ubigeo CHAR(10) UNIQUE NOT NULL,
	departamento VARCHAR(100) NOT NULL,
	provincia VARCHAR(100) NOT NULL,
	distrito VARCHAR(100) NOT NULL
);

-- Propiedades
CREATE TABLE propiedad (
	id INT IDENTITY(1,1) PRIMARY KEY,
	ubicacion_id INT NOT NULL,
	tipo_vivienda VARCHAR(100) NOT NULL,
	direccion VARCHAR(255) NOT NULL,
	valor_comercial DECIMAL(18,2) NOT NULL,
	area_m2 INT NOT NULL,
	estado_vivienda VARCHAR(50) NOT NULL,
	CONSTRAINT FK_propiedad_ubicacion FOREIGN KEY (ubicacion_id) REFERENCES ubicacion(id)
);

-- Solicitudes
CREATE TABLE solicitud_crediticia ( 
	id INT IDENTITY(1,1) PRIMARY KEY, 
	cliente_id INT NOT NULL, 
	producto_crediticio_id INT NOT NULL,
	propiedad_id INT NOT NULL,
	asesor_id INT NOT NULL,
	codigo_solicitud VARCHAR(50) NOT NULL,
	fecha_solicitud DATETIME NOT NULL,
	monto_solicitado DECIMAL(18,2) NOT NULL,
	moneda_solicitada VARCHAR(10) NOT NULL, 
	estado VARCHAR(50) NOT NULL, 
	CONSTRAINT CHK_monto_solicitado CHECK (monto_solicitado >= 1000),
	CONSTRAINT CHK_moneda_solicitada CHECK (moneda_solicitada IN ('PEN', 'USD', 'EUR')),
	CONSTRAINT UQ_solicitudes_codigo UNIQUE (codigo_solicitud),
	CONSTRAINT FK_solicitudes_clientes FOREIGN KEY (cliente_id) REFERENCES clientes(id),
	CONSTRAINT FK_solicitudes_productos_crediticios FOREIGN KEY (producto_crediticio_id) REFERENCES productos_crediticios(id),
	CONSTRAINT FK_solicitudes_usuario FOREIGN KEY (asesor_id) REFERENCES usuario(id),
	CONSTRAINT FK_solicitudes_propiedad FOREIGN KEY (propiedad_id) REFERENCES propiedad(id),
);

-- Evaluaciones crediticias
CREATE TABLE evaluaciones_crediticias ( 
	id INT IDENTITY(1,1) PRIMARY KEY, 
	solicitud_crediticia_id INT NOT NULL,
	supervisor_id INT NOT NULL,
	score_riesgo DECIMAL(10,2) NOT NULL,
	nivel_endeudamiento DECIMAL(10,2) NOT NULL,
	deuda_activa DECIMAL(18,2) NOT NULL,
	deuda_activa_otras_entidades DECIMAL(18,2) NOT NULL, 
	linea_credito DECIMAL(18,2) NOT NULL, 
	linea_credito_otras_entidades DECIMAL(18,2) NOT NULL,
	valor_patrimonio DECIMAL(18,2) NOT NULL, 
	ingresos_mensuales DECIMAL(18,2) NOT NULL,
	resultado VARCHAR(100) NOT NULL,
	CONSTRAINT FK_evaluaciones_solicitudes FOREIGN KEY (solicitud_crediticia_id) REFERENCES solicitud_crediticia(id),
	CONSTRAINT FK_evaluaciones_usuario FOREIGN KEY (supervisor_id) REFERENCES usuario(id),
);  

-- creditos
CREATE TABLE creditos (    
	id INT IDENTITY(1,1) PRIMARY KEY,
    solicitud_crediticia_id INT NOT NULL,
	cuenta_id INT NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    plazo_meses INT NOT NULL,
    tea DECIMAL(10,2) NOT NULL,
    tcea DECIMAL(10,2) NOT NULL,
    valor_cuota DECIMAL(18,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    fecha_desembolso DATETIME NOT NULL,
    numero_credito INT UNIQUE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    estado VARCHAR(100) NOT NULL,
    saldo_credito DECIMAL(18,2) NOT NULL,
    desgravamen DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_creditos_solicitud FOREIGN KEY (solicitud_crediticia_id) REFERENCES solicitud_crediticia(id),
	CONSTRAINT FK_creditos_cuenta FOREIGN KEY (cuenta_id) REFERENCES cuentas(id),
);

-- cronogramas
CREATE TABLE cronogramas (
	id INT IDENTITY(1,1) PRIMARY KEY,
	credito_id INT UNIQUE NOT NULL,
	fecha_generacion DATETIME NOT NULL,
	cantidad_cuotas INT NOT NULL,
	monto_total DECIMAL(18,2) NOT NULL,
	CONSTRAINT FK_cronogramas_creditos FOREIGN KEY (credito_id) REFERENCES creditos(id),
); 

--cuotas
CREATE TABLE cuotas (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    cronograma_id INT NOT NULL,
    nro_cuota INT NOT NULL,
    fecha_vencimiento DATETIME NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    intereses DECIMAL(18,2) NOT NULL,
    seguros DECIMAL(18,2) NOT NULL,
    total_cuota DECIMAL(18,2) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    tasa_mora DECIMAL(10,2) NOT NULL,
    saldo_cuota DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_cuotas_cronograma FOREIGN KEY (cronograma_id) REFERENCES cronogramas(id),
	CONSTRAINT chk_total_cuota CHECK (total_cuota=(monto+intereses+seguros)),
	CONSTRAINT chk_saldo_cuota CHECK(saldo_cuota<=(monto+intereses+seguros))
);

-- Pagos
CREATE TABLE pagos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    num_operacion VARCHAR(50) UNIQUE,
    monto_pagado DECIMAL(18,2),
    fecha_pago DATETIME,
    metodo_pago VARCHAR(50),
    observaciones  VARCHAR(200)
);

-- detalle_cuotas_pagos
CREATE TABLE detalle_cuotas_pagos(
	id INT IDENTITY(1,1) PRIMARY KEY,
	cuota_id INT NOT NULL,
	pago_id INT NOT NULL,
	monto_cuota DECIMAL(18,2) NOT NULL,
	FOREIGN KEY (cuota_id) REFERENCES cuotas(id),
	FOREIGN KEY (pago_id) REFERENCES pagos(id)
);





