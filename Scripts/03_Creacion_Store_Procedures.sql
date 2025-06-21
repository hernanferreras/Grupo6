/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/

--- 01 CREA O MODIFICA SP insertar Rol
USE Com5600G06;
GO

CREATE OR ALTER PROCEDURE insertarRol
	@Nombre VARCHAR(30),    	
	@Descripcion VARCHAR(60)
AS
BEGIN
	INSERT INTO Administracion.Rol(Nombre, Descripcion) VALUES(
		@Nombre,
		@Descripcion
	);
END;
GO

--- 02 CREA O MODIFICA SP para modificar Rol 

CREATE OR ALTER PROCEDURE modificarRol
	@ID_Rol INT,
	@Nombre VARCHAR(30) = NULL,    	
	@Descripcion VARCHAR(60) = NULL
AS
BEGIN
	UPDATE Administracion.Rol 
	SET
		Nombre = ISNULL(@Nombre, Nombre), 
		Descripcion = ISNULL(@Descripcion, Descripcion)
	WHERE ID_Rol = @ID_Rol
END;
GO

--- 03 CREA O MODIFICA SP para eliminar Rol

CREATE OR ALTER PROCEDURE eliminarRol
	@ID_Rol INT
AS
BEGIN
	DELETE
	FROM Administracion.Rol
	WHERE ID_Rol = @ID_Rol
END;
GO

--- 04 CREACION DE PROCEDURE ingresarUsuario

CREATE OR ALTER PROCEDURE ingresarUsuario
    @NombreUsuario VARCHAR(50),
    @Contrasenia VARCHAR(100),
    @FechaVigenciaContrasenia DATE
AS
BEGIN
    INSERT INTO Administracion.Usuario (NombreUsuario, Contrasenia, FechaVigenciaContrasenia)
    VALUES (@NombreUsuario, @Contrasenia, @FechaVigenciaContrasenia);
END;
GO

--- 05 CREACION DE PROCEDURE modificarUsuario

CREATE OR ALTER PROCEDURE modificarUsuario
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
        Contrasenia = ISNULL(@Contrasenia, Contrasenia),
        FechaVigenciaContrasenia = ISNULL(@FechaVigenciaContrasenia, FechaVigenciaContrasenia)
    WHERE ID_Usuario = @ID_Usuario;
END;
GO

--- 06 CREACION DE PROCEDURE eliminarUsuario

CREATE OR ALTER PROCEDURE eliminarUsuario
	@ID_Usuario INT	
AS
BEGIN
	DELETE
	FROM Administracion.Usuario
	WHERE ID_Usuario = @ID_Usuario
END;
GO

--- 07 CREACION PROCEDURE ingresarGrupoFamiliar
	
CREATE OR ALTER PROCEDURE ingresarGrupoFamiliar
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

--- 08 CREACION PROCEDURE modificarGrupoFamiliar
	
CREATE OR ALTER PROCEDURE modificarGrupoFamiliar
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

--- 09 CREACION PROCEDURE eliminarGrupoFamiliar
CREATE OR ALTER PROCEDURE eliminarGrupoFamiliar
	@ID_GrupoFamiliar INT
AS
BEGIN
	DELETE
	FROM Personas.GrupoFamiliar
	WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar
END;
GO

--- 10 CREACION PROCEDURE ingresarCategoria

CREATE OR ALTER PROCEDURE ingresarCategoria
	@Descripcion VARCHAR(100),
	@Importe DECIMAL(10,2)
AS
BEGIN
	INSERT INTO Personas.Categoria(Descripcion, Importe) VALUES(
		@Descripcion,
		@Importe
	)
END;
GO

--- 11 CREACION PROCEDURE modificarCategoria
	
CREATE OR ALTER PROCEDURE modificarCategoria	
	@ID_Categoria INT = NULL,
	@Descripcion VARCHAR(100) = NULL,
	@Importe DECIMAL(10,2) = NULL
AS
BEGIN
	UPDATE Personas.Categoria SET
		Descripción = ISNULL(@Descripcion, Descripcion),
		Importe = ISNULL(@Importe, Importe)
	WHERE ID_Categoria = @ID_Categoria
END;
GO

--- 12 CREACION PROCEDURE eliminarCategoria
CREATE OR ALTER PROCEDURE eliminarCategoria
	@ID_Categoria INT
AS
BEGIN
	DELETE
	FROM Personas.Categoria
	WHERE ID_Categoria = @ID_Categoria
END;
GO

--- 13 CREACION PROCEDURE ingresarSocio

CREATE OR ALTER PROCEDURE ingresarSocio
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

--- 14 CREACION PROCEDURE modificarSocio

CREATE OR ALTER PROCEDURE modificarSocio
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

--- 15 CREACION PROCEDURE eliminarSocio

CREATE OR ALTER PROCEDURE eliminarSocio
	@ID_Socio INT
AS
BEGIN
	DELETE
	FROM Personas.Socio
	WHERE ID_Socio = @ID_Socio
END;
GO

--- 16 CREACION PROCEDURE ingresarProfesor

CREATE OR ALTER PROCEDURE ingresarProfesor
	@DNI INT,
	@Especialidad VARCHAR(30),
	@Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Email VARCHAR(50),
    @TelefonoContacto CHAR(12)
AS
BEGIN
	INSERT INTO Personas.Profesor(DNI, Especialidad, Nombre, Apellido, Email, TelefonoContacto) VALUES(
		@DNI,
		@Especialidad,
		@Nombre,
    		@Apellido,
    		@Email,
    		@TelefonoContacto
	)
END;
GO

--- 17 CREACION PROCEDURE modificarProfesor

CREATE OR ALTER PROCEDURE modificarProfesor
	@ID_Profesor INT = NULL,
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
	WHERE ID_PRofesor = @ID_Profesor
END;
GO

--- 18 CREACION PROCEDURE eliminarProfesor

CREATE OR ALTER PROCEDURE eliminarProfesor
	@ID_Profesor INT
AS
BEGIN
	DELETE
	FROM Personas.Profesor
	WHERE ID_Profesor = @ID_Profesor
END;
GO

--- 19 CREACION PROCEDURE ingresarCuenta

CREATE OR ALTER PROCEDURE ingresarCuenta
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

--- 20 CREACION PROCEDURE modificarCuenta

CREATE OR ALTER PROCEDURE modificarCuenta
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

--- 21 CREACION PROCEDURE eliminarCuenta

CREATE OR ALTER PROCEDURE eliminarCuenta
		@ID_Socio VARCHAR(15)
AS
BEGIN
		DELETE
		FROM Facturacion.Cuenta
		WHERE ID_Socio = @ID_Socio
END;
GO

--- 22 CREACION PROCEDURE ingresarMedioDePago

CREATE OR ALTER PROCEDURE ingresarMedioDePago
	@ID_MedioDePago INT,
	@Tipo VARCHAR(15)
AS
BEGIN
	INSERT INTO Facturacion.MedioDePago(ID_MedioDePago, Tipo) VALUES(
		@ID_MedioDePago,
		@Tipo
	)
END;
GO

--- 23 CREACION PROCEDURE modificarMedioDePago
	
CREATE OR ALTER PROCEDURE modificarMedioDePago	
	@ID_MedioDePago INT,
	@Tipo VARCHAR(15) = NULL
AS
BEGIN
	UPDATE Facturacion.MedioDePago SET
		Tipo = ISNULL(@Tipo, Tipo)
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 24 CREACION PROCEDURE eliminarMedioDePago
	
CREATE OR ALTER PROCEDURE eliminarMedioDePago
	@ID_MedioDePago INT
AS
BEGIN
	DELETE
	FROM Facturacion.MedioDePago
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 25 CREACION PROCEDURE ingresoTarjeta
	
CREATE OR ALTER PROCEDURE ingresoTarjeta	
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

--- 26 CREACION PROCEDURE modificarTarjeta

CREATE OR ALTER PROCEDURE eliminarMedioDePago
	@ID_MedioDePago INT
AS
BEGIN
	DELETE
	FROM Facturacion.MedioDePago
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 27 CREACION PROCEDURE eliminarTarjeta

CREATE OR ALTER PROCEDURE eliminarTarjeta
	@NroTarjeta char(19)
AS
BEGIN
	DELETE
	FROM Facturacion.Tarjeta
	WHERE NroTarjeta = @NroTarjeta
END;
GO

--- 28 CREACION PROCEDURE ingresarTransferencia
	
CREATE OR ALTER PROCEDURE ingresarTransferencia	
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

--- 29 CREACION PROCEDURE modificarTransferencia

CREATE OR ALTER PROCEDURE modificarTransferencia
	@ID_MedioDePago INT,
	@NumeroTransaccion NVARCHAR(50) = NULL
AS
BEGIN
	UPDATE Facturacion.Transferencia SET
		NumeroTransaccion = ISNULL(@NumeroTransaccion, NumeroTransaccion)
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 30 CREACION PROCEDURE eliminarTransferencia

CREATE OR ALTER PROCEDURE eliminarTransferencia
	@ID_MedioDePago INT
AS
BEGIN
	DELETE
	FROM Facturacion.Transferencia
	WHERE ID_MedioDePago = @ID_MedioDePago
END;
GO

--- 31 CREACION DE PROCEDURE ingresoFactura

CREATE OR ALTER PROCEDURE ingresoFactura
	@ID_Factura INT,
	@Numero VARCHAR(50),
	@FechaEmision DATE,
	@FechaVencimiento DATE,
	@TotalImporte DECIMAL(10,2),
	@Recargo DECIMAL(10,2),
	@Estado VARCHAR(30)
AS
BEGIN
	INSERT INTO Facturacion.Factura(ID_Factura, Numero, FechaEmision, FechaVencimiento, TotalImporte, Recargo, Estado) VALUES(
		@ID_Factura,
		@Numero,
		@FechaEmision,
		@FechaVencimiento,
		@TotalImporte,
		@Recargo,
		@Estado
	)
END;
GO

--- 32 CREACION DE PROCEDURE modificarFactura

CREATE OR ALTER PROCEDURE modificarFactura
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

--- 33 CREACION DE PROCEDURE eliminarFactura

CREATE OR ALTER PROCEDURE eliminarFactura
	@ID_Factura INT
AS
BEGIN
	DELETE
	FROM Facturacion.Factura
	WHERE ID_Factura = @ID_Factura
END;
GO

--- 34 CREACION DE PROCEDURE ingresarPago

CREATE OR ALTER PROCEDURE ingresarPago
		@FechaPago DATE,
		@Monto DECIMAL(10,2),
		@ID_MedioDePago INT,
		@NroCuenta INT,
		@ID_Socio VARCHAR(15),
		@ID_Factura INT
AS
BEGIN
	INSERT INTO Facturacion.Pago(FechaPago, Monto, ID_MedioDePago, NroCuenta, ID_Socio, ID_Factura) VALUES(
		@FechaPago,
		@Monto,
		@ID_MedioDePago,
		@NroCuenta,
		@ID_Socio,
		@ID_Factura
	)
END;
GO

--- 35 CREACION DE PROCEDURE modificarPago
		
CREATE OR ALTER PROCEDURE modificarPago		
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

--- 36 CREACION DE PROCEDURE eliminarPago

CREATE OR ALTER PROCEDURE eliminarPago
	@ID_Pago INT
AS
BEGIN
	DELETE 
	FROM Facturacion.Pago
	WHERE ID_Pago = @ID_Pago
END;
GO

--- 37 CREACION DE PROCEDURE ingresarDescuento

CREATE OR ALTER PROCEDURE ingresarDescuento
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

--- 38 CREACION DE PROCEDURE modificarDescuento

CREATE OR ALTER PROCEDURE modificarDescuento
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

--- 39 CREACION DE PROCEDURE eliminarDescuento

CREATE OR ALTER PROCEDURE eliminarDescuento
	@ID_Descuento INT
AS
BEGIN
	DELETE 
	FROM Facturacion.Descuento
	WHERE ID_Descuento = @ID_Descuento
END;
GO

--- 40 CREACION DE PROCEDURE ingresarReembolso

CREATE OR ALTER PROCEDURE ingresarReembolso
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

--- 41 CREACION DE PROCEDURE modificarReembolso

CREATE OR ALTER PROCEDURE modificarReembolso
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

--- 42 CREACION DE PROCEDURE eliminarReembolso

CREATE OR ALTER PROCEDURE eliminarReembolso
	@ID_Reembolso INT
AS
BEGIN
	DELETE
	FROM Facturacion.Reembolso
	WHERE ID_Reembolso = @ID_Reembolso
END;
GO

--- 43 CREACION DE PROCEDURE ingresarCosto

CREATE OR ALTER PROCEDURE ingresarCosto
	@ID_Costo INT,
	@FechaIni DATE,
	@FechaFin DATE,
	@Monto DECIMAL(10,2)
AS
BEGIN
	INSERT INTO Facturacion.Costo(ID_Costo, FechaIni, FechaFin, Monto) VALUES(
		@ID_Costo, 
		@FechaIni,
		@FechaFin,
		@Monto
	)
END;
GO

--- 44 CREACION DE PROCEDURE modificarCosto

CREATE OR ALTER PROCEDURE modificarCosto
	@ID_Costo INT = NULL,
	@FechaIni DATE = NULL,
	@FechaFin DATE = NULL,
	@Monto DECIMAL(10,2) = NULL
AS
BEGIN
	UPDATE Facturacion.Costo SET
		FechaIni = ISNULL(@FechaIni, FechaIni),
		FechaFin = ISNULL(@FechaFin, FechaFin),
		Monto = ISNULL(@Monto, Monto)
	WHERE ID_Costo = @ID_Costo
END;
GO

--- 45 CREACION DE PROCEDURE eliminarCosto

CREATE OR ALTER PROCEDURE eliminarCosto
	@ID_Costo INT
AS
BEGIN
	DELETE
	FROM Facturacion.Costo
	WHERE ID_Costo = @ID_Costo
END;
GO

--- 46 CREACION DE PROCEDURE ingresarCuota

CREATE OR ALTER PROCEDURE ingresarCuota
	@ID_Cuota INT,
	@nroCuota INT,
	@Estado NVARCHAR(50)
AS
BEGIN
	INSERT INTO Facturacion.Cuota(ID_Cuota, nroCuota, Estado) VALUES(
		@ID_Cuota,
		@nroCuota,
		@Estado
	)
END;
GO

--- 47 CREACION DE PROCEDURE modificarCuota

CREATE OR ALTER PROCEDURE modificarCuota
	@ID_Cuota INT,
	@nroCuota INT = NULL,
	@Estado NVARCHAR(50) = NULL
AS
BEGIN
	UPDATE Facturacion.Cuota SET
		nroCuota = ISNULL(@nroCuota, nroCuota),
		Estado = ISNULL(@Estado, Estado)
	WHERE ID_Cuota = @ID_Cuota
END;
GO

--- 48 CREACION DE PROCEDURE eliminarCuota

CREATE OR ALTER PROCEDURE eliminarCuota
	@ID_Cuota INT
AS
BEGIN
	DELETE
	FROM Facturacion.Cuota
	WHERE ID_Cuota = @ID_Cuota
END;
GO

--- 49 CREACION DE PROCEDURE ingresarActividad

CREATE OR ALTER PROCEDURE ingresarActividad
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

--- 50 CREACION DE PROCEDURE modificarActividad

CREATE OR ALTER PROCEDURE modificarActividad
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

--- 51 CREACION DE PROCEDURE eliminarActividad

CREATE OR ALTER PROCEDURE eliminarActividad
	@ID_Actividad INT
AS
BEGIN
	DELETE
	FROM Actividades.Actividad
	WHERE ID_Actividad = @ID_Actividad
END;
GO

--- 52 CREACION DE PROCEDURE ingresarClase

CREATE OR ALTER PROCEDURE ingresarClase
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

--- 53 CREACION DE PROCEDURE modificarClase

CREATE OR ALTER PROCEDURE modificarClase
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

--- 54 CREACION DE PROCEDURE eliminarClase

CREATE OR ALTER PROCEDURE eliminarClase
	@ID_Clase INT
AS
BEGIN
	DELETE
	FROM Actividades.Clase
	WHERE ID_Clase = @ID_Clase
END;
GO

--- 55 CREACION DE PROCEDURE ingresarClaseDictada

CREATE OR ALTER PROCEDURE ingresarClaseDictada
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

--- 56 CREACION DE PROCEDURE modificarClaseDictada

CREATE OR ALTER PROCEDURE modificarClaseDictada
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

--- 57 CREACION DE PROCEDURE eliminarClaseDictada

CREATE OR ALTER PROCEDURE eliminarClaseDictada
	@ID_Clase INT
AS
BEGIN
	DELETE
	FROM Actividades.ClaseDictada
	WHERE ID_Clase = @ID_Clase
END;
GO

--- 58 CREACION DE PROCEDURE ingresarActividadRealizada

CREATE OR ALTER PROCEDURE ingresarActividadRealizada
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

--- 59 CREACION DE PROCEDURE modificarActividadRealizada

CREATE OR ALTER PROCEDURE modificarActividadRealizada
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

--- 60 CREACION DE PROCEDURE eliminarActividadRealizada

CREATE OR ALTER PROCEDURE eliminarActividadRealizada
	@ID_Socio VARCHAR(15),
    @ID_Actividad INT,
    @ID_Profesor VARCHAR(15),
    @FechaActividad DATE
AS
BEGIN
	DELETE
	FROM Actividades.Actividad
	WHERE ID_Socio = @ID_Socio AND
        ID_Actividad = @ID_Actividad AND
        ID_Profesor = @ID_Profesor AND
        FechaActividad = @FechaActividad;
END;
GO

--- 61 CREACION DE PROCEDURE ingresarActividadExtra

CREATE OR ALTER PROCEDURE ingresarActividadExtra
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

--- 62 CREACION DE PROCEDURE modificarActividadExtra

CREATE OR ALTER PROCEDURE modificarActividadExtra
	@ID_ActividadExtra INT,
	@FechaActividadExtra DATE = NULL
AS
BEGIN
	UPDATE Actividades.ActividadExtra SET
		FechaActividadExtra = ISNULL(@FechaActividadExtra, FechaActividadExtra)
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 63 CREACION DE PROCEDURE eliminarActividadExtra

CREATE OR ALTER PROCEDURE eliminarActividadExtra
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE
	FROM Actividades.ActividadExtra
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 64 CREACION DE PROCEDURE ingresarColonia

CREATE OR ALTER PROCEDURE ingresarColonia
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

--- 65 CREACION DE PROCEDURE modificarColonia

CREATE OR ALTER PROCEDURE modificarColonia
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

--- 66 CREACION DE PROCEDURE eliminarColonia

CREATE OR ALTER PROCEDURE eliminarColonia
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE
	FROM Actividades.Colonia
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 67 CREACION DE PROCEDURE ingresarAlquilerSUM

CREATE OR ALTER PROCEDURE ingresarAlquilerSUM
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

--- 68 CREACION DE PROCEDURE modificarAlquilerSUM

CREATE OR ALTER PROCEDURE modificarAlquilerSUM
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

--- 69 CREACION DE PROCEDURE eliminarAlquilerSUM

CREATE OR ALTER PROCEDURE eliminarAlquilerSUM
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE
	FROM ActividadExtra.AlquilerSUM
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 70 CREACION DE PROCEDURE ingresarTarifaPileta

CREATE OR ALTER PROCEDURE ingresarTarifaPileta
	@ID_TarifaPileta INT,
	@Costo DECIMAL(10,2) 
AS
BEGIN
	INSERT INTO Actividades.TarifaPileta(ID_TarifaPileta, Costo) VALUES(
		@ID_TarifaPileta,
		@Costo
	)
END;
GO

--- 71 CREACION DE PROCEDURE modificarTarifaPileta

CREATE OR ALTER PROCEDURE modificarTarifaPileta
	@ID_TarifaPileta INT,
	@Costo DECIMAL(10,2) = NULL
AS
BEGIN
	UPDATE Actividades.TarifaPileta SET
		Costo = ISNULL(@Costo, Costo)
	WHERE ID_TarifaPileta = @ID_TarifaPileta
END;
GO

--- 72 CREACION DE PROCEDURE eliminarTarifaPileta

CREATE OR ALTER PROCEDURE eliminarTarifaPileta
	@ID_TarifaPileta INT
AS
BEGIN	
	DELETE
	FROM Actividades.TarifaPileta
	WHERE ID_TarifaPileta = @ID_TarifaPileta
END;
GO

--- 73 CREACION DE PROCEDURE ingresarPiletaVerano

CREATE OR ALTER PROCEDURE ingresarPiletaVerano
	@ID_ActividadExtra INT,
    @HoraInicio TIME,
    @HoraFin TIME,
    @CapacidadMaxima INT,
    @ID_TarifaPileta INT
AS
BEGIN
	INSERT INTO Actividades.PiletaVerano(ID_ActividadExtra, HoraInicio, HoraFin, CapacidadMaxima, ID_TarifaPileta) VALUES(
		@ID_ActividadExtra,
		@HoraInicio,
		@HoraFin,
		@CapacidadMaxima,
		@ID_TarifaPileta
	)
END;
GO

--- 74 CREACION DE PROCEDURE modificarPiletaVerano

CREATE OR ALTER PROCEDURE modificarPiletaVerano
	@ID_ActividadExtra INT,
    	@HoraInicio TIME = NULL,
    	@HoraFin TIME = NULL, 
    	@CapacidadMaxima INT = NULL,
    	@ID_TarifaPileta INT = NULL
AS
BEGIN
	UPDATE Actividades.PiletaVerano SET
		HoraInicio = ISNULL(@HoraInicio, HoraInicio),
		HoraFin = ISNULL(@HoraFin, HoraFin),
		CapacidadMaxima = ISNULL(@CapacidadMaxima, CapacidadMaxima),
		ID_TarifaPileta = ISNULL(@ID_TarifaPileta, ID_TarifaPileta)
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 75 CREACION DE PROCEDURE eliminarPiletaVerano

CREATE OR ALTER PROCEDURE eliminarPiletaVerano
	@ID_ActividadExtra INT
AS
BEGIN
	DELETE 
	FROM Actividades.PiletaVerano
	WHERE ID_ActividadExtra = @ID_ActividadExtra
END;
GO

--- 76 CREACION DE PROCEDURE ingresarItemFactura

CREATE OR ALTER PROCEDURE ingresarItemFactura
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

--- 77 CREACION DE PROCEDURE modificarItemFactura
	
CREATE OR ALTER PROCEDURE modificarItemFactura
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

--- 78 CREACION DE PROCEDURE eliminarItemFactura

CREATE OR ALTER PROCEDURE eliminarItemFactura
	@ID_Factura INT
AS
BEGIN
	DELETE
	FROM Facturacion.ItemFactura
	WHERE ID_Factura = @ID_Factura
END;
GO

--- 79 CREACION DE PROCEDURE ingresarInvitado

CREATE OR ALTER PROCEDURE ingresarInvitado
		@ID_Socio VARCHAR(15),
        @ID_Pileta INT
AS
BEGIN
	INSERT INTO Personas.Invitado(@ID_Socio, ID_Pileta) VALUES (
		@ID_Socio,
		@ID_Pileta
	)
END;
GO

--- 80 CREACION DE PROCEDURE modificarInvitado

CREATE OR ALTER PROCEDURE modificarInvitado
		@ID_Invitado INT,
		@ID_Socio INT = NULL,
		@ID_Pileta INT = NULL
AS
BEGIN
	UPDATE Personas.Invitado SET
		ID_Socio = ISNULL(@ID_Socio, ID_Socio),
		ID_Pileta = ISNULL(@ID_Pileta, ID_Pileta)
	WHERE ID_Invitado = @ID_Invitado
END;
GO

--- 81 CREACION DE PROCEDURE eliminarInvitado

CREATE OR ALTER PROCEDURE eliminarInvitado
	@ID_Invitado INT
AS
BEGIN
	DELETE
	FROM Personas.Invitado
	WHERE ID_Invitado = @ID_Invitado
END;
