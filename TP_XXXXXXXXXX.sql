CREATE DATABASE SmartMoneyDB;
GO

USE SmartMoneyDB;
GO

CREATE TABLE Usuarios(
id_usuario VARCHAR(8) PRIMARY KEY,
nombre_usuario VARCHAR(100) NOT NULL,
edad_usuario INT CHECK (edad_usuario BETWEEN 18 AND 65),
genero_usuario VARCHAR(20) CHECK(genero_usuario IN('Masculino','Femenino','F','M','Otro')),
tipo_trabajo VARCHAR(100),
fecha_registro DATETIME DEFAULT GETDATE());
GO

CREATE TABLE Cuentas_Bancarias(
id_cuenta_banco VARCHAR(20) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
nombre_banco VARCHAR(100) NOT NULL,
dinero_cuenta DECIMAL(12,2) DEFAULT 0.00,
estado_actual_cuenta VARCHAR(20) CHECK(estado_actual_cuenta IN('Activa','Inactiva','Bloqueada','Cerrada','Embargada')),
tipo_categoria_cuenta VARCHAR(30) CHECK(tipo_categoria_cuenta IN('Cuenta de ahorros','Cuenta corriente','Cuenta Sueldo')),
CONSTRAINT FK_cuentas_usuarios FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

CREATE TABLE Categorias(
id_categoria INT IDENTITY(1,1) PRIMARY KEY,
tipo_servicio_invertido VARCHAR(50) NOT NULL,
ingreso_mensual_usuario DECIMAL(12,2) DEFAULT 0.00);
GO

CREATE TABLE Transacciones(
numero_transaccion INT IDENTITY(1,1) PRIMARY KEY,
id_cuenta_banco VARCHAR(20) NOT NULL,
id_categoria INT NOT NULL,
monto_ingreso_transaccion DECIMAL(12,2) DEFAULT 0.00,
monto_salida_transaccion DECIMAL(12,2) DEFAULT 0.00,
fecha_transaccion DATETIME DEFAULT GETDATE(),
CONSTRAINT FK_Transacciones_cuentas FOREIGN KEY(id_cuenta_banco)REFERENCES Cuentas_Bancarias(id_cuenta_banco),
CONSTRAINT FK_Transacciones_categorias FOREIGN KEY(id_categoria)REFERENCES Categorias(id_categoria));
GO

CREATE TABLE Presupuestos(
id_presupuestos INT IDENTITY(1,1) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
cantidad_presupuesto DECIMAL(12,2) DEFAULT 0.00 NOT NULL,
tipo_necesidad VARCHAR(50) NOT NULL,
CONSTRAINT Presupuestos_usuarios FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

CREATE TABLE Transacciones_Frecuentes(
id_transaccion_frecuente INT IDENTITY(1,1) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
transacciones_semanales INT DEFAULT 0,
transacciones_mensuales INT DEFAULT 0,
CONSTRAINT FK_Transacciones_frecuentes_usuarios FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

CREATE TABLE Metas_de_ahorro(
id_meta_ahorro INT IDENTITY(1,1) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
meta_ahorro DECIMAL(12,2) DEFAULT 0.00 NOT NULL,
porcentaje_ahorro_semanal DECIMAL (5,2),
porcentaje_ahorro_mensual DECIMAL(5,2),
porcentaje_ahorro_anterior DECIMAL(12,2),
CONSTRAINT FK_MetasAhorro_usuarios FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

CREATE TABLE Historial(
id_historial INT IDENTITY(1,1) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
historial_financiero_semanal DECIMAL(12,2),
historial_financiero_mensual DECIMAL(12,2),
grafico_estadistico_cambio_economia VARCHAR(200),
CONSTRAINT FK_Historial_usuarios FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

CREATE TABLE Notificaciones(
id_notificaciones INT IDENTITY(1,1) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
notificacion TEXT NOT NULL,
fecha_envio DATETIME DEFAULT GETDATE(),
CONSTRAINT FK_Notificaciones_usuario FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

CREATE TABLE Diagnosticos(
id_diagnosticos INT IDENTITY(1,1) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
diagnostico_ahorro TEXT,
calcular_ratio_decimal DECIMAL(5,2),
CONSTRAINT FK_Diagnosticos_usuario FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

CREATE TABLE Espacios_Compartidos(
id_espacio INT IDENTITY(1,1) PRIMARY KEY,
nombre_espacio VARCHAR(100) NOT NULL);
GO

CREATE TABLE Usuarios_Espacios(
id_usuario VARCHAR(8) NOT NULL,
id_espacio INT NOT NULL,
agrgar_usuario_familiar VARCHAR(100),
CONSTRAINT FK_UserEspacio_usuario FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
CONSTRAINT FK_UserEspacio_espacio FOREIGN KEY(id_espacio)REFERENCES Espacios_Compartidos(id_espacio) ON DELETE CASCADE);
GO

CREATE TABLE Funciones_Automaticas(
id_funcion INT IDENTITY(1,1) PRIMARY KEY,
id_usuario VARCHAR(8) NOT NULL,
registrar_ahorro_automatico BIT DEFAULT 0,
forma_manual BIT DEFAULT 1,
forma_automatica BIT DEFAULT 0,
CONSTRAINT FK_FunAut_usuario FOREIGN KEY(id_usuario)REFERENCES Usuarios(id_usuario) ON DELETE CASCADE);
GO

