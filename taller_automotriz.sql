CREATE DATABASE tallerAutomotriz
GO

USE tallerAutomotriz
GO

CREATE TABLE cliente
(
  DNI               CHAR(8)      NOT NULL,
  nombres_completos VARCHAR(100) NOT NULL,
  telefono          VARCHAR(9)   NOT NULL,
  email             VARCHAR(50)  NOT NULL,
  CONSTRAINT PK_cliente PRIMARY KEY (DNI)
)
GO

ALTER TABLE cliente
  ADD CONSTRAINT UQ_cliente_telefono UNIQUE (telefono)
GO

ALTER TABLE cliente
  ADD CONSTRAINT UQ_cliente_email UNIQUE (email)
GO

CREATE TABLE marca
(
  codigo_marca INT         NOT NULL IDENTITY(1,1),
  nombre_marca VARCHAR(50) NOT NULL,
  CONSTRAINT PK_marca PRIMARY KEY (codigo_marca)
)
GO

ALTER TABLE marca
  ADD CONSTRAINT UQ_marca_nombre_marca UNIQUE (nombre_marca)
GO

CREATE TABLE taller
(
  codigo_taller INT          NOT NULL IDENTITY(1,1),
  nombre        VARCHAR(100) NOT NULL,
  direccion     VARCHAR(100) NOT NULL,
  telefono      VARCHAR(9)   NOT NULL,
  CONSTRAINT PK_taller PRIMARY KEY (codigo_taller)
)
GO

ALTER TABLE taller
  ADD CONSTRAINT UQ_taller_nombre UNIQUE (nombre)
GO

ALTER TABLE taller
  ADD CONSTRAINT UQ_taller_direccion UNIQUE (direccion)
GO

ALTER TABLE taller
  ADD CONSTRAINT UQ_taller_telefono UNIQUE (telefono)
GO

CREATE TABLE servicios
(
  codigo INT         NOT NULL IDENTITY(1,1),
  nombre VARCHAR(50) NOT NULL,
  CONSTRAINT PK_servicios PRIMARY KEY (codigo)
)
GO

ALTER TABLE servicios
  ADD CONSTRAINT UQ_servicios_nombre UNIQUE (nombre)
GO

CREATE TABLE repuestos
(
  codigo          INT          NOT NULL IDENTITY(1,1),
  nombre          VARCHAR(50)  NOT NULL,
  cantidad        INT          NOT NULL,
  precio_unitario DECIMAL(8,2) NOT NULL,
  CONSTRAINT PK_repuestos PRIMARY KEY (codigo)
)
GO

ALTER TABLE repuestos
  ADD CONSTRAINT UQ_repuestos_nombre UNIQUE (nombre)
GO

CREATE TABLE modelo
(
  codigo_modelo INT         NOT NULL IDENTITY(1,1),
  nombre_modelo VARCHAR(50) NOT NULL,
  codigo_marca  INT         NOT NULL,
  CONSTRAINT PK_modelo PRIMARY KEY (codigo_modelo)
)
GO

ALTER TABLE modelo
  ADD CONSTRAINT UQ_modelo_nombre_modelo UNIQUE (nombre_modelo)
GO

ALTER TABLE modelo
  ADD CONSTRAINT FK_marca_TO_modelo
    FOREIGN KEY (codigo_marca)
    REFERENCES marca (codigo_marca)
GO

CREATE TABLE mecanico
(
  DNI            CHAR(8)      NOT NULL,
  nombre_comleto varchar(100) NOT NULL,
  telefono       VARCHAR(9)   NOT NULL,
  especialidad   VARCHAR(50)  NOT NULL,
  codigo_taller  INT          NOT NULL,
  CONSTRAINT PK_mecanico PRIMARY KEY (DNI)
)
GO

ALTER TABLE mecanico
  ADD CONSTRAINT UQ_mecanico_DNI UNIQUE (DNI)
GO

ALTER TABLE mecanico
  ADD CONSTRAINT UQ_mecanico_telefono UNIQUE (telefono)
GO

ALTER TABLE mecanico
  ADD CONSTRAINT FK_taller_TO_mecanico
    FOREIGN KEY (codigo_taller)
    REFERENCES taller (codigo_taller)
GO

CREATE TABLE tarifa
(
  codigo           INT          NOT NULL IDENTITY(1,1),
  precio           DECIMAL(8,2) NOT NULL,
  servicios_codigo INT          NOT NULL,
  CONSTRAINT PK_tarifa PRIMARY KEY (codigo)
)
GO

ALTER TABLE tarifa
  ADD CONSTRAINT FK_servicios_TO_tarifa
    FOREIGN KEY (servicios_codigo)
    REFERENCES servicios (codigo)
GO

CREATE TABLE mecanico_servicios
(
  mecanico_DNI     CHAR(8) NOT NULL,
  servicios_codigo INT     NOT NULL
)
GO

ALTER TABLE mecanico_servicios
  ADD CONSTRAINT FK_mecanico_TO_mecanico_servicios
    FOREIGN KEY (mecanico_DNI)
    REFERENCES mecanico (DNI)
GO

ALTER TABLE mecanico_servicios
  ADD CONSTRAINT FK_servicios_TO_mecanico_servicios
    FOREIGN KEY (servicios_codigo)
    REFERENCES servicios (codigo)
GO

CREATE TABLE vehiculo
(
  numero_placa  VARCHAR(10) NOT NULL,
  numero_chasis CHAR(17)    NOT NULL,
  cliente_DNI   CHAR(8)     NOT NULL,
  codigo_modelo INT         NOT NULL,
  codigo_marca  INT         NOT NULL,
  CONSTRAINT PK_vehiculo PRIMARY KEY (numero_placa)
)
GO

ALTER TABLE vehiculo
  ADD CONSTRAINT UQ_vehiculo_numero_chasis UNIQUE (numero_chasis)
GO

ALTER TABLE vehiculo
  ADD CONSTRAINT FK_cliente_TO_vehiculo
    FOREIGN KEY (cliente_DNI)
    REFERENCES cliente (DNI)
GO

ALTER TABLE vehiculo
  ADD CONSTRAINT FK_modelo_TO_vehiculo
    FOREIGN KEY (codigo_modelo)
    REFERENCES modelo (codigo_modelo)
GO

ALTER TABLE vehiculo
  ADD CONSTRAINT FK_marca_TO_vehiculo
    FOREIGN KEY (codigo_marca)
    REFERENCES marca (codigo_marca)
GO

CREATE TABLE citas
(
  codigo        INT         NOT NULL IDENTITY(1,1),
  fecha_y_hora  DATETIME    NOT NULL,
  motivo        TEXT        NOT NULL,
  estado        VARCHAR(15) NOT NULL,
  cliente_DNI   CHAR(8)     NOT NULL,
  numero_placa  VARCHAR(10) NOT NULL,
  mecanico_DNI  CHAR(8)     NOT NULL,
  codigo_taller INT         NOT NULL,
  CONSTRAINT PK_citas PRIMARY KEY (codigo)
)
GO

ALTER TABLE citas
  ADD CONSTRAINT FK_cliente_TO_citas
    FOREIGN KEY (cliente_DNI)
    REFERENCES cliente (DNI)
GO

ALTER TABLE citas
  ADD CONSTRAINT FK_vehiculo_TO_citas
    FOREIGN KEY (numero_placa)
    REFERENCES vehiculo (numero_placa)
GO

ALTER TABLE citas
  ADD CONSTRAINT FK_mecanico_TO_citas
    FOREIGN KEY (mecanico_DNI)
    REFERENCES mecanico (DNI)
GO

ALTER TABLE citas
  ADD CONSTRAINT FK_taller_TO_citas
    FOREIGN KEY (codigo_taller)
    REFERENCES taller (codigo_taller)
GO

CREATE TABLE orden_de_trabajo
(
  codigo               INT         NOT NULL IDENTITY(1,1),
  fecha_y_hora_ingreso DATETIME    NOT NULL,
  fecha_entrega        DATETIME    NOT NULL,
  kilometraje          INT         NOT NULL,
  estado               VARCHAR(15) NOT NULL,
  citas_codigo         INT         NOT NULL,
  CONSTRAINT PK_orden_de_trabajo PRIMARY KEY (codigo)
)
GO

CREATE TABLE orden_repuestos
(
  repuestos_codigo        INT NOT NULL,
  orden_de_trabajo_codigo INT NOT NULL,
  CONSTRAINT PK_orden_repuestos PRIMARY KEY (repuestos_codigo, orden_de_trabajo_codigo)
)
GO

ALTER TABLE orden_de_trabajo
  ADD CONSTRAINT FK_citas_TO_orden_de_trabajo
    FOREIGN KEY (citas_codigo)
    REFERENCES citas (codigo)
GO


ALTER TABLE orden_repuestos
  ADD CONSTRAINT FK_repuestos_TO_orden_repuestos
    FOREIGN KEY (repuestos_codigo)
    REFERENCES repuestos (codigo)
GO

ALTER TABLE orden_repuestos
  ADD CONSTRAINT FK_orden_de_trabajo_TO_orden_repuestos
    FOREIGN KEY (orden_de_trabajo_codigo)
    REFERENCES orden_de_trabajo (codigo)
GO