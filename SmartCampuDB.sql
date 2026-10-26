CREATE DATABASE SmartCampusDB
GO
USE DATABASE SmartCampusDB
GO

CREATE TABLE facultad (
id_facultad INT NOT NULL,
nombre VARCHAR(100) NOT NULL,
decanato VARCHAR(100) NOT NULL,
CONSTRAINT PK_facultad PRIMARY KEY (id_facultad)
);
GO
CREATE TABLE laboratorios (
id_laboratorio INT NOT NULL,
id_facultad INT NOT NULL,
nombre VARCHAR(100) NOT NULL,
pabellon VARCHAR(100) NOT NULL,
piso INT NOT NULL,
aforo_maximo INT NOT NULL,
CONSTRAINT PK_laboratorios PRIMARY KEY (id_laboratorio),
CONSTRAINT FK_laboratorios_facultad FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad),
CONSTRAINT CK_laboratorios_aforo CHECK (aforo_maximo>0)
);
GO
CREATE TABLE tipoEquipo (
id_tipo_equipo INT NOT NULL,
nombre VARCHAR(100) NOT NULL,
descripcion VARCHAR(250) NULL,
vida_util_anos INT NOT NULL,
CONSTRAINT PK_tipoEquipo PRIMARY KEY (id_tipo_equipo),
CONSTRAINT CK_tipoEquipo_vida CHECK (vida_util_anos>0)
);
GO
CREATE TABLE proveedor (
ruc CHAR(11) NOT NULL,
razon_social VARCHAR(100) NOT NULL,
correo VARCHAR(100) NOT NULL,
telefono VARCHAR(20) NOT NULL,
CONSTRAINT PK_proveedor PRIMARY KEY (ruc),
CONSTRAINT UQ_proveedor_correo UNIQUE (correo),
CONSTRAINT UQ_proveedor_telefono UNIQUE (telefono)
);
GO
CREATE TABLE equipoFisico (
nro_serie VARCHAR(50) NOT NULL,
id_tipo_equipo INT NOT NULL,
id_laboratorio INT NOT NULL,
ruc CHAR(11) NOT NULL,
fecha_adquisicion DATE NOT NULL,
estado VARCHAR(30) NOT NULL,
CONSTRAINT PK_equipoFisico PRIMARY KEY (nro_serie),
CONSTRAINT FK_equipoFisico_tipoEquipo FOREIGN KEY (id_tipo_equipo) REFERENCES tipoEquipo (id_tipo_equipo),
CONSTRAINT FK_equipoFisico_laboratorios FOREIGN KEY (id_laboratorio) REFERENCES laboratorios (id_laboratorio),
CONSTRAINT FK_equipoFisico_proveedor FOREIGN KEY (ruc) REFERENCES proveedor(ruc),
CONSTRAINT CK_equipoFisico_estado CHECK (estado IN ('Disponible','Prestamo','Mantenimiento'))
);
GO
CREATE TABLE operador (
dni VARCHAR(20) NOT NULL,
correo VARCHAR(100) NOT NULL,
nombres VARCHAR(100) NOT NULL,
apellidos VARCHAR(100) NOT NULL,
turnos VARCHAR(50) NOT NULL,
CONSTRAINT PK_operador PRIMARY KEY (dni),
CONSTRAINT UQ_operador_correo UNIQUE (correo)
);
GO
CREATE TABLE usuarioAcademico (
codigo_academico INT NOT NULL,
nombres VARCHAR(100) NOT NULL,
apellidos VARCHAR(100) NOT NULL,
correo VARCHAR(100) NOT NULL,
telefono VARCHAR(20) NOT NULL,
CONSTRAINT PK_usuarioAcademico PRIMARY KEY (codigo_academico),
CONSTRAINT UQ_usuarioAcademico_correo UNIQUE (correo),
CONSTRAINT UQ_usuarioAcademico_telefono UNIQUE (telefono)
);
GO
CREATE TABLE fichaPrestamos (
id_prestamo INT NOT NULL,
dni_operador VARCHAR(20) NOT NULL,
codigo_academico INT NOT NULL,
nro_serie VARCHAR(50) NOT NULL,
fecha_hora_solicitud DATETIME NOT NULL,
fecha_hora_estimada_devolucion DATETIME NOT NULL,
fecha_hora_real_devolucion DATETIME NULL,
CONSTRAINT PK_fichaPrestamos PRIMARY KEY (id_prestamo),
CONSTRAINT FK_fichaPrestamos_operador FOREIGN KEY (dni_operador) REFERENCES operador(dni),
CONSTRAINT FK_fichaPrestamos_usuarioAcademico FOREIGN KEY (codigo_academico) REFERENCES usuarioAcademico(codigo_academico),
CONSTRAINT FK_fichaPrestamos_equipoFisico FOREIGN KEY (nro_serie) REFERENCES equipoFisico(nro_serie),
CONSTRAINT CK_fichaPrestamos_FE CHECK (fecha_hora_estimada_devolucion>=fecha_hora_solicitud),
CONSTRAINT CK_fichaPrestamos_FR CHECK (fecha_hora_real_devolucion IS NULL OR fecha_hora_estimada_devolucion>=fecha_hora_solicitud)
);
GO
CREATE TABLE reporteIncidencias (
id_incidencia INT NOT NULL,
id_prestamo INT NOT NULL,
descripcion VARCHAR(250) NOT NULL,
fecha_reporte DATE NOT NULL,
costo_reparacion DECIMAL(6,2) NOT NULL,
CONSTRAINT PK_reporteIncidencias PRIMARY KEY (id_incidencia),
CONSTRAINT FK_RI_FP FOREIGN KEY (id_prestamo) REFERENCES fichaPrestamos(id_prestamo),
CONSTRAINT UQ_RI_prestamos UNIQUE (id_prestamo),
CONSTRAINT CK_RI_costos CHECK (costo_reparacion>=0)
);
GO