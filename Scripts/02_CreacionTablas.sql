/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
38670422  Céspedes  Leonel  ldc.mail2@gmail.com  ldcvelez
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
*/

-- ╔════════════════════╗
-- ║ CREACION DE TABLAS ║
-- ╚════════════════════╝


USE Com5600G06;
GO


-- TABLA ROL
BEGIN TRY
	CREATE TABLE Administracion.Rol (
    	ID_Rol INT IDENTITY (1,1) PRIMARY KEY,
    	Descripcion VARCHAR(30),
	    Nombre VARCHAR(60)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla ya Rol existe'
END CATCH;
GO

-- TABLA GRUPO FAMILIAR
BEGIN TRY
	CREATE TABLE Personas.GrupoFamiliar (
    		ID_GrupoFamiliar INT IDENTITY(1,1) PRIMARY KEY,
            Tamaño INT,
		    Nombre VARCHAR(100),
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla GrupoFamiliar ya existe'
END CATCH;
GO

-- TABLA CATEGORIA
BEGIN TRY
	CREATE TABLE Personas.Categoria (
    	ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    	Descripcion VARCHAR(100),
    	Importe DECIMAL(10, 2)
);
END TRY
BEGIN CATCH
	PRINT 'La tabla Categoria ya existe'
END CATCH;
GO

-- TABLA SOCIO
BEGIN TRY
	CREATE TABLE Personas.Socio (
		ID_Socio VARCHAR(15) PRIMARY KEY,
        DNI int CHECK (DNI BETWEEN 100000 AND 99999999),
        Nombre VARCHAR(50),
        Apellido VARCHAR(50),
    	Email VARCHAR(50),
    	TelefonoContacto char(30),
        TelefonoEmergencia char(30),
    	FechaNacimiento DATE,
    	ObraSocial VARCHAR(50),
    	NroSocioObraSocial VARCHAR(25),
        TelefonoEmergenciaObraSocial char(30),
    	ID_Categoria INT,
		ID_GrupoFamiliar INT,                    
    	FOREIGN KEY (ID_Categoria) REFERENCES Personas.Categoria(ID_Categoria),
		FOREIGN KEY (ID_GrupoFamiliar) REFERENCES Personas.GrupoFamiliar(ID_GrupoFamiliar)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Socio ya existe'
END CATCH;	
GO

-- TABLA USUARIO
BEGIN TRY
	CREATE TABLE Administracion.Usuario (
    	ID_Usuario INT IDENTITY (1,1) PRIMARY KEY,
        NombreUsuario VARCHAR(50),
    	Contrasenia VARCHAR(100),
        FechaVigenciaContrasenia DATE,
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Usuario ya existe'
END CATCH;
GO

-- TABLA USUARIO ROL
BEGIN TRY
    CREATE TABLE Administracion.UsuarioRol(
        FechaAsignacion DATE NOT NULL,
        ID_Rol INT NOT NULL,
        ID_Usuario INT NOT NULL,
        PRIMARY KEY (ID_Usuario, ID_Rol),
        FOREIGN KEY (ID_Rol) REFERENCES Administracion.Rol(ID_Rol),
        FOREIGN KEY (ID_Usuario) REFERENCES Administracion.Usuario(ID_Usuario)

    );
END TRY
BEGIN CATCH
    PRINT 'La tabla UsuarioRol ya Existe'   
END CATCH;
GO

-- TABLA SOCIO-TUTOR
BEGIN TRY	
	CREATE TABLE Personas.SocioTutor (
		ID_Tutor VARCHAR(15),
        ID_Menor VARCHAR(15),
        PRIMARY KEY (ID_Tutor, ID_Menor),
        FOREIGN KEY (ID_Tutor) REFERENCES Personas.Socio(ID_Socio),
        FOREIGN KEY (ID_Menor) REFERENCES Personas.Socio(ID_Socio),
        CHECK (ID_Tutor <> ID_Menor)
	)
END TRY
BEGIN CATCH
	PRINT 'La tabla SocioTutor ya existe'
END CATCH;
GO

-- TABLA PROFESOR
BEGIN TRY
	CREATE TABLE Personas.Profesor (
		ID_Profesor VARCHAR(15)PRIMARY KEY,
        DNI int CHECK (dni BETWEEN 100000 AND 99999999),
		Especialidad VARCHAR(30),
        Nombre VARCHAR(50),
    	Apellido VARCHAR(50),
    	Email VARCHAR(50),
    	TelefonoContacto char(12),
	)
END TRY
BEGIN CATCH
	PRINT 'La tabla Profesor ya existe'
END CATCH;
GO
    
--TABLA CUENTA
BEGIN TRY
	CREATE TABLE Facturacion.Cuenta (
    	ID_Socio VARCHAR(15),
		NroCuenta INT,
        FechaAlta DATE,
    	FechaBaja DATE,
    	Debito DECIMAL(10, 2),
    	Credito DECIMAL(10, 2),
		Saldo DECIMAL(10, 2),
		PRIMARY KEY (ID_Socio, NroCuenta),
    	FOREIGN KEY (ID_Socio) REFERENCES Personas.Socio(ID_Socio),
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Cuenta ya existe'
END CATCH;
GO

-- TABLA MEDIO DE PAGO
BEGIN TRY
	CREATE TABLE Facturacion.MedioDePago (
    		ID_MedioDePago INT IDENTITY PRIMARY KEY,
    		Tipo VARCHAR(15) NOT NULL
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla MedioDePago ya existe'
END CATCH;
GO

-- TABLA TARJETA
BEGIN TRY
	CREATE TABLE Facturacion.Tarjeta (
    		ID_MedioDePago INT PRIMARY KEY,  
    		NroTarjeta char(19),
    		FechaVenc DATE,
    		DebitoAutomatico BIT,
    		FOREIGN KEY (ID_MedioDePago) REFERENCES Facturacion.MedioDePago(ID_MedioDePago),
		CONSTRAINT ch_NroTarjeta CHECK(NroTarjeta LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);
END TRY
BEGIN CATCH 
	PRINT 'La Tabla Tarjeta ya existe'
END CATCH;
GO

-- TABLA TRANSFERENCIA
BEGIN TRY
	CREATE TABLE Facturacion.Transferencia (
    		ID_MedioDePago INT PRIMARY KEY,  
    		NumeroTransaccion NVARCHAR(50),
    		FOREIGN KEY (ID_MedioDePago) REFERENCES Facturacion.MedioDePago(ID_MedioDePago)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Transferencia ya existe'
END CATCH;
GO

-- TABLA EFECTIVO
BEGIN TRY
	CREATE TABLE Facturacion.Efectivo(
    		ID_MedioDePago INT PRIMARY KEY,  
    		FOREIGN KEY (ID_MedioDePago) REFERENCES Facturacion.MedioDePago(ID_MedioDePago)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Efectivo ya existe'
END CATCH;
GO

-- TABLA FACTURA
BEGIN TRY
	CREATE TABLE Facturacion.Factura (
    		ID_Factura INT PRIMARY KEY,
    		Numero VARCHAR(50),
    		FechaEmision DATE,
    		FechaVencimiento DATE,
    		TotalImporte DECIMAL(15,2),
    		Recargo DECIMAL(10,2),
    		Estado VARCHAR(30),
);
END TRY
BEGIN CATCH
	PRINT 'La tabla Factura ya existe'
END CATCH;
GO

-- TABLA PAGO
BEGIN TRY
	CREATE TABLE Facturacion.Pago (
		ID_Pago VARCHAR(20) PRIMARY KEY,
		FechaPago DATE,
		Monto DECIMAL(15,2),
		ID_MedioDePago INT,
		NroCuenta INT,
		ID_Socio VARCHAR(15),
		ID_Factura INT,
		FOREIGN KEY (ID_MedioDePago) REFERENCES Facturacion.MedioDePago(ID_MedioDePago),
		FOREIGN KEY (ID_Factura) REFERENCES Facturacion.Factura(ID_Factura),
		FOREIGN KEY (ID_Socio, NroCuenta) REFERENCES Facturacion.Cuenta(ID_Socio, NroCuenta)
);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Pago ya existe'
END CATCH;
GO

-- TABLA DESCUENTO
BEGIN TRY
	CREATE TABLE Facturacion.Descuento (
    		ID_Descuento INT PRIMARY KEY,
    		Porcentaje DECIMAL(5, 2),
            ID_Factura INT NOT NULL,
            FOREIGN KEY (ID_Factura) REFERENCES Facturacion.Factura(ID_Factura)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Descuento ya existe'
END CATCH;
GO

-- TABLA REEMBOLSO
BEGIN TRY
	CREATE TABLE Facturacion.Reembolso (
    	ID_Reembolso VARCHAR(20) PRIMARY KEY, 
		Tipo NVARCHAR(30),   
        ID_Pago VARCHAR(20) UNIQUE,
    	Descripcion VARCHAR(300),
    	FechaReembolso DATE,
    	FOREIGN KEY (ID_Pago) REFERENCES Facturacion.Pago(ID_Pago)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Reembolso ya existe'
END CATCH;
GO

-- TABLA COSTO
BEGIN TRY
	CREATE TABLE Facturacion.Costo (
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

-- TABLA CUOTA
BEGIN TRY
	CREATE TABLE Facturacion.Cuota (
    		ID_Cuota INT PRIMARY KEY,
    		nroCuota INT,
    		Estado NVARCHAR(50),
);
END TRY
BEGIN CATCH
	PRINT 'La tabla Cuota ya existe'
END CATCH;
GO

-- TABLA ACTIVIDAD
BEGIN TRY
	CREATE TABLE Actividades.Actividad (
    		ID_Actividad INT PRIMARY KEY,
    		Nombre VARCHAR(60),
    		Descripcion VARCHAR(255),
    		CostoMensual DECIMAL(18, 2) NOT NULL
);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Actividad ya existe'
END CATCH;
GO

-- TABLA CLASE
BEGIN TRY
	CREATE TABLE Actividades.Clase (
    		ID_Clase INT PRIMARY KEY,
            Dia DATE,
    		HoraInicio TIME,
		    HoraFin TIME,
    		ID_Actividad INT,
    		FOREIGN KEY (ID_Actividad) REFERENCES Actividades.Actividad(ID_Actividad)
	);
END TRY
BEGIN CATCH
	PRINT 'La tabla Clase ya existe'
END CATCH;
GO

-- TABLA CLASE DICTADA
BEGIN TRY
	CREATE TABLE Actividades.ClaseDictada (
    		ID_Clase INT,
    		ID_Profesor VARCHAR(15),
            FechaClase DATE NOT NULL,
    		PRIMARY KEY (ID_Clase, ID_Profesor),
    		FOREIGN KEY (ID_Clase) REFERENCES Actividades.Clase(ID_Clase),
    		FOREIGN KEY (ID_Profesor) REFERENCES Personas.Profesor(ID_Profesor)
);
END TRY
BEGIN CATCH
	PRINT 'La tabla ClaseDictada ya existe'
END CATCH;  
GO

-- TABLA ACTIVIDAD REALIZADA
BEGIN TRY
	CREATE TABLE Actividades.ActividadRealizada (
    		ID_Actividad INT,
            ID_Profesor VARCHAR(15),
    		ID_Socio VARCHAR(15),
            FechaActividad DATE NOT NULL,
            Asistencia CHAR,
    		PRIMARY KEY (ID_Socio, ID_Actividad, ID_Profesor, FechaActividad),
    		FOREIGN KEY (ID_Actividad) REFERENCES Actividades.Actividad(ID_Actividad),
    		FOREIGN KEY (ID_Socio) REFERENCES Personas.Socio(ID_Socio),
            FOREIGN KEY (ID_Profesor) REFERENCES Personas.Profesor(ID_Profesor)
);
END TRY
BEGIN CATCH
	PRINT 'La tabla ActividadRealizada ya existe'
END CATCH;  
GO


-- TABLA ACTIVIDAD EXTRA
BEGIN TRY
    CREATE TABLE Actividades.ActividadExtra (
        ID_ActividadExtra INT PRIMARY KEY,
        FechaActividadExtra DATE
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla ActividadExtra ya existe';
END CATCH;
GO

-- TABLA COLONIA
BEGIN TRY
    CREATE TABLE Actividades.Colonia (
        ID_ActividadExtra INT PRIMARY KEY,
        HoraInicio TIME,
        HoraFin TIME,
        Monto DECIMAL(10,2),
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla Colonia ya existe';
END CATCH;
GO

-- TABLA ALQUILER SUM
BEGIN TRY
    CREATE TABLE Actividades.AlquilerSUM (
        ID_ActividadExtra INT PRIMARY KEY,
        HoraInicio TIME,
        HoraFin TIME,
        Monto DECIMAL(10,2),
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla AlquilerSUM ya existe';
END CATCH;
GO

-- TABLA TARIFA PILETA
BEGIN TRY
    CREATE TABLE Actividades.TarifaPileta (
        ID_TarifaPileta INT PRIMARY KEY,
        Costo DECIMAL (10,2) NOT NULL,
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla TarifaPileta ya existe';
END CATCH;
GO

-- TABLA PILETA VERANO
BEGIN TRY
    CREATE TABLE Actividades.PiletaVerano (
        ID_ActividadExtra INT PRIMARY KEY,
        HoraInicio TIME,
        HoraFin TIME,
        CapacidadMaxima INT,
        ID_TarifaPileta INT NOT NULL,
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra),
        FOREIGN KEY (ID_TarifaPileta) REFERENCES Actividades.TarifaPileta (ID_TarifaPileta)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla PiletaVerano ya existe';
END CATCH;
GO

-- TABLA ITEM FACTURA
BEGIN TRY
    CREATE TABLE Facturacion.ItemFactura (
        ID_Factura INT,           
        ID_Item INT,          
        ID_Actividad INT,
        ID_ActividadExtra INT,
        Descripcion VARCHAR(300),
        Importe DECIMAL(10,2),
        PRIMARY KEY (ID_Factura, ID_Item),
        FOREIGN KEY (ID_Factura) REFERENCES Facturacion.Factura(ID_Factura),
        FOREIGN KEY (ID_Actividad) REFERENCES Actividades.Actividad(ID_Actividad),
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla ItemFactura ya existe';
END CATCH;
GO

-- TABLA INVITADO
BEGIN TRY
    CREATE TABLE Personas.Invitado (
        ID_Invitado INT IDENTITY(1,1) PRIMARY KEY,
        ID_Socio VARCHAR(15),
        ID_Pileta INT,
        FOREIGN KEY (ID_Socio) REFERENCES Personas.Socio(ID_Socio),
        FOREIGN KEY (ID_Pileta) REFERENCES Actividades.PiletaVerano(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La tabla Invitado ya existe';
END CATCH;
GO