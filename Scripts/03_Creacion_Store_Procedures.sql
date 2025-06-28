/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/

-- ╔══════════════════════════════╗
-- ║ CREACION DE STORE PROCEDURES ║
-- ╚══════════════════════════════╝



-- ═══════════════ TABLA ROL ═══════════════ --

--- 01 CREACION DE PROCEDURE INSERTAR ROL
USE Com5600G06;
GO

CREATE OR ALTER PROCEDURE Administracion.InsertarRol
	@Nombre VARCHAR(30),    	
	@Descripcion VARCHAR(60),
	@Area VARCHAR(50)
AS
BEGIN
	INSERT INTO Administracion.Rol(Nombre, Descripcion, Area) VALUES(
		@Nombre,
		@Descripcion,
		@Area
	);
END;
GO

--- 02 CREACION DE PROCEDURE MODIFICAR ROL

CREATE OR ALTER PROCEDURE Administracion.ModificarRol
	@ID_Rol INT,
	@Nombre VARCHAR(30) = NULL,    	
	@Descripcion VARCHAR(60) = NULL,
	@Area VARCHAR(50) = NULL
AS
BEGIN
	UPDATE Administracion.Rol 
	SET
		Nombre = ISNULL(@Nombre, Nombre), 
		Descripcion = ISNULL(@Descripcion, Descripcion),
		Area = ISNULL(@Area, Area)
	WHERE ID_Rol = @ID_Rol
END;
GO

--- 03 CREACION DE PROCEDURE ELIMINAR ROL

CREATE OR ALTER PROCEDURE Administracion.EliminarRol
	@ID_Rol INT
AS
BEGIN
	DELETE
	FROM Administracion.Rol
	WHERE ID_Rol = @ID_Rol
END;
GO

-- ═══════════════ TABLA USUARIO ═══════════════ --

--- 04 CREACION DE PROCEDURE INSERTAR USUARIO

CREATE OR ALTER PROCEDURE Administracion.InsertarUsuario
    @NombreUsuario VARCHAR(50),
    @Contrasenia VARCHAR(100),
    @FechaVigenciaContrasenia DATE
AS
BEGIN
    INSERT INTO Administracion.Usuario (NombreUsuario, Contrasenia, FechaVigenciaContrasenia)
    VALUES (@NombreUsuario, 
			HASHBYTES('SHA2_256', CONVERT(VARBINARY(256), @Contrasenia)), 
			@FechaVigenciaContrasenia);
END;
GO

--- 05 CREACION DE PROCEDURE MODIFICAR USUARIO

CREATE OR ALTER PROCEDURE Administracion.ModificarUsuario
	@ID_Usuario INT,
    @NombreUsuario VARCHAR(50) = NULL,
    @Contrasenia VARCHAR(100) = NULL,
    @FechaVigenciaContrasenia DATE = NULL
AS
BEGIN
    IF @NombreUsuario IS NOT NULL AND EXISTS (
        SELECT 1
        FROM Administracion.Usuario
        WHERE NombreUsuario = @NombreUsuario
        AND ID_Usuario <> @ID_Usuario
    )
    BEGIN
        PRINT 'ERROR: El nombre de usuario ya está en uso por otro usuario.';
        RETURN;
    END;

UPDATE Administracion.Usuario
    SET
        NombreUsuario = ISNULL(@NombreUsuario, NombreUsuario),
        Contrasenia = HASHBYTES('SHA2_256', CONVERT(VARBINARY(256), @Contrasenia)),
        FechaVigenciaContrasenia = ISNULL(@FechaVigenciaContrasenia, FechaVigenciaContrasenia)
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

--- 06 CREACION DE PROCEDURE ELIMINAR USUARIO

CREATE OR ALTER PROCEDURE Administracion.EliminarUsuario
	@ID_Usuario INT	
AS
BEGIN
	DELETE
	FROM Administracion.Usuario
	WHERE ID_Usuario = @ID_Usuario
END;
GO

-- ═══════════════ TABLA GRUPO FAMILIAR ═══════════════ --

--- 07 CREACION PROCEDURE INSERTAR GRUPO FAMILIAR
	
CREATE OR ALTER PROCEDURE Personas.InsertarGrupoFamiliar
	@Tamaño INT,
	@Nombre VARCHAR(100)
AS
BEGIN	
	INSERT INTO Personas.GrupoFamiliar(Tamaño, Nombre) VALUES(
        	@Tamaño,
		@Nombre
	)
END;
GO

--- 08 CREACION PROCEDURE MODIFICAR GRUPO FAMILIAR
	
CREATE OR ALTER PROCEDURE Personas.ModificarGrupoFamiliar
	@ID_GrupoFamiliar INT,
	@Tamaño INT = NULL,
	@Nombre VARCHAR(100) = NULL
AS
BEGIN
	UPDATE Personas.GrupoFamiliar SET
		Tamaño = ISNULL(@Tamaño,Tamaño),
		Nombre = ISNULL(@Nombre, Nombre)
	WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar
END;
GO

--- 09 CREACION PROCEDURE ELIMINAR GRUPO FAMILIAR
CREATE OR ALTER PROCEDURE Personas.EliminarGrupoFamiliar
	@ID_GrupoFamiliar INT
AS
BEGIN
	DELETE
	FROM Personas.GrupoFamiliar
	WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar
END;
GO

-- ═══════════════ TABLA CATEGORIA ═══════════════ --
--- 10 CREACION PROCEDURE INSERTAR CATEGORIA

CREATE OR ALTER PROCEDURE Personas.InsertarCategoria
	@Descripcion VARCHAR(100),
	@Importe DECIMAL(10,2),	
	@FecVigenciaCosto DATE = NULL
AS
BEGIN
	INSERT INTO Personas.Categoria(Descripcion, Importe, FecVigenciaCosto) VALUES(
		@Descripcion,
		@Importe,
		@FecVigenciaCosto
	)
END;
GO

--- 11 CREACION PROCEDURE MODIFICAR CATEGORIA
	
CREATE OR ALTER PROCEDURE Personas.ModificarCategoria	
	@ID_Categoria INT = NULL,
	@Descripcion VARCHAR(100) = NULL,
	@Importe DECIMAL(10,2) = NULL
AS
BEGIN
	UPDATE Personas.Categoria SET
		Descripcion = ISNULL(@Descripcion, Descripcion),
		Importe = ISNULL(@Importe, Importe)
	WHERE ID_Categoria = @ID_Categoria
END;
GO

--- 12 CREACION PROCEDURE ELIMINAR CATEGORIA
CREATE OR ALTER PROCEDURE Personas.EliminarCategoria
	@ID_Categoria INT
AS
BEGIN
	DELETE
	FROM Personas.Categoria
	WHERE ID_Categoria = @ID_Categoria
END;
GO


-- ═══════════════ TABLA SOCIO ═══════════════ --

--- 13 CREACION PROCEDURE INSERTAR SOCIO

CREATE OR ALTER PROCEDURE Personas.InsertarSocio
	@ID_Socio VARCHAR(15),
    @DNI INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Email VARCHAR(50),
    @TelefonoContacto CHAR(30),
    @TelefonoEmergencia CHAR(30),
    @FechaNacimiento DATE,
    @ObraSocial VARCHAR(50),
    @NroSocioObraSocial VARCHAR(25),
    @TelefonoEmergenciaObraSocial CHAR(30),
    @ID_Categoria INT,
    @ID_GrupoFamiliar INT,
	@ID_Usuario INT
AS
BEGIN
    INSERT INTO Personas.Socio (
        ID_Socio, DNI, Nombre, Apellido, Email, TelefonoContacto,
        TelefonoEmergencia, FechaNacimiento, ObraSocial, NroSocioObraSocial,
        TelefonoEmergenciaObraSocial, ID_Categoria, ID_GrupoFamiliar, ID_Usuario
    )
    VALUES (
        @ID_Socio, @DNI, @Nombre, @Apellido, @Email, @TelefonoContacto,
        @TelefonoEmergencia, @FechaNacimiento, @ObraSocial, @NroSocioObraSocial,
        @TelefonoEmergenciaObraSocial, @ID_Categoria, @ID_GrupoFamiliar, @ID_Usuario
    );
END;
GO

--- 14 CREACION PROCEDURE MODIFICAR SOCIO

CREATE OR ALTER PROCEDURE Personas.ModificarSocio
    @ID_Socio VARCHAR(15),
    @DNI INT = NULL,
    @Nombre VARCHAR(50) = NULL,
    @Apellido VARCHAR(50) = NULL,
    @Email VARCHAR(50) = NULL,
    @TelefonoContacto CHAR(30) = NULL,
    @TelefonoEmergencia CHAR(30) = NULL,
    @FechaNacimiento DATE = NULL,
    @ObraSocial VARCHAR(50) = NULL,
    @NroSocioObraSocial VARCHAR(25) = NULL,
    @TelefonoEmergenciaObraSocial CHAR(30) = NULL,
    @ID_Categoria INT = NULL,
    @ID_GrupoFamiliar INT = NULL,
	@ID_Usuario INT = NULL
AS
BEGIN
	UPDATE Personas.Socio SET
		DNI = ISNULL(@DNI, DNI),
        Nombre = ISNULL(@Nombre, Nombre),
        Apellido = ISNULL(@Apellido, Apellido),
        Email = ISNULL(@Email, Email),
        TelefonoContacto = ISNULL(@TelefonoContacto, TelefonoContacto),
        TelefonoEmergencia = ISNULL(@TelefonoEmergencia, TelefonoEmergencia),
        FechaNacimiento = ISNULL(@FechaNacimiento, FechaNacimiento),
        ObraSocial = ISNULL(@ObraSocial, ObraSocial),
        NroSocioObraSocial = ISNULL(@NroSocioObraSocial, NroSocioObraSocial),
        TelefonoEmergenciaObraSocial = ISNULL(@TelefonoEmergenciaObraSocial, TelefonoEmergenciaObraSocial),
        ID_Categoria = ISNULL(@ID_Categoria, ID_Categoria),
        ID_GrupoFamiliar = ISNULL(@ID_GrupoFamiliar, ID_GrupoFamiliar),
		ID_Usuario = ISNULL(@ID_Usuario, ID_Usuario)
	WHERE ID_Socio = @ID_Socio
END;
GO

--- 15 CREACION PROCEDURE ELIMINAR SOCIO

CREATE OR ALTER PROCEDURE Personas.EliminarSocio
	@ID_Socio VARCHAR(15)
AS
BEGIN
	DELETE
	FROM Personas.Socio
	WHERE ID_Socio = @ID_Socio
END;
GO


-- ═══════════════ TABLA PROFESOR ═══════════════ --

--- 16 CREACION PROCEDURE INSERTAR PROFESOR

CREATE OR ALTER PROCEDURE Personas.InsertarProfesor
	@ID_Profesor VARCHAR(15),
	@DNI INT,
	@Especialidad VARCHAR(30),
	@Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Email VARCHAR(50),
    @TelefonoContacto CHAR(12)
AS
BEGIN
	INSERT INTO Personas.Profesor(ID_Profesor, DNI, Especialidad, Nombre, Apellido, Email, TelefonoContacto) VALUES(
		@ID_Profesor,
		@DNI,
		@Especialidad,
		@Nombre,
    	@Apellido,
    	@Email,
    	@TelefonoContacto
	)
END;
GO

--- 17 CREACION PROCEDURE MODIFICAR PROFESOR

CREATE OR ALTER PROCEDURE Personas.ModificarProfesor
	@ID_Profesor VARCHAR(15) = NULL,
	@DNI INT = NULL,
	@Especialidad VARCHAR(30) = NULL,
	@Nombre VARCHAR(50) = NULL,
    @Apellido VARCHAR(50) = NULL,
    @Email VARCHAR(50) = NULL,
    @TelefonoContacto CHAR(12) = NULL
AS
BEGIN
	UPDATE Personas.Profesor SET
	DNI = ISNULL(@DNI, DNI),
	Especialidad = ISNULL(@Especialidad, Especialidad),
	Nombre = ISNULL(@Nombre, Nombre),
	Apellido = ISNULL(@Apellido, Apellido),
	Email = ISNULL(@Email, Email),
	TelefonoContacto = ISNULL(@TelefonoContacto, TelefonoContacto)
	WHERE ID_Profesor = @ID_Profesor
END;
GO

--- 18 CREACION PROCEDURE ELIMINAR PROFESOR

CREATE OR ALTER PROCEDURE Personas.EliminarProfesor
	@ID_Profesor VARCHAR(15)
AS
BEGIN
	DELETE
	FROM Personas.Profesor
	WHERE ID_Profesor = @ID_Profesor
END;
GO

-- ═══════════════ TABLA CUENTA ═══════════════ --

--- 19 CREACION PROCEDURE INSERTAR CUENTA

CREATE OR ALTER PROCEDURE Facturacion.InsertarCuenta
		@ID_Socio VARCHAR(15),
		@NroCuenta INT,
        @FechaAlta DATE,
    	@FechaBaja DATE,
    	@Debito DECIMAL(10, 2),
    	@Credito DECIMAL(10, 2),
		@Saldo DECIMAL(10, 2)
AS
BEGIN	
	INSERT INTO Facturacion.Cuenta(ID_Socio, NroCuenta, FechaAlta, FechaBaja, Debito, Credito, Saldo) VALUES(
		@ID_Socio,
		@NroCuenta,
		@FechaAlta,
		@FechaBaja,
		@Debito,
		@Credito,
		@Saldo
	)
END;
GO

--- 20 CREACION PROCEDURE MODIFICAR CUENTA

CREATE OR ALTER PROCEDURE Facturacion.ModificarCuenta
		@ID_Socio VARCHAR(15),
		@NroCuenta INT = NULL,
        @FechaAlta DATE = NULL,
    	@FechaBaja DATE = NULL,
    	@Debito DECIMAL(10, 2) = NULL,
    	@Credito DECIMAL(10, 2) = NULL,
		@Saldo DECIMAL(10, 2) = NULL
AS
BEGIN
	UPDATE Facturacion.Cuenta SET
		NroCuenta = ISNULL(@NroCuenta, NroCuenta),
        FechaAlta = ISNULL(@FechaAlta, FechaAlta),
    	FechaBaja = ISNULL(@FechaBaja, FechaBaja),
    	Debito = ISNULL(@Debito, Debito),
    	Credito = ISNULL(@Credito, Credito),
		Saldo = ISNULL(@Saldo, Saldo)
	WHERE ID_Socio = @ID_Socio
END;
GO

--- 21 CREACION PROCEDURE ELIMINAR CUENTA

CREATE OR ALTER PROCEDURE Facturacion.EliminarCuenta
		@ID_Socio VARCHAR(15)
AS
BEGIN
		DELETE
		FROM Facturacion.Cuenta
		WHERE ID_Socio = @ID_Socio
END;
GO

-- ═══════════════ TABLA MEDIO DE PAGO ═══════════════ --

--- 22 CREACION PROCEDURE INSERTAR MEDIO DE PAGO

CREATE OR ALTER PROCEDURE Facturacion.InsertarMedioDePago
	@ID_MedioDePago INT,
	@Tipo VARCHAR(30)
AS
BEGIN
	INSERT INTO Facturacion.MedioDePago(ID_MedioDePago, Tipo) VALUES(
		@ID_MedioDePago,
		@Tipo
	)
END;
GO

--- 23 CREACION PROCEDURE MODIFICAR MEDIO DE PAGO
	
CREATE OR ALTER PROCEDURE Facturacion.ModificarMedioDePago	
	@ID_MedioDePago INT,
	@Tipo VARCHAR(30) = NULL
AS
BEGIN
	UPDATE Facturacion.MedioDePago SET
		Tipo = ISNULL(@Tipo, Tipo)
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 24 CREACION PROCEDURE ELIMINAR MEDIO DE PAGO
	
CREATE OR ALTER PROCEDURE Facturacion.EliminarMedioDePago
	@ID_MedioDePago INT
AS
BEGIN
	DELETE
	FROM Facturacion.MedioDePago
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

-- ═══════════════ TABLA TARJETA ═══════════════ --
--- 25 CREACION PROCEDURE INSERTAR TARJETA
	
CREATE OR ALTER PROCEDURE Facturacion.InsertarTarjeta
	@ID_MedioDePago INT,
	@NroTarjeta CHAR(19),
	@FechaVenc DATE,
	@DebitoAutomatico BIT
AS
BEGIN
	INSERT INTO Facturacion.Tarjeta(ID_MedioDePago, NroTarjeta, FechaVenc, DebitoAutomatico) VALUES(
		@ID_MedioDePago,
		@NroTarjeta,
		@FechaVenc,
		@DebitoAutomatico
	)
END;
GO

--- 26 CREACION PROCEDURE MODIFICAR TARJETA

CREATE OR ALTER PROCEDURE Facturacion.ModificarTarjeta
	@ID_MedioDePago INT
AS
BEGIN
	DELETE
	FROM Facturacion.MedioDePago
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 27 CREACION PROCEDURE ELIMINAR TARJETA

CREATE OR ALTER PROCEDURE Facturacion.EliminarTarjeta
	@NroTarjeta char(19)
AS
BEGIN
	DELETE
	FROM Facturacion.Tarjeta
	WHERE NroTarjeta = @NroTarjeta
END;
GO

-- ═══════════════ TABLA TRANSFERENCIA ═══════════════ --

--- 28 CREACION PROCEDURE INSERTAR TRANSFERENCIA
	
CREATE OR ALTER PROCEDURE Facturacion.InsertarTransferencia	
	@ID_MedioDePago INT,
	@NumeroTransaccion NVARCHAR(50)
AS
BEGIN
	INSERT INTO Facturacion.Transferencia(ID_MedioDePago, NumeroTransaccion) VALUES(
		@ID_MedioDePago,
		@NumeroTransaccion
	)
END;
GO

--- 29 CREACION PROCEDURE MODIFICAR TRANSFERENCIA

CREATE OR ALTER PROCEDURE Facturacion.ModificarTransferencia
	@ID_MedioDePago INT,
	@NumeroTransaccion NVARCHAR(50) = NULL
AS
BEGIN
	UPDATE Facturacion.Transferencia SET
		NumeroTransaccion = ISNULL(@NumeroTransaccion, NumeroTransaccion)
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 30 CREACION PROCEDURE ELIMINAR TRANSFERENCIA

CREATE OR ALTER PROCEDURE Facturacion.EliminarTransferencia
	@ID_MedioDePago INT
AS
BEGIN
	DELETE
	FROM Facturacion.Transferencia
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

-- ═══════════════ TABLA FACTURA ═══════════════ --

--- 31 CREACION DE PROCEDURE INSERTAR FACTURA

CREATE OR ALTER PROCEDURE Facturacion.InsertarFactura
	@ID_Factura INT,
	@Numero VARCHAR(50),
	@FechaEmision DATE,
	@FechaVencimiento DATE,
	@TotalImporte DECIMAL(10,2),
	@Recargo DECIMAL(10,2),
	@Estado VARCHAR(30),
	@ID_Cuota INT,
	@ID_Socio VARCHAR(15)
AS
BEGIN
	INSERT INTO Facturacion.Factura(ID_Factura, Numero, FechaEmision, FechaVencimiento, TotalImporte, Recargo, Estado, ID_Cuota, ID_Socio) VALUES(
		@ID_Factura,
		@Numero,
		@FechaEmision,
		@FechaVencimiento,
		@TotalImporte,
		@Recargo,
		@Estado,
		@ID_Cuota,
		@ID_Socio
	)
END;
GO

--- 32 CREACION DE PROCEDURE MODIFICAR FACTURA

CREATE OR ALTER PROCEDURE Facturacion.ModificarFactura
	@ID_Factura INT = NULL,
	@Numero VARCHAR(50) = NULL,
	@FechaEmision DATE = NULL,
	@FechaVencimiento DATE = NULL,
	@TotalImporte DECIMAL(10,2)= NULL,
	@Recargo DECIMAL(10,2)= NULL,
	@Estado VARCHAR(30) = NULL
AS
BEGIN
	UPDATE Facturacion.Factura SET
		Numero = ISNULL(@Numero, Numero),
		FechaEmision = ISNULL(@FechaEmision, FechaEmision),
		FechaVencimiento = ISNULL(@FechaVencimiento, FechaVencimiento),
		TotalImporte = ISNULL(@TotalImporte, TotalImporte),
		Recargo = ISNULL(@Recargo, Recargo),
		Estado = ISNULL(@Estado, Estado)
	WHERE ID_Factura = @ID_Factura
END;
GO

--- 33 CREACION DE PROCEDURE ELIMINAR FACTURA

CREATE OR ALTER PROCEDURE Facturacion.EliminarFactura
	@ID_Factura INT
AS
BEGIN
	DELETE
	FROM Facturacion.Factura
	WHERE ID_Factura = @ID_Factura
END;
GO


-- ═══════════════ TABLA PAGO ═══════════════ --

--- 34 CREACION DE PROCEDURE INSERTAR PAGO

CREATE OR ALTER PROCEDURE Facturacion.InsertarPago
		@ID_Pago INT,
		@FechaPago DATE,
		@Monto DECIMAL(10,2),
		@ID_MedioDePago INT,
		@NroCuenta INT,
		@ID_Socio VARCHAR(15),
		@ID_Factura INT
AS
BEGIN
	INSERT INTO Facturacion.Pago(ID_Pago, FechaPago, Monto, ID_MedioDePago, NroCuenta, ID_Socio, ID_Factura) VALUES(
		@ID_Pago,
		@FechaPago,
		@Monto,
		@ID_MedioDePago,
		@NroCuenta,
		@ID_Socio,
		@ID_Factura
	)
END;
GO

--- 35 CREACION DE PROCEDURE MODIFICAR PAGO
		
CREATE OR ALTER PROCEDURE Facturacion.ModificarPago		
		@ID_Pago INT,
		@FechaPago DATE,
		@Monto DECIMAL(10,2),
		@ID_MedioDePago INT,
		@NroCuenta INT,
		@ID_Socio VARCHAR(15),
		@ID_Factura INT
AS
BEGIN
	UPDATE Facturacion.Pago SET
		FechaPago = ISNULL(@FechaPago, FechaPago),
		Monto = ISNULL(@Monto, Monto),
		ID_MedioDePago = ISNULL(@ID_MedioDePago, ID_MedioDePago),
		NroCuenta = ISNULL(@NroCuenta, NroCuenta),
		ID_Socio = ISNULL(@ID_Socio, ID_Socio),
		ID_Factura = ISNULL(@ID_Factura, ID_Factura)
	WHERE ID_Pago = @ID_Pago
END;
GO

--- 36 CREACION DE PROCEDURE ELIMINAR PAGO

CREATE OR ALTER PROCEDURE Facturacion.EliminarPago
	@ID_Pago INT
AS
BEGIN
	DELETE 
	FROM Facturacion.Pago
	WHERE ID_Pago = @ID_Pago
END;
GO


-- ═══════════════ TABLA DESCUENTO ═══════════════ --

--- 37 CREACION DE PROCEDURE INSERTAR DESCUENTO

CREATE OR ALTER PROCEDURE Facturacion.InsertarDescuento
	@ID_Descuento INT,
	@Porcentaje DECIMAL(5,2),
	@ID_Factura INT
AS
BEGIN
	INSERT INTO Facturacion.Descuento(ID_Descuento, Porcentaje, ID_Factura) VALUES(
		@ID_Descuento,
		@Porcentaje,
		@ID_Factura
	)
END;
GO

--- 38 CREACION DE PROCEDURE MODIFICAR DESCUENTO

CREATE OR ALTER PROCEDURE Facturacion.ModificarDescuento
		@ID_Descuento INT,
		@Porcentaje DECIMAL(5,2) = NULL,
		@ID_Factura INT = NULL
AS
BEGIN
	UPDATE Facturacion.Descuento SET
		Porcentaje = ISNULL(@Porcentaje, Porcentaje),
		ID_Factura = ISNULL(@ID_Factura, ID_Factura)
	WHERE ID_Descuento = @ID_Descuento
END;
GO

--- 39 CREACION DE PROCEDURE ELIMINAR DESCUENTO

CREATE OR ALTER PROCEDURE Facturacion.EliminarDescuento
	@ID_Descuento INT
AS
BEGIN
	DELETE 
	FROM Facturacion.Descuento
	WHERE ID_Descuento = @ID_Descuento
END;
GO


-- ═══════════════ TABLA REEMBOLSO ═══════════════ --

--- 40 CREACION DE PROCEDURE INSERTAR REEMBOLSO

CREATE OR ALTER PROCEDURE Facturacion.InsertarReembolso
	@ID_Reembolso INT, 
	@Tipo NVARCHAR(30),   
        @ID_Pago INT,
    	@Descripcion VARCHAR(100),
    	@FechaReembolso DATE
AS
BEGIN
	INSERT INTO Facturacion.Reembolso(ID_Reembolso, Tipo, ID_Pago, Descripcion, FechaReembolso) VALUES(
		@ID_Reembolso, 
		@Tipo,   
        	@ID_Pago,
    		@Descripcion,
   		@FechaReembolso
	)
END;
GO

--- 41 CREACION DE PROCEDURE MODIFICAR REEMBOLSO

CREATE OR ALTER PROCEDURE Facturacion.ModificarReembolso
	@ID_Reembolso INT = NULL, 
	@Tipo NVARCHAR(30) = NULL,   
        @ID_Pago INT = NULL,
    	@Descripcion VARCHAR(100) = NULL,
    	@FechaReembolso DATE = NULL
AS
BEGIN
	UPDATE Facturacion.Reembolso SET 
		Tipo = ISNULL(@Tipo, Tipo),   
        	ID_Pago = ISNULL(@ID_Pago, ID_Pago),
    		Descripcion = ISNULL(@Descripcion, Descripcion),
    		FechaReembolso = ISNULL(@FechaReembolso, FechaReembolso)
	WHERE ID_Reembolso = @ID_Reembolso
END;
GO

--- 42 CREACION DE PROCEDURE ELIMINAR REEMBOLSO

CREATE OR ALTER PROCEDURE Facturacion.EliminarReembolso
	@ID_Reembolso INT
AS
BEGIN
	DELETE
	FROM Facturacion.Reembolso
	WHERE ID_Reembolso = @ID_Reembolso
END;
GO


-- ═══════════════ TABLA CUOTA ═══════════════ --

--- 43 CREACION DE PROCEDURE INSERTAR CUOTA

CREATE OR ALTER PROCEDURE Facturacion.InsertarCuota
	@ID_Cuota INT,
	@FecCuota DATE
AS
BEGIN
	INSERT INTO Facturacion.Cuota(ID_Cuota, FechaCuota) VALUES(
		@ID_Cuota,
		@FecCuota
	)
END;
GO

--- 44 CREACION DE PROCEDURE MODIFICAR CUOTA

CREATE OR ALTER PROCEDURE Facturacion.ModificarCuota
	@ID_Cuota INT,
	@FecCuota DATE = NULL
AS
BEGIN
	UPDATE Facturacion.Cuota SET
		FechaCuota = ISNULL(@FecCuota, FechaCuota)
	WHERE ID_Cuota = @ID_Cuota
END;
GO

--- 45 CREACION DE PROCEDURE ELIMINAR CUOTA

CREATE OR ALTER PROCEDURE Facturacion.EliminarCuota
	@ID_Cuota INT
AS
BEGIN
	DELETE
	FROM Facturacion.Cuota
	WHERE ID_Cuota = @ID_Cuota
END;
GO


-- ═══════════════ TABLA ACTIVIDAD ═══════════════ --

--- 46 CREACION DE PROCEDURE INSERTAR ACTIVIDAD

CREATE OR ALTER PROCEDURE Actividades.InsertarActividad
	@ID_Actividad INT,
   	@Nombre VARCHAR(50),
    	@Descripcion VARCHAR(100),
    	@CostoMensual DECIMAL(10, 2)
AS
BEGIN
	INSERT INTO Actividades.Actividad(ID_Actividad, Nombre, Descripcion, CostoMensual) VALUES(
		@ID_Actividad,
		@Nombre,
		@Descripcion,
		@CostoMensual
	)
END;
GO

--- 47 CREACION DE PROCEDURE MODIFICAR ACTIVIDAD

CREATE OR ALTER PROCEDURE Actividades.ModificarActividad
	@ID_Actividad INT = NULL,
    @Nombre VARCHAR(50) = NULL,
    @Descripcion VARCHAR(100) = NULL,
    @CostoMensual DECIMAL(10, 2) = NULL
AS
BEGIN
	UPDATE Actividades.Actividad SET
		Nombre = ISNULL(@Nombre, Nombre),
		Descripcion = ISNULL(@Descripcion, Descripcion),
		CostoMensual = ISNULL(@CostoMensual, CostoMensual)
	WHERE ID_Actividad = @ID_Actividad
END;
GO

--- 48 CREACION DE PROCEDURE ELIMINAR ACTIVIDAD

CREATE OR ALTER PROCEDURE Actividades.EliminarActividad
	@ID_Actividad INT
AS
BEGIN
	DELETE
	FROM Actividades.Actividad
	WHERE ID_Actividad = @ID_Actividad
END;
GO


-- ═══════════════ TABLA ACTIVIDAD REALIZADA ═══════════════ --

--- 49 CREACION DE PROCEDURE INSERTAR ACTIVIDAD REALIZADA

CREATE OR ALTER PROCEDURE Actividades.InsertarActividadRealizada
	@ID_Actividad INT,
	@ID_Socio VARCHAR(15),
	@FechaActividad DATE
AS
BEGIN
	INSERT INTO Actividades.ActividadRealizada(ID_Actividad, ID_Socio, FechaActividad) VALUES(
		@ID_Actividad,
		@ID_Socio,
		@FechaActividad
	)
END;
GO

--- 50 CREACION DE PROCEDURE MODIFICAR ACTVIDAD REALIZADA

CREATE OR ALTER PROCEDURE Actividades.ModificarActividadRealizada
	@ID_Socio VARCHAR(15),
	@ID_Actividad INT,
	@ID_Profesor VARCHAR(15),
	@FechaActividad DATE,
	@Asistencia CHAR(1) = NULL
AS
BEGIN
	UPDATE Actividades.ActividadRealizada SET
		Asistencia = ISNULL(@Asistencia, Asistencia)
    WHERE
        ID_Socio = @ID_Socio
        AND ID_Actividad = @ID_Actividad
        AND ID_Profesor = @ID_Profesor
        AND FechaActividad = @FechaActividad;
END;
GO

--- 51 CREACION DE PROCEDURE ELIMINAR ACTIVIDAD REALIZADA

CREATE OR ALTER PROCEDURE Actividades.EliminarActividadRealizada
	@ID_Socio VARCHAR(15),
    @ID_Actividad INT,
    @ID_Profesor VARCHAR(15),
    @FechaActividad DATE
AS
BEGIN
	DELETE
	FROM Actividades.ActividadRealizada
	WHERE ID_Socio = @ID_Socio AND
        ID_Actividad = @ID_Actividad AND
        ID_Profesor = @ID_Profesor AND
        FechaActividad = @FechaActividad;
END;
GO


-- ═══════════════ TABLA CLASE ═══════════════ --

--- 52 CREACION DE PROCEDURE INSERTAR CLASE

CREATE OR ALTER PROCEDURE Actividades.InsertarClase
	@ID_Clase INT,
    @Dia DATE,
    @HoraInicio TIME,
	@HoraFin TIME,
    @ID_Actividad INT
AS
BEGIN
	INSERT INTO Actividades.Clase(ID_Clase, Dia, HoraInicio, HoraFin, ID_Actividad) VALUES(
		@ID_Clase,
		@Dia,
		@HoraInicio,
		@HoraFin,
		@ID_Actividad
	)
END;
GO

--- 53 CREACION DE PROCEDURE MODIFICAR CLASE

CREATE OR ALTER PROCEDURE Actividades.ModificarClase
	@ID_Clase INT,
    @Dia DATE = NULL,
    @HoraInicio TIME = NULL,
	@HoraFin TIME = NULL,
    @ID_Actividad INT = NULL
AS
BEGIN
	UPDATE Actividades.Clase SET
		Dia = ISNULL(@Dia, Dia),
		HoraInicio = ISNULL(@HoraInicio, HoraInicio),
		HoraFin = ISNULL(@HoraFin, HoraFin),
		ID_Actividad = ISNULL(@ID_Actividad, ID_Actividad)
	WHERE ID_Clase = @ID_Clase
END;
GO

--- 54 CREACION DE PROCEDURE ELIMINAR

CREATE OR ALTER PROCEDURE Actividades.EliminarClase
	@ID_Clase INT
AS
BEGIN
	DELETE
	FROM Actividades.Clase
	WHERE ID_Clase = @ID_Clase
END;
GO


-- ═══════════════ TABLA CLASE DICTADA ═══════════════ --

--- 55 CREACION DE PROCEDURE INSERTAR CLASE DICTADA

CREATE OR ALTER PROCEDURE Actividades.InsertarClaseDictada
	@ID_Clase INT,
    @ID_Profesor INT,
    @FechaClase DATE
AS
BEGIN
	INSERT INTO Actividades.ClaseDictada(ID_Clase, ID_Profesor, FechaClase) VALUES(
		@ID_Clase,
		@ID_Profesor,
		@FechaClase
	)
END;
GO

--- 56 CREACION DE PROCEDURE MODIFICAR CLASE DICTADA

CREATE OR ALTER PROCEDURE Actividades.ModificarClaseDictada
	@ID_Clase INT,
    @ID_Profesor INT = NULL,
    @FechaClase DATE = NULL
AS
BEGIN
	UPDATE Actividades.ClaseDictada SET
		ID_Profesor = ISNULL(@ID_Profesor, ID_Profesor),
		FechaClase = ISNULL(@FechaClase, FechaClase)
	WHERE ID_Clase = @ID_Clase
END;
GO

--- 57 CREACION DE PROCEDURE ELIMINAR CLASE DICTADA

CREATE OR ALTER PROCEDURE Actividades.EliminarClaseDictada
	@ID_Clase INT
AS
BEGIN
	DELETE
	FROM Actividades.ClaseDictada
	WHERE ID_Clase = @ID_Clase
END;
GO


-- ═══════════════ TABLA ACTIVIDAD EXTRA ═══════════════ --

--- 58 CREACION DE PROCEDURE INSERTAR ACTIVIDAD EXTRA

CREATE OR ALTER PROCEDURE Actividades.InsertarActividadExtra
	@ID_ActividadExtra INT,
	@FechaActividadExtra DATE
AS
BEGIN
	INSERT INTO Actividades.ActividadExtra(ID_ActividadExtra, FechaActividadExtra) VALUES(
		@ID_ActividadExtra,
		@FechaActividadExtra
	)
END;
GO

--- 59 CREACION DE PROCEDURE MODIFICAR ACTIVIDAD EXTRA

CREATE OR ALTER PROCEDURE Actividades.ModificarActividadExtra
	@ID_ActividadExtra INT,
	@FechaActividadExtra DATE = NULL
AS
BEGIN
	UPDATE Actividades.ActividadExtra SET
		FechaActividadExtra = ISNULL(@FechaActividadExtra, FechaActividadExtra)
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 60 CREACION DE PROCEDURE ELIMINAR ACTIVIDAD EXTRA

CREATE OR ALTER PROCEDURE Actividades.EliminarActividadExtra
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE
	FROM Actividades.ActividadExtra
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO


-- ═══════════════ TABLA COLONIA ═══════════════ --

--- 61 CREACION DE PROCEDURE INSERTAR COLONIA

CREATE OR ALTER PROCEDURE Actividades.InsertarColonia
		@ID_ActividadExtra INT,
        @HoraInicio TIME,
        @HoraFin TIME,
        @Monto DECIMAL(10,2)
AS
BEGIN
	INSERT INTO Actividades.Colonia(ID_ActividadExtra, HoraInicio, HoraFin, Monto) VALUES(
		@ID_ActividadExtra,
        @HoraInicio,
        @HoraFin,
        @Monto
	)
END;
GO

--- 62 CREACION DE PROCEDURE MODIFICAR COLONIA

CREATE OR ALTER PROCEDURE Actividades.ModificarColonia
	@ID_ActividadExtra INT,
	@HoraInicio TIME = NULL, 
	@HoraFin TIME = NULL,
	@Monto DECIMAL(10,2) = NULL
AS 
BEGIN
	UPDATE Actividades.Colonia SET
		HoraInicio = ISNULL(@HoraInicio, HoraInicio),
		HoraFin = ISNULL(@HoraFin, HoraFin),
		Monto = ISNULL(@Monto, Monto)
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 63 CREACION DE PROCEDURE ELIMINAR COLONIA

CREATE OR ALTER PROCEDURE Actividades.EliminarColonia
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE
	FROM Actividades.Colonia
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO


-- ═══════════════ TABLA ALQUILER SUM ═══════════════ --

--- 64 CREACION DE PROCEDURE INSERTAR ALQUILER SUM

CREATE OR ALTER PROCEDURE Actividades.InsertarAlquilerSUM
	@ID_ActividadExtra INT,
	@HoraInicio TIME,
    	@HoraFin TIME,
    	@Monto DECIMAL(10,2)
AS
BEGIN
	INSERT INTO Actividades.AlquilerSUM(ID_ActividadExtra, HoraInicio, HoraFin, Monto) VALUES(
		@ID_ActividadExtra,
		@HoraInicio,
		@HoraFin,
		@Monto
	)
END;
GO

--- 65 CREACION DE PROCEDURE MODIFICAR ALQUIER SUM

CREATE OR ALTER PROCEDURE Actividades.ModificarAlquilerSUM
	@ID_ActividadExtra INT,
   	@HoraInicio TIME = NULL,
    	@HoraFin TIME = NULL,
    	@Monto DECIMAL(10,2) = NULL
AS
BEGIN
	UPDATE Actividades.AlquilerSUM SET
		HoraInicio = ISNULL(@HoraInicio, HoraInicio),
		HoraFin = ISNULL(@HoraFin, HoraFin),
		Monto = ISNULL(@Monto, Monto)	
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 66 CREACION DE PROCEDURE ELIMINAR ALQUILER SUM

CREATE OR ALTER PROCEDURE Actividades.EliminarAlquilerSUM
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE
	FROM ActividadExtra.AlquilerSUM
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO


-- ═══════════════ TABLA COSTOS PILETA ═══════════════ --

--- 67 CREACION DE PROCEDURE INSERTAR COSTOS PILETA

CREATE OR ALTER PROCEDURE Actividades.InsertarCostoPileta
	@ID_TarifaPileta INT,
    @CostoSocio DECIMAL (10,2),
    @CostoSocioMenor DECIMAL (10,2),
    @CostoInvitado DECIMAL (10,2),
    @CostoInvitadoMenor DECIMAL (10,2),
	@FecVigenciaCostos DATE
AS
BEGIN
	INSERT INTO Actividades.CostosPileta(ID_CostosPileta, CostoSocio, CostoSocioMenor, CostoInvitado, CostoInvitadoMenor, FecVigenciaCostos) 
	VALUES(
		@ID_TarifaPileta,
		@CostoSocio,
        @CostoSocioMenor,
        @CostoInvitado,
        @CostoInvitadoMenor,
		@FecVigenciaCostos
	)
END;
GO

--- 68 CREACION DE PROCEDURE MODIFICAR COSTOS PILETA

CREATE OR ALTER PROCEDURE Actividades.ModificarCostosPileta
	@ID_CostosPileta INT,
    @CostoSocio DECIMAL (10,2) = NULL,
    @CostoSocioMenor DECIMAL (10,2) = NULL,
    @CostoInvitado DECIMAL (10,2) = NULL,
    @CostoInvitadoMenor DECIMAL (10,2) = NULL,
	@FecVigenciaCostos DATE = NULL
AS
BEGIN
	UPDATE Actividades.CostosPileta SET
		CostoSocio = ISNULL(@CostoSocio, CostoSocio),
		CostoSocioMenor = ISNULL(@CostoSocioMenor, CostoSocioMenor),
		CostoInvitado = ISNULL(@CostoInvitado, CostoInvitado),
		CostoInvitadoMenor = ISNULL(@CostoInvitadoMenor, CostoInvitadoMenor),
		FecVigenciaCostos = ISNULL(@FecVigenciaCostos, FecVigenciaCostos)

	WHERE ID_CostosPileta = @ID_CostosPileta
END;
GO

--- 69 CREACION DE PROCEDURE ELIMINAR COSTOS PILETA

CREATE OR ALTER PROCEDURE Actividades.EliminarCostosPileta
	@ID_CostosPileta INT
AS
BEGIN	
	DELETE
	FROM Actividades.CostosPileta
	WHERE ID_CostosPileta = @ID_CostosPileta
END;
GO


-- ═══════════════ TABLA PILETA VERANO ═══════════════ --

--- 70 CREACION DE PROCEDURE INSERTAR PILETA VERANO

CREATE OR ALTER PROCEDURE Actividades.InsertarPiletaVerano
	@ID_ActividadExtra INT,
    @HoraInicio TIME,
    @HoraFin TIME,
    @CapacidadMaxima INT,
    @ID_CostosPileta INT
AS
BEGIN
	INSERT INTO Actividades.PiletaVerano(ID_ActividadExtra, HoraInicio, HoraFin, CapacidadMaxima, ID_CostosPileta) VALUES(
		@ID_ActividadExtra,
		@HoraInicio,
		@HoraFin,
		@CapacidadMaxima,
		@ID_CostosPileta
	)
END;
GO

--- 71 CREACION DE PROCEDURE MODIFICAR PILETA VERANO

CREATE OR ALTER PROCEDURE Actividades.ModificarPiletaVerano
	@ID_ActividadExtra INT,
    	@HoraInicio TIME = NULL,
    	@HoraFin TIME = NULL, 
    	@CapacidadMaxima INT = NULL,
    	@ID_CostosPileta INT = NULL
AS
BEGIN
	UPDATE Actividades.PiletaVerano SET
		HoraInicio = ISNULL(@HoraInicio, HoraInicio),
		HoraFin = ISNULL(@HoraFin, HoraFin),
		CapacidadMaxima = ISNULL(@CapacidadMaxima, CapacidadMaxima),
		ID_CostosPileta = ISNULL(@ID_CostosPileta, ID_CostosPileta)
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 72 CREACION DE PROCEDURE ELIMINAR PILETA VERANO

CREATE OR ALTER PROCEDURE Actividades.EliminarPiletaVerano
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE 
	FROM Actividades.PiletaVerano
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO


-- ═══════════════ TABLA ITEM FACTURA ═══════════════ --

--- 73 CREACION DE PROCEDURE INSERTAR ITEM FACTURA

CREATE OR ALTER PROCEDURE Facturacion.InsertarItemFactura
	@ID_Factura INT,           
    @ID_Item INT,          
    @ID_Actividad INT,
    @ID_ActividadExtra INT,
    @Descripcion VARCHAR(300),
    @Importe DECIMAL(10,2)
AS
BEGIN
	INSERT INTO Facturacion.ItemFactura(ID_Factura, ID_Item, ID_Actividad, ID_ActividadExtra, Descripcion, Importe) VALUES(
		@ID_Factura,           
		@ID_Item,          
		@ID_Actividad,
		@ID_ActividadExtra,
		@Descripcion,
		@Importe
	)
END;
GO

--- 74 CREACION DE PROCEDURE MODIFICAR ITEM FACTURA
	
CREATE OR ALTER PROCEDURE Facturacion.ModificarItemFactura
	@ID_Factura INT,           
    	@ID_Item INT = NULL,          
    	@ID_Actividad INT = NULL,
    	@ID_ActividadExtra INT = NULL,
    	@Descripcion VARCHAR(300) = NULL,
    	@Importe DECIMAL(10,2) = NULL
AS
BEGIN
	UPDATE Facturacion.ItemFactura SET
		ID_Item = ISNULL(@ID_Item, ID_Item),          
		ID_Actividad = ISNULL(@ID_Actividad, ID_Actividad),
		ID_ActividadExtra= ISNULL(@ID_ActividadExtra, ID_ActividadExtra),
		Descripcion = ISNULL(@Descripcion, Descripcion),
		Importe = ISNULL(@Importe, Importe)
	WHERE ID_Factura = @ID_Factura
END;
GO

--- 75 CREACION DE PROCEDURE ELIMINAR ITEM FACTURA

CREATE OR ALTER PROCEDURE Facturacion.EliminarItemFactura
	@ID_Factura INT
AS
BEGIN
	DELETE
	FROM Facturacion.ItemFactura
	WHERE ID_Factura = @ID_Factura
END;
GO


-- ═══════════════ TABLA INVITADO ═══════════════ --

--- 76 CREACION DE PROCEDURE INSERTAR INVITADO

CREATE OR ALTER PROCEDURE Personas.InsertarInvitado
		@ID_Socio VARCHAR(15),
        @ID_Pileta INT
AS
BEGIN
	INSERT INTO Personas.Invitado(ID_Socio, ID_Pileta) VALUES (
		@ID_Socio,
		@ID_Pileta
	)
END;
GO

--- 77 CREACION DE PROCEDURE MODIFICAR INVITADO

CREATE OR ALTER PROCEDURE Personas.ModificarInvitado
		@ID_Invitado INT,
		@ID_Socio VARCHAR(15) = NULL,
		@ID_Pileta INT = NULL
AS
BEGIN
	UPDATE Personas.Invitado SET
		ID_Socio = ISNULL(@ID_Socio, ID_Socio),
		ID_Pileta = ISNULL(@ID_Pileta, ID_Pileta)
	WHERE ID_Invitado = @ID_Invitado
END;
GO

--- 78 CREACION DE PROCEDURE ELIMINAR INVITADO

CREATE OR ALTER PROCEDURE Personas.EliminarInvitado
	@ID_Invitado VARCHAR(15)
AS
BEGIN
	DELETE
	FROM Personas.Invitado
	WHERE ID_Invitado = @ID_Invitado
END;
GO


-- ═══════════════ TABLA EMPLEADO ═══════════════ --

--- 79 CREACION DE PROCEDURE INSERTAR EMPLEADO
CREATE OR ALTER PROCEDURE Administracion.InsertarEmpleado
    @ID_Empleado VARCHAR(15),
	@DNI VARCHAR(50),
	@FecNac DATETIME,
	@FecIngreso DATETIME,
	@FecBaja DATETIME,
	@Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
	@Email NVARCHAR(100),
    @TelContacto VARCHAR(12),
	@ID_Rol INT,
	@ID_Usuario INT
AS
BEGIN
    DECLARE @FraseSecreta NVARCHAR(128) = 'ClaveGrupo06';

    INSERT INTO Administracion.Empleado (ID_Empleado, DNI, FechaNacimiento,
										FechaIngreso, FechaBaja, Nombre, Apellido, 
										Email, TelefonoContacto, ID_Rol, ID_Usuario)
    VALUES (
		@ID_Empleado,
		EncryptByPassPhrase(@FraseSecreta, @DNI),
		@FecNac,
		@FecIngreso,
		@FecBaja,
        EncryptByPassPhrase(@FraseSecreta, @Nombre),
        EncryptByPassPhrase(@FraseSecreta, @Apellido),
		ENCRYPTBYPASSPHRASE(@FraseSecreta, @Email),
		ENCRYPTBYPASSPHRASE(@FraseSecreta, @TelContacto),
		@ID_Rol,
		@ID_Usuario
    );
END;
GO

--- 80 CREACION DE PROCEDURE MODIFICAR EMPLEADO

CREATE OR ALTER PROCEDURE Administracion.ModificarEmpleado
    @ID_Empleado VARCHAR(15),
	@DNI INT,
	@FecNac DATE,
	@FecIngreso DATE,
	@FecBaja DATE,
	@Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
	@Email NVARCHAR(100),
    @TelContacto VARCHAR(12),
	@ID_Rol INT,
	@ID_Usuario INT
AS
BEGIN
    DECLARE @FraseSecreta NVARCHAR(128) = 'ClaveGrupo06';

    UPDATE Administracion.Empleado
    SET
        DNI                 = EncryptByPassPhrase(@FraseSecreta, CONVERT(NVARCHAR, @DNI)),
        FechaNacimiento     = @FecNac,
        FechaIngreso        = @FecIngreso,
        FechaBaja           = @FecBaja,
        Nombre              = EncryptByPassPhrase(@FraseSecreta, @Nombre),
        Apellido            = EncryptByPassPhrase(@FraseSecreta, @Apellido),
        Email               = EncryptByPassPhrase(@FraseSecreta, @Email),
        TelefonoContacto    = EncryptByPassPhrase(@FraseSecreta, @TelContacto),
        ID_Rol              = @ID_Rol,
        ID_Usuario          = @ID_Usuario
    WHERE ID_Empleado = @ID_Empleado;
END;
GO

--- 81 CREACION DE PROCEDURE ELIMINAR EMPLEADO

CREATE OR ALTER PROCEDURE Administracion.EliminarEmpleado
    @ID_Empleado VARCHAR(15)
AS
BEGIN
    DELETE FROM Administracion.Empleado
    WHERE ID_Empleado = @ID_Empleado;
END;
GO

