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

CREATE TABLE Profesor (
	ID_Usuario INT PRIMARY KEY,
	Especialidad VARCHAR(30),
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
    ID_Actividad INT PRIMARY KEY,
    Nombre VARCHAR(60),
    Descripcion VARCHAR(255),
    CostoMensual DECIMAL(18, 2) NOT NULL
);
GO


CREATE TABLE Clase (
    ID_Clase INT PRIMARY KEY,
    HoraInicio TIME,
	HoraFin TIME,
	Dia DATE,
    ID_Actividad INT,
    ID_Profesor INT,
    FOREIGN KEY (ID_Actividad) REFERENCES Actividad(ID_Actividad),
    FOREIGN KEY (ID_Profesor) REFERENCES Usuario(ID_Usuario)
);
GO

CREATE TABLE Clase_Profesor (
    ID_Clase INT,
    ID_Profesor INT,
    PRIMARY KEY (ID_Clase, ID_Profesor),
    FOREIGN KEY (ID_Clase) REFERENCES Clase(ID_Clase),
    FOREIGN KEY (ID_Profesor) REFERENCES Profesor(ID_Usuario)
);
GO


--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------

--Stored Procedures
-----------------------------ROL
CREATE PROCEDURE insertar_rol
    @Descripcion VARCHAR(100),
    @Nombre VARCHAR(60)
AS
BEGIN
    INSERT INTO Rol (Descripcion, Nombre)
    VALUES (@Descripcion, @Nombre);
END;
GO

CREATE PROCEDURE modificar_rol
    @ID_Rol INT,
    @Descripcion VARCHAR(100),
    @Nombre VARCHAR(60)
AS
BEGIN
    UPDATE Rol
    SET Descripcion = @Descripcion,
        Nombre = @Nombre
    WHERE ID_Rol = @ID_Rol;
END;
GO

CREATE PROCEDURE borrar_rol
    @ID_Rol INT
AS
BEGIN
    DELETE FROM Rol
    WHERE ID_Rol = @ID_Rol;
END;
GO

-----------------------------USUARIO
CREATE PROCEDURE insertar_usuario
    @DNI VARCHAR(20),
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Email VARCHAR(100),
    @TelefonoContacto VARCHAR(20),
    @FechaNacimiento DATE,
    @Contrasenia VARCHAR(100),
    @ID_Rol INT
AS
BEGIN
    INSERT INTO Usuario (
        DNI, Nombre, Apellido, Email, TelefonoContacto,
        FechaNacimiento, Contrasenia, ID_Rol
    )
    VALUES (
        @DNI, @Nombre, @Apellido, @Email, @TelefonoContacto,
        @FechaNacimiento, @Contrasenia, @ID_Rol
    );
END;
GO

--MODIFICAR USAURIO
CREATE PROCEDURE modificar_usuario
    @ID_Usuario INT,
    @DNI VARCHAR(20),
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Email VARCHAR(100),
    @TelefonoContacto VARCHAR(20),
    @FechaNacimiento DATE,
    @Contrasenia VARCHAR(100),
    @ID_Rol INT
AS
BEGIN
    UPDATE Usuario
    SET DNI = @DNI,
        Nombre = @Nombre,
        Apellido = @Apellido,
        Email = @Email,
        TelefonoContacto = @TelefonoContacto,
        FechaNacimiento = @FechaNacimiento,
        Contrasenia = @Contrasenia,
        ID_Rol = @ID_Rol
    WHERE ID_Usuario = @ID_Usuario;
END;
GO
--BORRAR USUARIO
CREATE PROCEDURE borrar_usuario
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM Usuario WHERE ID_Usuario = @ID_Usuario;
END;
GO
-----------------------------TUTOR
CREATE PROCEDURE insertar_tutor
    @ID_Usuario INT,
    @FechaInicioTutoria DATE
AS
BEGIN
    INSERT INTO Tutor (ID_Usuario, FechaInicioTutoria)
    VALUES (@ID_Usuario, @FechaInicioTutoria);
END;
GO

CREATE PROCEDURE modificar_tutor
    @ID_Usuario INT,
    @FechaInicioTutoria DATE
AS
BEGIN
    UPDATE Tutor
    SET FechaInicioTutoria = @FechaInicioTutoria
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

CREATE PROCEDURE borrar_tutor
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM Tutor
    WHERE ID_Usuario = @ID_Usuario;
END;
GO
-----------------------------PROFESOR
CREATE PROCEDURE insertar_profesor
    @ID_Usuario INT,
    @Especialidad VARCHAR(30)
AS
BEGIN
    INSERT INTO Profesor (ID_Usuario, Especialidad)
    VALUES (@ID_Usuario, @Especialidad);
END;
GO

CREATE PROCEDURE modificar_profesor
    @ID_Usuario INT,
    @Especialidad VARCHAR(30)
AS
BEGIN
    UPDATE Profesor
    SET Especialidad = @Especialidad
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

CREATE PROCEDURE borrar_profesor
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM Profesor
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

-----------------------------GRUPO FAMILIAR
CREATE PROCEDURE insertar_grupo_familiar
    @ID_Usuario INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255)
AS
BEGIN
    INSERT INTO GrupoFamiliar (ID_Usuario, Nombre, Descripcion)
    VALUES (@ID_Usuario, @Nombre, @Descripcion);
END;
GO

CREATE PROCEDURE modificar_grupo_familiar
    @ID_GrupoFamiliar INT,
    @ID_Usuario INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255)
AS
BEGIN
    UPDATE GrupoFamiliar
    SET ID_Usuario = @ID_Usuario,
        Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar;
END;
GO

CREATE PROCEDURE borrar_grupo_familiar
    @ID_GrupoFamiliar INT
AS
BEGIN
    DELETE FROM GrupoFamiliar
    WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar;
END;
GO

-----------------------------CATEGORIA
CREATE PROCEDURE insertar_categoria
    @Descripcion VARCHAR(100),
    @Importe DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO Categoria (Descripcion, Importe)
    VALUES (@Descripcion, @Importe);
END;
GO

CREATE PROCEDURE modificar_categoria
    @ID_Categoria INT,
    @Descripcion VARCHAR(100),
    @Importe DECIMAL(18, 2)
AS
BEGIN
    UPDATE Categoria
    SET Descripcion = @Descripcion,
        Importe = @Importe
    WHERE ID_Categoria = @ID_Categoria;
END;
GO

CREATE PROCEDURE borrar_categoria
    @ID_Categoria INT
AS
BEGIN
    DELETE FROM Categoria
    WHERE ID_Categoria = @ID_Categoria;
END;
GO

-----------------------------SOCIO
CREATE PROCEDURE insertar_socio
    @ID_Usuario INT,
    @telefonoEmergencia VARCHAR(20),
    @ObraSocial VARCHAR(100),
    @nroSocioOSocial INT,
    @CategoriaID INT,
    @ID_GrupoFamiliar INT,
    @ParentescoConTutor CHAR(50)
AS
BEGIN
    INSERT INTO Socio (
        ID_Usuario,
        telefonoEmergencia,
        ObraSocial,
        nroSocioOSocial,
        CategoriaID,
        ID_GrupoFamiliar,
        ParentescoConTutor
    )
    VALUES (
        @ID_Usuario,
        @telefonoEmergencia,
        @ObraSocial,
        @nroSocioOSocial,
        @CategoriaID,
        @ID_GrupoFamiliar,
        @ParentescoConTutor
    );
END;
GO


CREATE PROCEDURE modificar_socio
    @ID_Usuario INT,
    @telefonoEmergencia VARCHAR(20),
    @ObraSocial VARCHAR(100),
    @nroSocioOSocial INT,
    @CategoriaID INT,
    @ID_GrupoFamiliar INT,
    @ParentescoConTutor CHAR(50)
AS
BEGIN
    UPDATE Socio
    SET telefonoEmergencia = @telefonoEmergencia,
        ObraSocial = @ObraSocial,
        nroSocioOSocial = @nroSocioOSocial,
        CategoriaID = @CategoriaID,
        ID_GrupoFamiliar = @ID_GrupoFamiliar,
        ParentescoConTutor = @ParentescoConTutor
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

CREATE PROCEDURE borrar_socio
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM Socio
    WHERE ID_Usuario = @ID_Usuario;
END;
GO
-----------------------------cuenta
CREATE PROCEDURE insertar_cuenta
    @ID_Usuario INT,
    @NroCuenta INT,
    @FechaAlta DATE,
    @FechaBaja DATE,
    @Debito DECIMAL(15, 2),
    @Credito DECIMAL(15, 2),
    @Saldo DECIMAL(15, 2)
AS
BEGIN
    INSERT INTO Cuenta (
        ID_Usuario,
        NroCuenta,
        FechaAlta,
        FechaBaja,
        Debito,
        Credito,
        Saldo
    )
    VALUES (
        @ID_Usuario,
        @NroCuenta,
        @FechaAlta,
        @FechaBaja,
        @Debito,
        @Credito,
        @Saldo
    );
END;
GO

CREATE PROCEDURE modificar_cuenta
    @ID_Usuario INT,
    @NroCuenta INT,
    @FechaAlta DATE,
    @FechaBaja DATE,
    @Debito DECIMAL(15, 2),
    @Credito DECIMAL(15, 2),
    @Saldo DECIMAL(15, 2)
AS
BEGIN
    UPDATE Cuenta
    SET FechaAlta = @FechaAlta,
        FechaBaja = @FechaBaja,
        Debito = @Debito,
        Credito = @Credito,
        Saldo = @Saldo
    WHERE ID_Usuario = @ID_Usuario AND NroCuenta = @NroCuenta;
END;
GO

CREATE PROCEDURE borrar_cuenta
    @ID_Usuario INT,
    @NroCuenta INT
AS
BEGIN
    DELETE FROM Cuenta
    WHERE ID_Usuario = @ID_Usuario AND NroCuenta = @NroCuenta;
END;
GO

--------------------------------DESCUENTO
CREATE PROCEDURE insertar_descuento
    @ID_Descuento INT,
    @Porcentaje DECIMAL(5, 2)
AS
BEGIN
    INSERT INTO Descuento (ID_Descuento, Porcentaje)
    VALUES (@ID_Descuento, @Porcentaje);
END;
GO

CREATE PROCEDURE modificar_descuento
    @ID_Descuento INT,
    @Porcentaje DECIMAL(5, 2)
AS
BEGIN
    UPDATE Descuento
    SET Porcentaje = @Porcentaje
    WHERE ID_Descuento = @ID_Descuento;
END;
GO


CREATE PROCEDURE borrar_descuento
    @ID_Descuento INT
AS
BEGIN
    DELETE FROM Descuento
    WHERE ID_Descuento = @ID_Descuento;
END;
GO

CREATE PROCEDURE insertar_costo
    @ID_Costo INT,
    @FechaIni DATE,
    @FechaFin DATE,
    @Monto DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Costo (ID_Costo, FechaIni, FechaFin, Monto)
    VALUES (@ID_Costo, @FechaIni, @FechaFin, @Monto);
END;
GO


CREATE PROCEDURE modificar_costo
    @ID_Costo INT,
    @FechaIni DATE,
    @FechaFin DATE,
    @Monto DECIMAL(10, 2)
AS
BEGIN
    UPDATE Costo
    SET FechaIni = @FechaIni,
        FechaFin = @FechaFin,
        Monto = @Monto
    WHERE ID_Costo = @ID_Costo;
END;
GO

CREATE PROCEDURE borrar_costo
    @ID_Costo INT
AS
BEGIN
    DELETE FROM Costo
    WHERE ID_Costo = @ID_Costo;
END;
GO

CREATE PROCEDURE insertar_cuota
    @ID_Cuota INT,
    @nroCuota INT,
    @Estado NVARCHAR(50),
    @ID_Costo INT
AS
BEGIN
    INSERT INTO Cuota (ID_Cuota, nroCuota, Estado, ID_Costo)
    VALUES (@ID_Cuota, @nroCuota, @Estado, @ID_Costo);
END;
GO

CREATE PROCEDURE modificar_cuota
    @ID_Cuota INT,
    @nroCuota INT,
    @Estado NVARCHAR(50),
    @ID_Costo INT
AS
BEGIN
    UPDATE Cuota
    SET nroCuota = @nroCuota,
        Estado = @Estado,
        ID_Costo = @ID_Costo
    WHERE ID_Cuota = @ID_Cuota;
END;
GO

CREATE PROCEDURE borrar_cuota
    @ID_Cuota INT
AS
BEGIN
    DELETE FROM Cuota
    WHERE ID_Cuota = @ID_Cuota;
END;
GO


