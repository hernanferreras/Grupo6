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

-- 01 Creacion de la base de datos

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'bdd2025')
BEGIN 
    CREATE DATABASE bdd2025;
    PRINT 'La base de datos se creó correctamente';
END
ELSE
    PRINT 'La base de datos ya existe';
GO

USE bdd2025;
GO

-- 02 Creacion del esquema
	
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ddbba')
BEGIN
	EXEC('CREATE SCHEMA ddbba')
	PRINT 'El schema se creo correctamente'
END
ELSE
BEGIN
	PRINT 'El schema ya existe'
END;

-- 03 Creacion de las tablas

BEGIN TRY
	CREATE TABLE ddbba.Rol (
    	ID_Rol INT IDENTITY (1,1) PRIMARY KEY,
    	Descripcion VARCHAR(30),
	Nombre VARCHAR(60)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla ya Rol existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Usuario (
    	ID_Usuario INT IDENTITY(1,1) PRIMARY KEY,
	dni int CHECK (dni BETWEEN 100000 AND 99999999),
    	Nombre VARCHAR(50),
    	Apellido VARCHAR(50),
    	Email VARCHAR(50),
    	TelefonoContacto VARCHAR(20),
    	FechaNacimiento DATE,
    	Contrasenia VARCHAR(100),
    	ID_Rol INT,
    	FOREIGN KEY (ID_Rol) REFERENCES ddbba.Rol(ID_Rol)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Usuario ya existe'
END CATCH;
GO

BEGIN TRY	
	CREATE TABLE ddbba.Tutor (
		ID_Usuario INT PRIMARY KEY,
		FechaInicioTutoria DATE,
		FOREIGN KEY (ID_Usuario) REFERENCES ddbba.Usuario(ID_Usuario)   
	)
END TRY
BEGIN CATCH
	PRINT 'La tabla Tutor ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Profesor (
		ID_Usuario INT PRIMARY KEY,
		Especialidad VARCHAR(30),
		FOREIGN KEY (ID_Usuario) REFERENCES ddbba.Usuario(ID_Usuario)
	)
END TRY
BEGIN CATCH
	PRINT 'La tabla Profesor ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.GrupoFamiliar (
    		ID_GrupoFamiliar INT IDENTITY(1,1) PRIMARY KEY,
    		ID_Usuario INT,
		Nombre VARCHAR(100),
    		Descripcion VARCHAR(255),
		FOREIGN KEY (ID_Usuario) REFERENCES ddbba.Tutor(ID_Usuario)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla GrupoFamiliar ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Categoria (
    	ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    	Descripcion VARCHAR(100),
    	Importe DECIMAL(10, 2)
);
END TRY
BEGIN CATCH
	PRINT 'La tabla Categoria ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Socio (
		ID_Usuario INT PRIMARY KEY,
		telefonoEmergencia char(10),
    		ObraSocial VARCHAR(50),
    		nroSocioOSocial INT,
    		CategoriaID INT,
		ID_GrupoFamiliar INT,
		ParentescoConTutor CHAR(50),                              
    		FOREIGN KEY (ID_Usuario) REFERENCES ddbba.Usuario(ID_Usuario),
    		FOREIGN KEY (CategoriaID) REFERENCES ddbba.Categoria(ID_Categoria),
		FOREIGN KEY (ID_GrupoFamiliar) REFERENCES ddbba.GrupoFamiliar(ID_GrupoFamiliar)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Socio ya existe'
END CATCH;	
GO

BEGIN TRY
	CREATE TABLE ddbba.Cuenta (
    		ID_Usuario INT,
		NroCuenta INT,
    		FechaAlta DATE,
    		FechaBaja DATE,
    		Debito DECIMAL(10, 2),
    		Credito DECIMAL(10, 2),
		SALDO DECIMAL(10, 2),
		PRIMARY KEY (ID_Usuario, NroCuenta),
    		FOREIGN KEY (ID_Usuario) REFERENCES ddbba.Socio(ID_Usuario)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Cuenta ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Descuento (
    		ID_Descuento INT PRIMARY KEY,
    		Porcentaje DECIMAL(5, 2)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Descuento ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Costo (
    		ID_Costo INT PRIMARY KEY,
    		FechaIni DATE,
    		FechaFin DATE,
    		Monto DECIMAL(10,2)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Costo ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Cuota (
    		ID_Cuota INT PRIMARY KEY,
    		nroCuota INT,
    		Estado NVARCHAR(50),
   		ID_Costo INT UNIQUE,
    		FOREIGN KEY (ID_Costo) REFERENCES ddbba.Costo(ID_Costo)
);
END TRY
BEGIN CATCH
	PRINT 'La tabla Cuota ya existe'
END CATCH;
GO
	
BEGIN TRY
	CREATE TABLE ddbba.Factura (
    		ID_Factura INT PRIMARY KEY,
		ID_Cuota INT UNIQUE,
    		Numero VARCHAR(50),
    		FechaEmision DATE,
    		FechaVencimiento DATE,
    		TotalImporte DECIMAL(10,2),
    		Recargo DECIMAL(10,2),
    		Estado VARCHAR(30),
    		ID_Descuento INT, 
    		FOREIGN KEY (ID_Descuento) REFERENCES ddbba.Descuento(ID_Descuento),
		FOREIGN KEY (ID_Cuota) REFERENCES ddbba.Cuota(ID_Cuota)
);
END TRY
BEGIN CATCH
	PRINT 'La tabla Cuota ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.MedioDePago (
    		ID_MP INT PRIMARY KEY,
    		Tipo VARCHAR(15)  
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla MedioDePago ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Tarjeta (
    		ID INT PRIMARY KEY,  
    		NumeroTarjeta char(19),
    		FechaVenc DATE,
    		DebitoAutomatico BIT,
    		FOREIGN KEY (ID) REFERENCES ddbba.MedioDePago(ID_MP),
		CONSTRAINT ck_NumeroTarjeta CHECK(NumeroTarjeta LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);
END TRY
BEGIN CATCH 
	PRINT 'La Tabla Tarjeta ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Transferencia (
    		ID INT PRIMARY KEY,  
    		NumeroTransaccion NVARCHAR(50),
    		Tipo VARCHAR(50),
    		FOREIGN KEY (ID) REFERENCES ddbba.MedioDePago(ID_MP)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Transferencia ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Pago (
		ID_Pago INT IDENTITY(1,1) PRIMARY KEY,
		FechaPago DATE,
		Monto DECIMAL(10,2),
		ID_MedioDePago INT,
		NroCuenta INT,
		ID_Usuario INT,
		ID_Factura INT,
		FOREIGN KEY (ID_MedioDePago) REFERENCES ddbba.MedioDePago(ID_MP),
		FOREIGN KEY (ID_Factura) REFERENCES ddbba.Factura(ID_Factura),
		FOREIGN KEY (ID_Usuario, NroCuenta) REFERENCES ddbba.Cuenta(ID_Usuario, NroCuenta)
);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Pago ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE Reembolso (
    		ID_Reembolso INT PRIMARY KEY, 
		ID_Pago INT UNIQUE,
    		Descripcion VARCHAR(300),
    		Fecha DATE,
    		FOREIGN KEY (ID_Pago) REFERENCES ddbba.Pago(ID_Pago)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Reembolso ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Actividad (
    		ID_Actividad INT PRIMARY KEY,
    		Nombre VARCHAR(60),
    		Descripcion VARCHAR(255),
    		CostoMensual DECIMAL(10, 2) NOT NULL
);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Actividad ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Clase (
    		ID_Clase INT PRIMARY KEY,
    		HoraInicio TIME,
		HoraFin TIME,
		Dia DATE,
    		ID_Actividad INT,
    		ID_Profesor INT,
    		FOREIGN KEY (ID_Actividad) REFERENCES ddbba.Actividad(ID_Actividad),
    		FOREIGN KEY (ID_Profesor) REFERENCES ddbba.Usuario(ID_Usuario)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Clase ya existe'
END CATCH;
GO

BEGIN TRY
	CREATE TABLE ddbba.Clase_Profesor (
    		ID_Clase INT,
    		ID_Profesor INT,
    		PRIMARY KEY (ID_Clase, ID_Profesor),
    		FOREIGN KEY (ID_Clase) REFERENCES ddbba.Clase(ID_Clase),
    		FOREIGN KEY (ID_Profesor) REFERENCES ddbba.Profesor(ID_Usuario)
);
END TRY
BEGIN CATCH
	PRINT 'La tabla Profesor ya existe'
END CATCH;
GO

BEGIN TRY
    CREATE TABLE ddbba.ActividadExtra (
        ID INT PRIMARY KEY,
        Fecha DATE
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla ActividadExtra ya existe';
END CATCH;
GO

BEGIN TRY
    CREATE TABLE ddbba.Colonia (
        ID INT PRIMARY KEY,
        HoraInicio TIME,
        HoraFin TIME,
        Monto DECIMAL(10,2),
        FOREIGN KEY (ID) REFERENCES ddbba.ActividadExtra(ID)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla Colonia ya existe';
END CATCH;
GO

BEGIN TRY
    CREATE TABLE ddbba.AlquilerSUM (
        ID INT PRIMARY KEY,
        HoraInicio TIME,
        HoraFin TIME,
        Monto DECIMAL(10,2),
        FOREIGN KEY (ID) REFERENCES ddbba.ActividadExtra(ID)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla AlquilerSUM ya existe';
END CATCH;
GO

BEGIN TRY
    CREATE TABLE ddbba.PiletaVerano (
        ID INT PRIMARY KEY,
        FOREIGN KEY (ID) REFERENCES ddbba.ActividadExtra(ID)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla PiletaVerano ya existe';
END CATCH;
GO

BEGIN TRY
    CREATE TABLE ddbba.ItemFactura (
        ID_Factura INT,           
        ID_Item INT,          
        ID_Actividad INT,
        Descripcion VARCHAR(300),
        Importe DECIMAL(10,2),
        PRIMARY KEY (ID_Factura, ID_Item),
        FOREIGN KEY (ID_Factura) REFERENCES ddbba.Factura(ID_Factura),
        FOREIGN KEY (ID_Actividad) REFERENCES ddbba.Actividad(ID_Actividad)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla ItemFactura ya existe';
END CATCH;
GO

BEGIN TRY
    CREATE TABLE ddbba.Invitacion (                          --Podría ser una una ternaria con dos entidades usuarios, conectada con Pileta...?
        ID_Invitador INT,                              --SOCIO A SOCIO
        ID_Invitado INT,
        FechaInvitacion DATE,
        PRIMARY KEY (ID_Invitador, ID_Invitado),
        FOREIGN KEY (ID_Invitador) REFERENCES ddbba.Usuario(ID_Usuario),
        FOREIGN KEY (ID_Invitado) REFERENCES ddbba.Usuario(ID_Usuario)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla Invitacion ya existe';
END CATCH;
GO

BEGIN TRY
    CREATE TABLE ddbba.Invitado (                               --SOCIO A NO SOCIO
        ID_Invitado INT IDENTITY(1,1) PRIMARY KEY,
        ID_Usuario INT,
        ID_Pileta INT,
        FOREIGN KEY (ID_Usuario) REFERENCES ddbba.Usuario(ID_Usuario),
        FOREIGN KEY (ID_Pileta) REFERENCES ddbba.PiletaVerano(ID)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla Invitado ya existe';
END CATCH;
GO

--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------

--Stored Procedures
-----------------------------ROL
CREATE OR ALTER PROCEDURE insertar_rol
    @Descripcion VARCHAR(100),
    @Nombre VARCHAR(60)
AS
BEGIN
    INSERT INTO ddbba.Rol (Descripcion, Nombre)
    VALUES (@Descripcion, @Nombre);
END;
GO

CREATE OR ALTER PROCEDURE modificar_rol
    @ID_Rol INT,
    @Descripcion VARCHAR(100),
    @Nombre VARCHAR(60)
AS
BEGIN
    UPDATE ddbba.Rol
    SET Descripcion = @Descripcion,
        Nombre = @Nombre
    WHERE ID_Rol = @ID_Rol;
END;
GO

CREATE OR ALTER PROCEDURE borrar_rol
    @ID_Rol INT
AS
BEGIN
    DELETE FROM ddbba.Rol
    WHERE ID_Rol = @ID_Rol;
END;
GO

-----------------------------USUARIO
CREATE OR ALTER PROCEDURE insertar_usuario
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
    INSERT INTO ddbba.Usuario (
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
CREATE OR ALTER PROCEDURE modificar_usuario
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
    UPDATE ddbba.Usuario
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
CREATE OR ALTER PROCEDURE borrar_usuario
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM ddbba.Usuario WHERE ID_Usuario = @ID_Usuario;
END;
GO
-----------------------------TUTOR
CREATE OR ALTER PROCEDURE insertar_tutor
    @ID_Usuario INT,
    @FechaInicioTutoria DATE
AS
BEGIN
    INSERT INTO ddbba.Tutor (ID_Usuario, FechaInicioTutoria)
    VALUES (@ID_Usuario, @FechaInicioTutoria);
END;
GO

CREATE OR ALTER PROCEDURE modificar_tutor
    @ID_Usuario INT,
    @FechaInicioTutoria DATE
AS
BEGIN
    UPDATE ddbba.Tutor
    SET FechaInicioTutoria = @FechaInicioTutoria
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

CREATE OR ALTER PROCEDURE borrar_tutor
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM ddbba.Tutor
    WHERE ID_Usuario = @ID_Usuario;
END;
GO
-----------------------------PROFESOR
CREATE OR ALTER PROCEDURE insertar_profesor
    @ID_Usuario INT,
    @Especialidad VARCHAR(30)
AS
BEGIN
    INSERT INTO ddbba.Profesor (ID_Usuario, Especialidad)
    VALUES (@ID_Usuario, @Especialidad);
END;
GO

CREATE OR ALTER PROCEDURE modificar_profesor
    @ID_Usuario INT,
    @Especialidad VARCHAR(30)
AS
BEGIN
    UPDATE ddbba.Profesor
    SET Especialidad = @Especialidad
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

CREATE OR ALTER PROCEDURE borrar_profesor
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM ddbba.Profesor
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

-----------------------------GRUPO FAMILIAR
CREATE OR ALTER PROCEDURE insertar_grupo_familiar
    @ID_Usuario INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255)
AS
BEGIN
    INSERT INTO ddbba.GrupoFamiliar (ID_Usuario, Nombre, Descripcion)
    VALUES (@ID_Usuario, @Nombre, @Descripcion);
END;
GO

CREATE OR ALTER PROCEDURE modificar_grupo_familiar
    @ID_GrupoFamiliar INT,
    @ID_Usuario INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255)
AS
BEGIN
    UPDATE ddbba.GrupoFamiliar
    SET ID_Usuario = @ID_Usuario,
        Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar;
END;
GO

CREATE OR ALTER PROCEDURE borrar_grupo_familiar
    @ID_GrupoFamiliar INT
AS
BEGIN
    DELETE FROM ddbba.GrupoFamiliar
    WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar;
END;
GO

-----------------------------CATEGORIA
CREATE OR ALTER PROCEDURE insertar_categoria
    @Descripcion VARCHAR(100),
    @Importe DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ddbba.Categoria (Descripcion, Importe)
    VALUES (@Descripcion, @Importe);
END;
GO

CREATE OR ALTER PROCEDURE modificar_categoria
    @ID_Categoria INT,
    @Descripcion VARCHAR(100),
    @Importe DECIMAL(10, 2)
AS
BEGIN
    UPDATE ddbba.Categoria
    SET Descripcion = @Descripcion,
        Importe = @Importe
    WHERE ID_Categoria = @ID_Categoria;
END;
GO

CREATE OR ALTER PROCEDURE borrar_categoria
    @ID_Categoria INT
AS
BEGIN
    DELETE FROM ddbba.Categoria
    WHERE ID_Categoria = @ID_Categoria;
END;
GO

-----------------------------SOCIO
CREATE OR ALTER PROCEDURE insertar_socio
    @ID_Usuario INT,
    @telefonoEmergencia VARCHAR(20),
    @ObraSocial VARCHAR(100),
    @nroSocioOSocial INT,
    @CategoriaID INT,
    @ID_GrupoFamiliar INT,
    @ParentescoConTutor CHAR(50)
AS
BEGIN
    INSERT INTO ddbba.Socio (
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


CREATE OR ALTER PROCEDURE modificar_socio
    @ID_Usuario INT,
    @telefonoEmergencia VARCHAR(20),
    @ObraSocial VARCHAR(100),
    @nroSocioOSocial INT,
    @CategoriaID INT,
    @ID_GrupoFamiliar INT,
    @ParentescoConTutor CHAR(50)
AS
BEGIN
    UPDATE ddbba.Socio
    SET telefonoEmergencia = @telefonoEmergencia,
        ObraSocial = @ObraSocial,
        nroSocioOSocial = @nroSocioOSocial,
        CategoriaID = @CategoriaID,
        ID_GrupoFamiliar = @ID_GrupoFamiliar,
        ParentescoConTutor = @ParentescoConTutor
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

CREATE OR ALTER PROCEDURE borrar_socio
    @ID_Usuario INT
AS
BEGIN
    DELETE FROM ddbba.Socio
    WHERE ID_Usuario = @ID_Usuario;
END;
GO
-----------------------------cuenta
CREATE OR ALTER PROCEDURE insertar_cuenta
    @ID_Usuario INT,
    @NroCuenta INT,
    @FechaAlta DATE,
    @FechaBaja DATE,
    @Debito DECIMAL(10, 2),
    @Credito DECIMAL(10, 2),
    @Saldo DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ddbba.Cuenta (
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

CREATE OR ALTER PROCEDURE modificar_cuenta
    @ID_Usuario INT,
    @NroCuenta INT,
    @FechaAlta DATE,
    @FechaBaja DATE,
    @Debito DECIMAL(10, 2),
    @Credito DECIMAL(10, 2),
    @Saldo DECIMAL(10, 2)
AS
BEGIN
    UPDATE ddbba.Cuenta
    SET FechaAlta = @FechaAlta,
        FechaBaja = @FechaBaja,
        Debito = @Debito,
        Credito = @Credito,
        Saldo = @Saldo
    WHERE ID_Usuario = @ID_Usuario AND NroCuenta = @NroCuenta;
END;
GO

CREATE OR ALTER PROCEDURE borrar_cuenta
    @ID_Usuario INT,
    @NroCuenta INT
AS
BEGIN
    DELETE FROM ddbba.Cuenta
    WHERE ID_Usuario = @ID_Usuario AND NroCuenta = @NroCuenta;
END;
GO

--------------------------------DESCUENTO
CREATE OR ALTER PROCEDURE insertar_descuento
    @ID_Descuento INT,
    @Porcentaje DECIMAL(5, 2)
AS
BEGIN
    INSERT INTO ddbba.Descuento (ID_Descuento, Porcentaje)
    VALUES (@ID_Descuento, @Porcentaje);
END;
GO

CREATE OR ALTER PROCEDURE modificar_descuento
    @ID_Descuento INT,
    @Porcentaje DECIMAL(5, 2)
AS
BEGIN
    UPDATE ddbba.Descuento
    SET Porcentaje = @Porcentaje
    WHERE ID_Descuento = @ID_Descuento;
END;
GO


CREATE OR ALTER PROCEDURE borrar_descuento
    @ID_Descuento INT
AS
BEGIN
    DELETE FROM ddbba.Descuento
    WHERE ID_Descuento = @ID_Descuento;
END;
GO

CREATE OR ALTER PROCEDURE insertar_costo
    @ID_Costo INT,
    @FechaIni DATE,
    @FechaFin DATE,
    @Monto DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ddbba.Costo (ID_Costo, FechaIni, FechaFin, Monto)
    VALUES (@ID_Costo, @FechaIni, @FechaFin, @Monto);
END;
GO


CREATE OR ALTER PROCEDURE modificar_costo
    @ID_Costo INT,
    @FechaIni DATE,
    @FechaFin DATE,
    @Monto DECIMAL(10, 2)
AS
BEGIN
    UPDATE ddbba.Costo
    SET FechaIni = @FechaIni,
        FechaFin = @FechaFin,
        Monto = @Monto
    WHERE ID_Costo = @ID_Costo;
END;
GO

CREATE OR ALTER PROCEDURE borrar_costo
    @ID_Costo INT
AS
BEGIN
    DELETE FROM ddbba.Costo
    WHERE ID_Costo = @ID_Costo;
END;
GO

CREATE OR ALTER PROCEDURE insertar_cuota
    @ID_Cuota INT,
    @nroCuota INT,
    @Estado NVARCHAR(50),
    @ID_Costo INT
AS
BEGIN
    INSERT INTO ddbba.Cuota (ID_Cuota, nroCuota, Estado, ID_Costo)
    VALUES (@ID_Cuota, @nroCuota, @Estado, @ID_Costo);
END;
GO

CREATE OR ALTER PROCEDURE modificar_cuota
    @ID_Cuota INT,
    @nroCuota INT,
    @Estado NVARCHAR(50),
    @ID_Costo INT
AS
BEGIN
    UPDATE ddbba.Cuota
    SET nroCuota = @nroCuota,
        Estado = @Estado,
        ID_Costo = @ID_Costo
    WHERE ID_Cuota = @ID_Cuota;
END;
GO

CREATE OR ALTER PROCEDURE borrar_cuota
    @ID_Cuota INT
AS
BEGIN
    DELETE FROM ddbba.Cuota
    WHERE ID_Cuota = @ID_Cuota;
END;
GO

CREATE OR ALTER PROCEDURE ingresarPago
	@FechaPago DATE,
	@Monto DECIMAL(10,2),
	@ID_MedioDePago INT,
	@NroCuenta INT,
	@ID_Usuario INT,
	@ID_Factura INT
AS
BEGIN
	INSERT INTO ddbba.Pago(FechaPago,Monto,ID_MedioDePago, NroCuenta, ID_Usuario, ID_Factura) 
	VALUES (@FechaPago, @Monto, ID_MedioDePago, @NroCuenta, @ID_Usuario, @ID_Factura)
END;
GO

CREATE OR ALTER PROCEDURE borrarPago
    @ID_Pago INT
AS
BEGIN
    DELETE FROM ddbba.Pago
    WHERE ID_Pago = @ID_Pago;
END;
GO
