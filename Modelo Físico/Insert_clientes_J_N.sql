
USE bd_sistema_creditos_mivivienda;
GO

INSERT INTO clientes VALUES ('N')

INSERT INTO personas_naturales VALUES
('12345678','Kevin','Rivera','Vergaray','987654123','Santa Anita- LIMA','234445','02-02-1996','S','M','Desempleado','1');

SELECT * FROM clientes;

SELECT * FROM personas_naturales;

INSERT INTO clientes(tipo_cliente)
VALUES
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('J'),
('J'),
('J'),
('J'),
('J');

INSERT INTO personas_naturales
(
numero_documento,
nombres,
apellido_paterno,
apellido_materno,
celular,
direccion,
ubigeo,
fecha_nacimiento,
estado_civil,
genero,
situacion_laboral,
cliente_id
)
VALUES
('72345678','Juan','Pérez','Gómez','987654321','Av. Javier Prado 100','150101','1990-03-15','C','M','Empleado',11),

('73456789','María','Torres','Rojas','987654322','Av. La Molina 230','150102','1988-05-12','S','F','Independiente',2),

('74567890','Luis','Ramírez','Soto','987654323','Av. Los Olivos 500','150103','1995-10-01','S','M','Empleado',3),

('75678901','Ana','Fernández','Ruiz','987654324','Av. Canadá 800','150104','1992-09-11','C','F','Empleado',4),

('76789012','Carlos','Mendoza','Flores','987654325','Av. Universitaria 700','150105','1987-02-25','D','M','Independiente',5),

('77890123','Lucía','Salazar','Vega','987654326','Av. Primavera 450','150106','1998-11-14','S','F','Empleado',6),

('78901234','Pedro','Castro','León','987654327','Av. Colonial 320','150107','1991-08-20','C','M','Empleado',7),

('79012345','Sofía','Delgado','Morales','987654328','Av. Grau 220','150108','1996-04-05','S','F','No consigna',8),

('70123456','Miguel','Navarro','Ortiz','987654329','Av. Angamos 180','150109','1985-07-09','C','M','Empleado',9),

('71234567','Valeria','Herrera','Silva','987654330','Av. Aviación 300','150110','1993-01-18','S','F','Desempleado',10);

-----------------------------
-- PERSONAS JURIDICAS
-----------------------------

INSERT INTO personas_juridicas
(
ruc,
razon_social,
nombre_comercial,
tipo_empresa,
representante_legal,
sector_economico,
direccion,
ubigeo,
telefono,
correo,
fecha_constitucion,
estado_empresa,
inicio_actividades,
numero_empleados,
cliente_id
)
VALUES

('20111111111',
'Tecnologías Andinas SAC',
'TecAndes',
'SAC',
'Carlos Ramírez Soto',
'Tecnología',
'Av. Benavides 500',
'150111',
'014567891',
'contacto@tecandes.com',
'2015-05-10',
'Activo',
'2015-06-01',
45,
11),

('20222222222',
'Constructora Horizonte SA',
'Horizonte',
'SA',
'Pedro Salinas Vega',
'Construcción',
'Av. Primavera 800',
'150112',
'014567892',
'ventas@horizonte.com',
'2012-09-14',
'Activo',
'2012-10-01',
150,
12),

('20333333333',
'AgroExport Perú SRL',
'AgroPerú',
'SRL',
'Luis Fernández Castro',
'Agroindustria',
'Av. Industrial 250',
'150113',
'014567893',
'contacto@agroperu.com',
'2018-02-08',
'Activo',
'2018-03-01',
75,
13),

('20444444444',
'Inversiones Delta EIRL',
'Delta',
'EIRL',
'José Mendoza Ruiz',
'Finanzas',
'Av. Arequipa 150',
'150114',
'014567894',
'info@delta.com',
'2017-07-20',
'Suspendido',
'2017-08-01',
12,
14),

('20555555555',
'Corporación Pacífico SAA',
'Pacífico Corp',
'SAA',
'Ricardo Torres León',
'Servicios',
'Av. El Sol 920',
'150115',
'014567895',
'contacto@pacifico.com',
'2010-11-01',
'Activo',
'2011-01-01',
320,
15);

GO

-----------------------------------------
-- CLIENTES (10 Naturales + 10 Jurídicos)
-----------------------------------------

INSERT INTO clientes(tipo_cliente)
VALUES
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('N'),
('J'),
('J'),
('J'),
('J'),
('J'),
('J'),
('J'),
('J'),
('J'),
('J');

-----------------------------------------
-- PERSONAS NATURALES (cliente_id 16–25)
-----------------------------------------

INSERT INTO personas_naturales
(
numero_documento,
nombres,
apellido_paterno,
apellido_materno,
celular,
direccion,
ubigeo,
fecha_nacimiento,
estado_civil,
genero,
situacion_laboral,
cliente_id
)
VALUES

('72345611','Ricardo','Guzmán','Paredes','987654331','Av. Las Flores 101','150116','1984-04-21','C','M','Empleado',16),

('72345612','Daniela','Cruz','Romero','987654332','Av. Universitaria 902','150117','1997-02-12','S','F','Empleado',17),

('72345613','Jorge','Silva','Mendoza','987654333','Av. Colonial 712','150118','1989-11-30','C','M','Independiente',18),

('72345614','Patricia','Ríos','Castro','987654334','Av. La Marina 500','150119','1992-06-14','S','F','Empleado',19),

('72345615','Fernando','Vargas','León','987654335','Av. Brasil 120','150120','1981-08-09','D','M','Empleado',20),

('72345616','Camila','Navarro','Flores','987654336','Av. Los Frutales 340','150121','1999-12-25','S','F','No consigna',21),

('72345617','Eduardo','Morales','Reyes','987654337','Av. San Luis 450','150122','1986-01-03','C','M','Empleado',22),

('72345618','Rosa','Paredes','Luna','987654338','Av. Grau 670','150123','1994-03-15','S','F','Independiente',23),

('72345619','José','Campos','Rojas','987654339','Av. Angamos 400','150124','1983-09-28','C','M','Empleado',24),

('72345620','Carolina','Torres','Silva','987654340','Av. Petit Thouars 900','150125','1991-05-17','D','F','Desempleado',25);

-----------------------------------------
-- PERSONAS JURIDICAS (cliente_id 26–35)
-----------------------------------------

INSERT INTO personas_juridicas
(
ruc,
razon_social,
nombre_comercial,
tipo_empresa,
representante_legal,
sector_economico,
direccion,
ubigeo,
telefono,
correo,
fecha_constitucion,
estado_empresa,
inicio_actividades,
numero_empleados,
cliente_id
)
VALUES

('20666666666',
'Comercial Andina SAC',
'ComAndes',
'SAC',
'Luis Pérez Gómez',
'Comercio',
'Av. Javier Prado 450',
'150126',
'014567896',
'ventas@comandes.com',
'2016-02-14',
'Activo',
'2016-03-01',
60,
26),

('20777777777',
'Transportes Lima SRL',
'TransLima',
'SRL',
'Marco Salazar León',
'Transporte',
'Av. Canadá 720',
'150127',
'014567897',
'contacto@translima.com',
'2011-06-20',
'Activo',
'2011-07-01',
90,
27),

('20888888888',
'Industrias Pacífico SA',
'IndPacífico',
'SA',
'Carlos Fernández Ruiz',
'Manufactura',
'Av. Faucett 340',
'150128',
'014567898',
'gerencia@indpacifico.com',
'2014-10-05',
'Activo',
'2014-11-01',
200,
28),

('20999999999',
'Grupo Sigma SAC',
'Sigma',
'SAC',
'José Herrera Soto',
'Servicios',
'Av. Aviación 880',
'150129',
'014567899',
'contacto@sigma.com',
'2018-04-16',
'Activo',
'2018-05-01',
40,
29),

('20121212121',
'Negocios Globales EIRL',
'Globales',
'EIRL',
'Pedro Rojas Campos',
'Consultoría',
'Av. Benavides 901',
'150130',
'014567900',
'info@globales.com',
'2017-09-12',
'Inactivo',
'2017-10-01',
15,
30),

('20131313131',
'Corporación Delta SAA',
'Delta Corp',
'SAA',
'Jorge Ramírez León',
'Finanzas',
'Av. Primavera 600',
'150131',
'014567901',
'contacto@delta.com',
'2008-05-06',
'Activo',
'2008-06-01',
450,
31),

('20141414141',
'Agro Perú SAC',
'AgroPer',
'SAC',
'Fernando Castro Vega',
'Agroindustria',
'Av. Industrial 100',
'150132',
'014567902',
'ventas@agroper.com',
'2013-08-08',
'Activo',
'2013-09-01',
130,
32),

('20151515151',
'Servicios Médicos Integrales SRL',
'SMI',
'SRL',
'Luis Medina Flores',
'Salud',
'Av. Arequipa 980',
'150133',
'014567903',
'contacto@smi.com',
'2019-03-14',
'Activo',
'2019-04-01',
80,
33),

('20161616161',
'Constructora Inca SA',
'Inca',
'SA',
'Juan Torres Silva',
'Construcción',
'Av. El Sol 780',
'150134',
'014567904',
'gerencia@inca.com',
'2010-07-21',
'Suspendido',
'2010-08-01',
300,
34),

('20171717171',
'Corporación Omega SAC',
'Omega',
'SAC',
'Ricardo Mendoza Rojas',
'Tecnología',
'Av. La Molina 500',
'150135',
'014567905',
'contacto@omega.com',
'2020-01-10',
'Activo',
'2020-02-01',
25,
35);

GO