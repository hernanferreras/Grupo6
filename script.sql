/*Entrega 4- Documento de instalación y configuración
Luego de decidirse por un motor de base de datos relacional, llegó el momento de generar la
base de datos. En esta oportunidad utilizarán SQL Server.
Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle
las configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos,
etc.) en un documento como el que le entregaría al DBA.
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar
un archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es
entregado en una sola ejecución). Incluya comentarios para indicar qué hace cada módulo
de código.
Genere store procedures para manejar la inserción, modificado, borrado (si corresponde,
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con “SP”.
Algunas operaciones implicarán store procedures que involucran varias tablas, uso de
transacciones, etc. Puede que incluso realicen ciertas operaciones mediante varios SPs.
Asegúrense de que los comentarios que acompañen al código lo expliquen.
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto
en la creación de objetos. NO use el esquema “dbo”.
Todos los SP creados deben estar acompañados de juegos de prueba. Se espera que
realicen validaciones básicas en los SP (p/e cantidad mayor a cero, CUIT válido, etc.) y que
en los juegos de prueba demuestren la correcta aplicación de las validaciones.
Las pruebas deben realizarse en un script separado, donde con comentarios se indique en
cada caso el resultado esperado
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha
de entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.
Entregar todo en un zip (observar las pautas para nomenclatura antes expuestas) mediante
la sección de prácticas de MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

# Grupo6
Fecha de entrega: 24/5/25
Trabajo Practico de la materia Bases de Datos Aplicadas, 1er cuatrimestre de 2025 en Universidad Nacional de La Matanza

Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
38670422  Céspedes  Leonel  ldc.mail2@gmail.com  ldcvelez
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
*/

create database bdd2025
use bdd2025

CREATE TABLE Rol (
    ID_Rol INT IDENTITY (1,1) PRIMARY KEY,
    Descripcion VARCHAR(100),
	Nombre VARCHAR(60)
);
GO

CREATE TABLE Usuario (
    ID_Usuario INT IDENTITY(1,1) PRIMARY KEY,
	DNI VARCHAR(20),
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Email VARCHAR(100),
    TelefonoContacto VARCHAR(20),
    FechaNacimiento DATE,
    Contrasenia VARCHAR(100),
    ID_Rol INT,
    FOREIGN KEY (ID_Rol) REFERENCES Rol(ID_Rol)
);
GO

CREATE TABLE Tutor (
	ID_Usuario INT PRIMARY KEY,
	FechaInicioTutoria DATE,
	FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)   
)
GO
CREATE TABLE GrupoFamiliar (
    ID_GrupoFamiliar INT IDENTITY(1,1) PRIMARY KEY,
    ID_Usuario INT,
	Nombre VARCHAR(100),
    Descripcion VARCHAR(255),
	FOREIGN KEY (ID_Usuario) REFERENCES Tutor(ID_Usuario)
);
GO

CREATE TABLE Categoria (
    ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100),
    Importe DECIMAL(18, 2)
);
GO

CREATE TABLE Socio (
	ID_Usuario INT PRIMARY KEY,
	telefonoEmergencia VARCHAR(20),
    ObraSocial VARCHAR(100),
    nroSocioOSocial INT,
    CategoriaID INT,
	ID_GrupoFamiliar INT,
	ParentescoConTutor CHAR(50),                              
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario),
    FOREIGN KEY (CategoriaID) REFERENCES Categoria(ID_Categoria),
	FOREIGN KEY (ID_GrupoFamiliar) REFERENCES GrupoFamiliar(ID_GrupoFamiliar)
);
GO

CREATE TABLE Cuenta (
    ID_Usuario INT,
	NroCuenta INT,
    FechaAlta DATE,
    FechaBaja DATE,
    Debito DECIMAL(15, 2),
    Credito DECIMAL(15, 2),
	SALDO DECIMAL(15, 2),
	PRIMARY KEY (ID_Usuario, NroCuenta),
    FOREIGN KEY (ID_Usuario) REFERENCES Socio(ID_Usuario)
);
GO

CREATE TABLE Descuento (
    ID_Descuento INT PRIMARY KEY,
    Porcentaje DECIMAL(5, 2)
);
GO

CREATE TABLE Costo (
    ID_Costo INT PRIMARY KEY,
    FechaIni DATE,
    FechaFin DATE,
    Monto DECIMAL(10,2)
);
GO

CREATE TABLE Cuota (
    ID_Cuota INT PRIMARY KEY,
    nroCuota INT,
    Estado NVARCHAR(50),
    ID_Costo INT UNIQUE,
    FOREIGN KEY (ID_Costo) REFERENCES Costo(ID_Costo)
);
GO

CREATE TABLE Factura (
    ID_Factura INT PRIMARY KEY,
	ID_Cuota INT UNIQUE,
    Numero VARCHAR(50),
    FechaEmision DATE,
    FechaVencimiento DATE,
    TotalImporte DECIMAL(15,2),
    Recargo DECIMAL(10,2),
    Estado VARCHAR(30),
    ID_Descuento INT, 
    FOREIGN KEY (ID_Descuento) REFERENCES Descuento(ID_Descuento),
	FOREIGN KEY (ID_Cuota) REFERENCES Cuota(ID_Cuota)
);
GO

CREATE TABLE MedioDePago (
    ID_MP INT PRIMARY KEY,
    Tipo VARCHAR(15)  
);
GO

CREATE TABLE Tarjeta (
    ID INT PRIMARY KEY,  
    NumeroTarjeta INT,
    FechaVenc DATE,
    DebitoAutomatico BIT,
    FOREIGN KEY (ID) REFERENCES MedioDePago(ID_MP)
);
GO

CREATE TABLE Transferencia (
    ID INT PRIMARY KEY,  
    NumeroTransaccion NVARCHAR(50),
    Tipo VARCHAR(50),
    FOREIGN KEY (ID) REFERENCES MedioDePago(ID_MP)
);
GO

CREATE TABLE Pago (
	ID_Pago INT IDENTITY(1,1) PRIMARY KEY,
	FechaPago DATE,
	Monto DECIMAL(15,2),
	ID_MedioDePago INT,
	NroCuenta INT,
	ID_Usuario INT,
	ID_Factura INT,
	FOREIGN KEY (ID_MedioDePago) REFERENCES MedioDePago(ID_MP),
	FOREIGN KEY (ID_Factura) REFERENCES Factura(ID_Factura),
	FOREIGN KEY (ID_Usuario, NroCuenta) REFERENCES Cuenta(ID_Usuario, NroCuenta)
)
GO

CREATE TABLE Reembolso (
    ID_Reembolso INT PRIMARY KEY, 
	ID_Pago INT UNIQUE,
    Descripcion VARCHAR(300),
    Fecha DATE,
    FOREIGN KEY (ID_Pago) REFERENCES Pago(ID_Pago)
);
GO

CREATE TABLE Actividad (
    ID INT PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Costo DECIMAL(18, 2) NOT NULL
);
GO


CREATE TABLE Clase (
    ID INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    ID_Actividad INT NOT NULL,
    DNI_Profesor INT NOT NULL,
    FOREIGN KEY (ID_Actividad) REFERENCES Actividad(ID),
    FOREIGN KEY (DNI_Profesor) REFERENCES Usuario(DNI)
);
GO

GO


--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------

--Stored Procedures


--INSERTAR USUARIO
CREATE PROCEDURE insertar_usuario
    @DNI INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Email NVARCHAR(100),
    @TelefonoContacto NVARCHAR(20),
    @FechaNacimiento DATE,
    @Contrasenia NVARCHAR(100),
    @ID_Rol INT
AS
BEGIN
    INSERT INTO Usuario VALUES (
        @DNI, @Nombre, @Apellido, @Email, @TelefonoContacto,
        @FechaNacimiento, @Contrasenia, @ID_Rol
    );
END;
GO

--MODIFICAR USAURIO
CREATE PROCEDURE modificar_usuario
    @DNI INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Email NVARCHAR(100),
    @TelefonoContacto NVARCHAR(20),
    @FechaNacimiento DATE,
    @Contrasenia NVARCHAR(100),
    @ID_Rol INT
AS
BEGIN
    UPDATE Usuario
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Email = @Email,
        TelefonoContacto = @TelefonoContacto,
        FechaNacimiento = @FechaNacimiento,
        Contrasenia = @Contrasenia,
        ID_Rol = @ID_Rol
    WHERE DNI = @DNI;
END;
GO

--BORRAR USUARIO
CREATE PROCEDURE borrar_usuario
    @DNI INT
AS
BEGIN
    DELETE FROM Usuario WHERE DNI = @DNI;
END;
GO
--INSERTAR CUENTA
CREATE PROCEDURE insertar_cuenta
    @ID INT,
    @Alias NVARCHAR(100),
    @CVU NVARCHAR(50),
    @Moneda NVARCHAR(10),
    @Saldo DECIMAL(18,2),
    @Estado NVARCHAR(50)
AS
BEGIN
    INSERT INTO Cuenta (ID, Alias, CVU, Moneda, Saldo, Estado)
    VALUES (@ID, @Alias, @CVU, @Moneda, @Saldo, @Estado);
END;
GO

--MODIFICAR CUENTA
CREATE PROCEDURE modificar_cuenta
    @ID INT,
    @Alias NVARCHAR(100),
    @CVU NVARCHAR(50),
    @Moneda NVARCHAR(10),
    @Saldo DECIMAL(18,2),
    @Estado NVARCHAR(50)
AS
BEGIN
    UPDATE Cuenta
    SET Alias = @Alias,
        CVU = @CVU,
        Moneda = @Moneda,
        Saldo = @Saldo,
        Estado = @Estado
    WHERE ID = @ID;
END;
GO

GO

--BORRAR CUENTA
CREATE PROCEDURE borrar_cuenta
    @ID INT
AS
BEGIN
    DELETE FROM Cuenta WHERE ID = @ID;
END;
GO

--INSERTAR GRUPO FAMILIAR
CREATE PROCEDURE insertar_grupo_familiar
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    INSERT INTO GrupoFamiliar (ID, Nombre, Descripcion)
    VALUES (@ID, @Nombre, @Descripcion);
END;
GO

--MODIFICAR GRUPO FAMILIAR
CREATE PROCEDURE modificar_grupo_familiar
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    UPDATE GrupoFamiliar
    SET Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE ID = @ID;
END;
GO

--BORRAR GRUPO FAMILIAR
CREATE PROCEDURE borrar_grupo_familiar
    @ID INT
AS
BEGIN
    DELETE FROM GrupoFamiliar WHERE ID = @ID;
END;
GO

--INSERTAR PERTENECE
CREATE PROCEDURE insertar_pertenece
    @ID_GrupoFamiliar INT,
    @DNI_Usuario INT,
    @Es_Titular BIT
AS
BEGIN
    INSERT INTO Pertenece (ID_GrupoFamiliar, DNI_Usuario, Es_Titular)
    VALUES (@ID_GrupoFamiliar, @DNI_Usuario, @Es_Titular);
END;
GO

--BORRAR PERTENECE
CREATE PROCEDURE borrar_pertenece
    @ID_GrupoFamiliar INT,
    @DNI_Usuario INT
AS
BEGIN
    DELETE FROM Pertenece
    WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar AND DNI_Usuario = @DNI_Usuario;
END;
GO

--INSERTAR TIENE
CREATE PROCEDURE insertar_tiene
    @DNI_Usuario INT,
    @ID_Cuenta INT
AS
BEGIN
    INSERT INTO Tiene (DNI_Usuario, ID_Cuenta)
    VALUES (@DNI_Usuario, @ID_Cuenta);
END;
GO

--BORRAR TIENE
CREATE PROCEDURE borrar_tiene
    @DNI_Usuario INT,
    @ID_Cuenta INT
AS
BEGIN
     DELETE FROM Tiene
    WHERE DNI_Usuario = @DNI_Usuario AND ID_Cuenta = @ID_Cuenta;
END;
GO

-- INSERTAR SOCIO
CREATE PROCEDURE insertar_socio
    @DNI INT,
    @FechaIngreso DATE,
    @Estado NVARCHAR(50)
AS
BEGIN
    INSERT INTO Socio (DNI, FechaIngreso, Estado)
    VALUES (@DNI, @FechaIngreso, @Estado);
END;
GO

-- MODIFICAR SOCIO
CREATE PROCEDURE modificar_socio
    @DNI INT,
    @FechaIngreso DATE,
    @Estado NVARCHAR(50)
AS
BEGIN
    UPDATE Socio
    SET FechaIngreso = @FechaIngreso,
        Estado = @Estado
    WHERE DNI = @DNI;
END;
GO

-- BORRAR SOCIO
CREATE PROCEDURE borrar_socio
    @DNI INT
AS
BEGIN
    DELETE FROM Socio WHERE DNI = @DNI;
END;
GO

-- INSERTAR CATEGORIA
CREATE PROCEDURE insertar_categoria
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    INSERT INTO Categoria (ID, Nombre, Descripcion)
    VALUES (@ID, @Nombre, @Descripcion);
END;
GO

-- MODIFICAR CATEGORIA
CREATE PROCEDURE modificar_categoria
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    UPDATE Categoria
    SET Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE ID = @ID;
END;
GO

-- BORRAR CATEGORIA
CREATE PROCEDURE borrar_categoria
    @ID INT
AS
BEGIN
    DELETE FROM Categoria WHERE ID = @ID;
END;
GO


-- INSERTAR ACTIVIDAD
CREATE PROCEDURE insertar_actividad
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @ID_Categoria INT
AS
BEGIN
    INSERT INTO Actividad (ID, Nombre, Descripcion, ID_Categoria)
    VALUES (@ID, @Nombre, @Descripcion, @ID_Categoria);
END;
GO

-- MODIFICAR ACTIVIDAD
CREATE PROCEDURE modificar_actividad
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @ID_Categoria INT
AS
BEGIN
    UPDATE Actividad
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        ID_Categoria = @ID_Categoria
    WHERE ID = @ID;
END;
GO

-- BORRAR ACTIVIDAD
CREATE PROCEDURE borrar_actividad
    @ID INT
AS
BEGIN
    DELETE FROM Actividad WHERE ID = @ID;
END;
GO

-- INSERTAR CLASE
CREATE PROCEDURE insertar_clase
    @ID INT,
    @ID_Actividad INT,
    @FechaHora DATETIME,
    @Duracion INT,
    @CupoMaximo INT,
    @Lugar NVARCHAR(100)
AS
BEGIN
    INSERT INTO Clase (ID, ID_Actividad, FechaHora, Duracion, CupoMaximo, Lugar)
    VALUES (@ID, @ID_Actividad, @FechaHora, @Duracion, @CupoMaximo, @Lugar);
END;
GO

-- MODIFICAR CLASE
CREATE PROCEDURE modificar_clase
    @ID INT,
    @ID_Actividad INT,
    @FechaHora DATETIME,
    @Duracion INT,
    @CupoMaximo INT,
    @Lugar NVARCHAR(100)
AS
BEGIN
    UPDATE Clase
    SET ID_Actividad = @ID_Actividad,
        FechaHora = @FechaHora,
        Duracion = @Duracion,
        CupoMaximo = @CupoMaximo,
        Lugar = @Lugar
    WHERE ID = @ID;
END;
GO

-- BORRAR CLASE
CREATE PROCEDURE borrar_clase
    @ID INT
AS
BEGIN
    DELETE FROM Clase WHERE ID = @ID;
END;
GO
