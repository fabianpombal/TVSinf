DROP TABLE IF EXISTS se_celebra_en;/*Relaciona recintos con espectaculos*/
DROP TABLE IF EXISTS tiene;/*Relaciona recintos con gradas*/
DROP TABLE IF EXISTS se_agrupa_en;/*Relaciona gradas con localidades*/
DROP TABLE IF EXISTS paga;/*Relaciona clientes con gradas*/
DROP TABLE IF EXISTS reserva;/*Relaciona clientes con localidades*/
DROP TABLE IF EXISTS participan;/*Relaciona Espectaculos con Participantes*/
DROP TABLE IF EXISTS Gradas;
DROP TABLE IF EXISTS Localidades;
DROP TABLE IF EXISTS Recintos;
DROP TABLE IF EXISTS Espectaculo;
DROP TABLE IF EXISTS Participantes;
DROP TABLE IF EXISTS Clientes;


CREATE TABLE Gradas (
	nombre_grada varchar(10) PRIMARY KEY NOT NULL,
	num_max_localidades INT NOT NULL
);

CREATE TABLE Espectaculo(
	nombre varchar(30) NOT NULL,
	anho INT NOT NULL,
	descripcion varchar(100),
	tipo varchar(10) NOT NULL,
	duracion INT NOT NULL,
	propietario varchar(30),
	CONSTRAINT check_anho CHECK(anho>1800 AND anho<2021),
	PRIMARY KEY (nombre,anho)
);

CREATE TABLE Participantes (
	dni varchar(9) PRIMARY KEY NOT NULL,
	nombre varchar(30) NOT NULL,
	apellido1 varchar(30) NOT NULL,
	apellido2 varchar(30) NOT NULL
	/*nombre_espectaculo varchar(30) NOT NULL,
	anho INT NOT NULL,
	CONSTRAINT check_anho CHECK(anho>1800 AND anho<2021),
	FOREIGN KEY(nombre_espectaculo,anho) REFERENCES Espectaculo(nombre,anho)*/
);

CREATE TABLE Recintos(
	nombre varchar(30),
	localizacion varchar(100),
	tipo varchar(10),
	aforo INT NOT NULL,
	CONSTRAINT check_tipo CHECK(tipo='estadio' OR tipo='pabellon' OR tipo='teatro'),
	PRIMARY KEY(nombre,localizacion)
);

CREATE TABLE Clientes (
	dni varchar(9) PRIMARY KEY NOT NULL,
	nombre varchar(30) NOT NULL,
	apellido1 varchar(30) NOT NULL,
	apellido2 varchar(30) NOT NULL,
	iban varchar(24) NOT NULL,
	titular_nombre varchar(30) NOT NULL,
	titular_apellido1 varchar(30) NOT NULL,
	titular_apellido2 varchar(30) NOT NULL
);

CREATE TABLE Localidades(
	numero INT PRIMARY KEY NOT NULL,
	estado varchar(30),
	material varchar(30),
	visibilidad varchar(30)
);

CREATE TABLE se_celebra_en(
	nombre_recinto varchar(30) NOT NULL,
	/*localizacion varchar(100) NOT NULL,*/
	nombre_espectaculo varchar(30) NOT NULL,
	anho INT NOT NULL,
	FOREIGN KEY(nombre_recinto) REFERENCES Recintos(nombre),/*MIRAR FOREIGN KEYS*/
	FOREIGN KEY(nombre_espectaculo) REFERENCES Espectaculo(nombre)
);

CREATE TABLE tiene(
	nombre_recinto varchar(30),
	nombre_grada varchar(10),
	FOREIGN KEY (nombre_recinto) REFERENCES Recintos(nombre),
	FOREIGN KEY (nombre_grada) REFERENCES Gradas (nombre_grada) 
);