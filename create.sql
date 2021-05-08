DROP TABLE IF EXISTS Reserva;
DROP TABLE IF EXISTS Precios;
DROP TABLE IF EXISTS se_celebra_en;/*Relaciona recintos con espectaculos*/
DROP TABLE IF EXISTS tiene;/*Relaciona recintos con gradas*/
DROP TABLE IF EXISTS se_agrupa_en;/*Relaciona gradas con localidades*/
DROP TABLE IF EXISTS paga;/*Relaciona clientes con gradas*/
DROP TABLE IF EXISTS reserva;/*Relaciona clientes con localidades*/
DROP TABLE IF EXISTS participan;/*Relaciona Espectaculos con Participantes*/
DROP TABLE IF EXISTS Gradas;
DROP TABLE IF EXISTS Localidades;
DROP TABLE IF EXISTS Recintos;
DROP TABLE IF EXISTS Participantes;
DROP TABLE IF EXISTS Espectaculo;
DROP TABLE IF EXISTS Clientes;


CREATE TABLE Gradas (
	nombre varchar(10) PRIMARY KEY NOT NULL,
	num_max_localidades INT NOT NULL
);

CREATE TABLE Espectaculo(
	nombre varchar(30) NOT NULL,
	descripcion varchar(100),
	tipo varchar(10),
	fecha datetime,
	duracion INT NOT NULL,
	propietario varchar(30),
	PRIMARY KEY (nombre,fecha)
);

CREATE TABLE Participantes (
	dni varchar(9) PRIMARY KEY NOT NULL,
	nombre varchar(30) NOT NULL,
	apellido1 varchar(30) NOT NULL,
	apellido2 varchar(30) NOT NULL,
	nombre_espectaculo varchar(30) NOT NULL,
	fecha datetime,
	FOREIGN KEY(nombre_espectaculo,fecha) REFERENCES Espectaculo(nombre,fecha)
);

CREATE TABLE Recintos(
	nombre varchar(30),
	localizacion varchar(100),
	tipo varchar(10),
	aforo INT NOT NULL,
	CONSTRAINT check_tipo_rec CHECK(tipo='estadio' OR tipo='pabellon' OR tipo='teatro'),
	PRIMARY KEY(nombre,localizacion)
);

CREATE TABLE Clientes (
	dni varchar(9) PRIMARY KEY NOT NULL,
	nombre varchar(30) NOT NULL,
	apellido1 varchar(30) NOT NULL,
	apellido2 varchar(30),
	iban varchar(24) NOT NULL,
	titular_nombre varchar(30) NOT NULL,
	titular_apellido1 varchar(30) NOT NULL,
	titular_apellido2 varchar(30) NOT NULL
);

CREATE TABLE Localidades(
	numero varchar(5) PRIMARY KEY NOT NULL,
	estado varchar(30),
	material varchar(30),
	visibilidad varchar(30)
);

CREATE TABLE se_celebra_en(
	nombre_recinto varchar(30) NOT NULL,
	localizacion varchar(100) NOT NULL,
	nombre_espectaculo varchar(30) NOT NULL,
	fecha_espectaculo datetime,
	FOREIGN KEY(nombre_recinto,localizacion) REFERENCES Recintos(nombre,localizacion),
	FOREIGN KEY(nombre_espectaculo,fecha_espectaculo) REFERENCES Espectaculo(nombre,fecha)
);

CREATE TABLE tiene(
	nombre_recinto varchar(30),
	nombre_grada varchar(10),
	FOREIGN KEY (nombre_recinto) REFERENCES Recintos(nombre),
	FOREIGN KEY (nombre_grada) REFERENCES Gradas (nombre) 
);

CREATE table participan(
	nombre_espectaculo varchar(30) NOT NULL,
	dni_participante varchar(9) NOT NULL,
	FOREIGN KEY(nombre_espectaculo) REFERENCES Participantes(dni),
	FOREIGN KEY(dni_participante) REFERENCES Espectaculo(nombre)
);

CREATE table paga(
	precio int not null,
	dni_cliente varchar(9) not null,
	nombre_grada varchar(10) not null,
	FOREIGN KEY(dni_cliente) REFERENCES Clientes(dni),
	FOREIGN KEY(nombre_grada) REFERENCES Gradas(nombre)
);

CREATE table se_agrupa_en(
	numero_localidad varchar(5) not null,
	nombre_grada varchar(10) not null,
	FOREIGN KEY(numero_localidad) REFERENCES Localidades(numero),
	FOREIGN KEY(nombre_grada) REFERENCES Gradas(nombre)
);


CREATE TABLE Reserva (
	id_reserva INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	instante timestamp,
	penaliza BOOLEAN DEFAULT FALSE,
	dni varchar(9) not null,
	nombre_espectaculo varchar(30),
	importe DECIMAL (6,2),
	FOREIGN KEY (nombre_espectaculo) REFERENCES Espectaculo(nombre),
	FOREIGN KEY (dni) REFERENCES Clientes(dni)
);

CREATE TABLE Precios (
	precio DECIMAL(6,2) NOT NULL,
	tipo_espectador varchar(10),
	nombre_grada varchar(10),
	nombre_espectaculo varchar(10),
	fecha datetime,
	PRIMARY KEY (tipo_espectador,nombre_grada,nombre_espectaculo,fecha),
	FOREIGN KEY(nombre_grada) REFERENCES Gradas(nombre),
	FOREIGN KEY(nombre_espectaculo,fecha) REFERENCES Espectaculo(nombre,fecha)
);