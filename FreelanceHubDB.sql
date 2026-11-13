CREATE DATABASE FreelanceHubDB
GO
USE FreelanceHubDB
GO

CREATE TABLE areas(
codigo INT,
nombre VARCHAR(30) NOT NULL,
CONSTRAINT PK_areas PRIMARY KEY (codigo)
);
GO

CREATE TABLE habilidades(
codigo INT,
nombre VARCHAR(30) NOT NULL,
CONSTRAINT PK_habilidades PRIMARY KEY (codigo)
);
GO

CREATE TABLE niveles(
codigo INT,
nombre VARCHAR(30) NOT NULL,
CONSTRAINT PK_niveles PRIMARY KEY (codigo)
);
GO

CREATE TABLE estado(
codigo INT,
nombre VARCHAR(30) NOT NULL,
CONSTRAINT PK_estado PRIMARY KEY (codigo)
);
GO

CREATE TABLE empresas(
codigo INT,
razon_social VARCHAR(30) NOT NULL,
ruc CHAR(11) NOT NULL,
correo_electronico VARCHAR(30) NOT NULL,
contrasenha VARCHAR(30) NOT NULL,
fecha_registro DATE NOT NULL,
CONSTRAINT PK_empresas PRIMARY KEY (codigo),
CONSTRAINT UQ_ruc_correo UNIQUE (ruc,correo_electronico)
);
GO

CREATE TABLE profesionales(
codigo INT,
nombre VARCHAR(30) NOT NULL,
correo_electronico VARCHAR(30) NOT NULL,
contrasenha VARCHAR(30) NOT NULL,
fecha_registro DATE NOT NULL,
CONSTRAINT PK_profesionales PRIMARY KEY (codigo),
CONSTRAINT UQ_profesion UNIQUE (correo_electronico)
);
GO

CREATE TABLE profesionales_areas(
codigo_profesionales INT,
codigo_area INT,
CONSTRAINT PK_profesion_area PRIMARY KEY (codigo_profesionales,codigo_area),
CONSTRAINT FK_codigo_profesion FOREIGN KEY (codigo_profesionales) REFERENCES profesionales (codigo) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FK_codigo_area FOREIGN KEY (codigo_area) REFERENCES areas (codigo) ON UPDATE CASCADE
);
GO

CREATE TABLE profesionales_habilidades(
codigo_profesional INT,
codigo_habilidad INT,
codigo_nivel INT,
CONSTRAINT PK_profesion_habilidad PRIMARY KEY (codigo_profesional,codigo_habilidad),
CONSTRAINT FK_cod_profesion FOREIGN KEY (codigo_profesional) REFERENCES profesionales (codigo) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT FK_cod_area FOREIGN KEY (codigo_habilidad) REFERENCES habilidades (codigo) ON UPDATE CASCADE,
CONSTRAINT FK_cod_nivel FOREIGN KEY (codigo_nivel) REFERENCES niveles (codigo) ON UPDATE CASCADE
);
GO

CREATE TABLE proyectos(
codigo INT,
titulo VARCHAR(30) NOT NULL,
descripcion VARCHAR(max) NOT NULL,
fecha_publicacion DATE NOT NULL,
fecha_limite DATE NOT NULL,
codigo_estado INT,
codigo_empresa INT,
CONSTRAINT PK_proyectos PRIMARY KEY (codigo),
CONSTRAINT FK_pro_estado FOREIGN KEY (codigo_estado) REFERENCES estado (codigo) ON UPDATE CASCADE,
CONSTRAINT FK_pro_empresa FOREIGN KEY (codigo_empresa) REFERENCES empresas (codigo) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT CK_fechas_pro CHECK (fecha_limite>fecha_publicacion)
);
GO

CREATE TABLE proyectos_areas(
codigo_proyecto INT,
codigo_area INT,
CONSTRAINT PK_proyecto_area PRIMARY KEY (codigo_proyecto,codigo_area),
CONSTRAINT FK_pro_ FOREIGN KEY (codigo_proyecto) REFERENCES proyectos (codigo) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT FK_ar FOREIGN KEY (codigo_area) REFERENCES areas (codigo) ON UPDATE CASCADE
);
GO

CREATE TABLE ofertas(
codigo INT,
fecha DATE NOT NULL,
presupuesto MONEY NOT NULL,
codigo_profesional INT,
codigo_proyecto INT,
CONSTRAINT PK_ofertas PRIMARY KEY (codigo),
CONSTRAINT FK_ofer_prof FOREIGN KEY (codigo_profesional) REFERENCES profesionales (codigo) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT FK_ofer_proy FOREIGN KEY (codigo_proyecto) REFERENCES proyectos (codigo) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT CK_fechas_ofer CHECK (presupuesto>0)
);
GO

CREATE TABLE ofertas_ganadoras(
codigo_oferta INT,
CONSTRAINT PK_of_gan PRIMARY KEY (codigo_oferta),
CONSTRAINT FK_cod_of FOREIGN KEY (codigo_oferta) REFERENCES ofertas (codigo) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE valoraciones(
codigo INT,
valoracion INT NOT NULL,
comentario VARCHAR(max) NULL,
codigo_oferta INT,
CONSTRAINT PK_valoraciones PRIMARY KEY (codigo),
CONSTRAINT FK_val_ofer FOREIGN KEY (codigo_oferta) REFERENCES ofertas_ganadoras (codigo_oferta) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT CK_valoracion CHECK (valoracion BETWEEN 1 AND 10)
);
GO