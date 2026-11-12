CREATE DATABASE BibliotecaUniDB
GO

USE BibliotecaUniDB
GO

CREATE TABLE Carrera (
    id_carrera INT,
    nombre VARCHAR(30) NOT NULL,
    titulo VARCHAR(30) NOT NULL,
    total_creditos INT NOT NULL,
    CONSTRAINT PK_Carrera PRIMARY KEY (id_carrera),
    CONSTRAINT CK_creditos CHECK (total_creditos>0)
);
GO

CREATE TABLE nacionalidad (
    id_nacionalidad INT,
    nacionalidad VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT PK_nacionalidad PRIMARY KEY (id_nacionalidad)
);
GO

CREATE TABLE Categorias (
    id_categoria INT,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Categorias PRIMARY KEY (id_categoria)
);
GO

CREATE TABLE Colaborador (
    id_colaborador CHAR(6),
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nac DATE NOT NULL,
    CONSTRAINT PK_Colaborador PRIMARY KEY (id_colaborador)
);
GO

CREATE TABLE Usuarios (
    id_usuario CHAR(6),
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    id_carrera INT NOT NULL,
    DNI CHAR(8),
    CONSTRAINT PK_Usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT FK_Usuarios_Carrera FOREIGN KEY (id_carrera) REFERENCES Carrera(id_carrera) ON UPDATE CASCADE,
    CONSTRAINT UQ_DNI UNIQUE (DNI)
);
GO

CREATE TABLE Autor (
    id_autor CHAR(6),
    nombre VARCHAR(50) NOT NULL,
    biografia VARCHAR(200) NOT NULL,
    id_nacionalidad INT NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    CONSTRAINT PK_Autor PRIMARY KEY (id_autor),
    CONSTRAINT FK_Autor_Nacionalidad FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad(id_nacionalidad) ON UPDATE CASCADE
);
GO

CREATE TABLE Libros (
    id_libro CHAR(6),
    titulo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    precio MONEY NOT NULL,
    idioma VARCHAR(50) NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT PK_Libros PRIMARY KEY (id_libro),
    CONSTRAINT FK_Libros_Categoria FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria) ON UPDATE CASCADE,
    CONSTRAINT CK_precio CHECK (precio>0)
);
GO

CREATE TABLE Prestamo (
    id_pedido INT,
    fecha_prestamo DATE NOT NULL,
    estado VARCHAR(30) NOT NULL,
    id_usuario CHAR(6) NOT NULL,
    total INT NOT NULL,
    id_colaborador CHAR(6) NOT NULL,
    fecha_devolucion DATE NOT NULL,
    CONSTRAINT PK_Prestamo PRIMARY KEY (id_pedido),
    CONSTRAINT FK_Prestamo_Usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON UPDATE CASCADE,
    CONSTRAINT FK_Prestamo_Colaborador FOREIGN KEY (id_colaborador) REFERENCES Colaborador(id_colaborador) ON UPDATE CASCADE,
    CONSTRAINT CK_Fecha CHECK (fecha_devolucion>fecha_prestamo),
    CONSTRAINT CK_total CHECK (total>0)
);
GO

CREATE TABLE Detalle_prestamo (
    id_pedido INT,
    id_libro CHAR(6) NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT PK_Detalle_prestamo PRIMARY KEY (id_pedido, id_libro),
    CONSTRAINT FK_Detalle_Prestamo FOREIGN KEY (id_pedido) REFERENCES Prestamo(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Detalle_Libro FOREIGN KEY (id_libro) REFERENCES Libros(id_libro) ON UPDATE CASCADE,
    CONSTRAINT CK_cant CHECK (cantidad>0)
);
GO

CREATE TABLE Libro_Autor (
    id_libro CHAR(6),
    id_autor CHAR(6) NOT NULL,
    posicion_autor INT NOT NULL,
    CONSTRAINT PK_Libro_Autor PRIMARY KEY (id_libro, id_autor),
    CONSTRAINT FK_LibroAutor_Libro FOREIGN KEY (id_libro) REFERENCES Libros(id_libro) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_LibroAutor_Autor FOREIGN KEY (id_autor) REFERENCES Autor(id_autor) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CK_pos_autor CHECK (posicion_autor>0)
);
GO