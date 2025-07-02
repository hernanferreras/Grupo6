/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/

--                                             ╔═════════════════════╗
/*═════════════════════════════════════════════╣ EJECUCIÓN EN BLOQUE ╠═════════════════════════════════════════════*/
--                                             ╚═════════════════════╝


USE Com5600G06;
GO

-- ╔════════════════════╗
-- ║ CREACION DE TABLAS ║
-- ╚════════════════════╝


-- 1 TABLA ROL
BEGIN TRY
	CREATE TABLE Administracion.Rol (
    	ID_Rol INT IDENTITY (1,1) PRIMARY KEY,
    	Descripcion VARCHAR(60),
        Area VARCHAR(50),
	    Nombre VARCHAR(30) NOT NULL
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Rol ya existe'
END CATCH;
GO

-- 2 TABLA GRUPO FAMILIAR
BEGIN TRY
	CREATE TABLE Personas.GrupoFamiliar (
    		ID_GrupoFamiliar INT IDENTITY(1,1) PRIMARY KEY,
            Tamaño INT,
		    Nombre VARCHAR(50),
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla GrupoFamiliar ya existe'
END CATCH;
GO

-- 3 TABLA CATEGORIA
BEGIN TRY
	CREATE TABLE Personas.Categoria (
    	ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    	Descripcion VARCHAR(200),
    	Importe DECIMAL(10, 2) NOT NULL CHECK (Importe > 0),
        FecVigenciaCosto DATE
);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Categoria ya existe'
END CATCH;
GO

-- 4 TABLA USUARIO
BEGIN TRY
	CREATE TABLE Administracion.Usuario (
    	ID_Usuario INT IDENTITY (1,1) PRIMARY KEY,
        NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    	Contrasenia VARCHAR(100),
        FechaVigenciaContrasenia DATE
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Usuario ya existe'
END CATCH;
GO

-- 5 TABLA SOCIO
BEGIN TRY
	CREATE TABLE Personas.Socio (
		ID_Socio VARCHAR(15) PRIMARY KEY,
        DNI int CHECK (DNI BETWEEN 100000 AND 99999999),
        Nombre VARCHAR(30),
        Apellido VARCHAR(30),
    	Email VARCHAR(70),
        TelefonoContacto VARCHAR(30),
        TelefonoEmergencia VARCHAR(30),
    	FechaNacimiento DATE,
    	ObraSocial VARCHAR(50),
    	NroSocioObraSocial VARCHAR(25),
        TelefonoEmergenciaObraSocial VARCHAR(30),
    	ID_Categoria INT,
		ID_GrupoFamiliar INT,                    
    	ID_Usuario INT,
		FOREIGN KEY (ID_Categoria) REFERENCES Personas.Categoria(ID_Categoria),
		FOREIGN KEY (ID_GrupoFamiliar) REFERENCES Personas.GrupoFamiliar(ID_GrupoFamiliar),
		FOREIGN KEY (ID_Usuario) REFERENCES Administracion.Usuario(ID_Usuario)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Socio ya existe'
END CATCH;	
GO

-- 6 TABLA USUARIO ROL
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
    PRINT 'La Tabla UsuarioRol ya Existe'   
END CATCH;
GO

-- 7 TABLA SOCIO-TUTOR
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
	PRINT 'La Tabla SocioTutor ya existe'
END CATCH;
GO

-- 8 TABLA PROFESOR
BEGIN TRY
	CREATE TABLE Personas.Profesor (
		ID_Profesor VARCHAR(15)PRIMARY KEY,
        DNI int CHECK (dni BETWEEN 100000 AND 99999999),
		Especialidad VARCHAR(30),
        Nombre VARCHAR(30),
    	Apellido VARCHAR(30),
    	Email VARCHAR(70),
    	TelefonoContacto VARCHAR(30),
	)
END TRY
BEGIN CATCH
	PRINT 'La Tabla Profesor ya existe'
END CATCH;
GO
    
-- 9 TABLA CUENTA
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
	PRINT 'La Tabla Cuenta ya existe'
END CATCH;
GO

-- 10 TABLA MEDIO DE PAGO
BEGIN TRY
	CREATE TABLE Facturacion.MedioDePago (
    		ID_MedioDePago INT PRIMARY KEY,
    		Tipo VARCHAR(30) NOT NULL
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla MedioDePago ya existe'
END CATCH;
GO

-- 11 TABLA TARJETA
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

-- 12 TABLA TRANSFERENCIA
BEGIN TRY
	CREATE TABLE Facturacion.Transferencia (
    		ID_MedioDePago INT PRIMARY KEY,  
    		NumeroTransaccion VARCHAR(50),
    		FOREIGN KEY (ID_MedioDePago) REFERENCES Facturacion.MedioDePago(ID_MedioDePago)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Transferencia ya existe'
END CATCH;
GO

-- 13 TABLA EFECTIVO
BEGIN TRY
	CREATE TABLE Facturacion.Efectivo(
    		ID_MedioDePago INT PRIMARY KEY, 
			NombreSucursal VARCHAR (20),
			DireccionSucursal VARCHAR(30),
    		FOREIGN KEY (ID_MedioDePago) REFERENCES Facturacion.MedioDePago(ID_MedioDePago)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Efectivo ya existe'
END CATCH;
GO

-- 14 TABLA DESCUENTO
BEGIN TRY
	CREATE TABLE Facturacion.Descuento (
    		ID_Descuento INT PRIMARY KEY,
    		Porcentaje INT CHECK (Porcentaje BETWEEN 1 AND 100),
            Descripcion VARCHAR(200)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Descuento ya existe'
END CATCH;
GO

-- 15 TABLA ACTIVIDAD
BEGIN TRY
	CREATE TABLE Actividades.Actividad (
    		ID_Actividad INT IDENTITY (1,1) PRIMARY KEY,
    		Nombre VARCHAR(60),
    		Descripcion VARCHAR(200),
    		CostoMensual DECIMAL(18, 2) NOT NULL,
            FecVigenciaCosto DATE
);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Actividad ya existe'
END CATCH;
GO

-- 16 TABLA CLASE
BEGIN TRY
	CREATE TABLE Actividades.Clase (
    		ID_Clase INT PRIMARY KEY,
            Dia DATE,
    		HoraInicio TIME,
		    HoraFin TIME,
    		ID_Actividad INT,
			Descripcion VARCHAR(200),
    		FOREIGN KEY (ID_Actividad) REFERENCES Actividades.Actividad(ID_Actividad)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Clase ya existe'
END CATCH;
GO

-- 17 TABLA CLASE DICTADA
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
	PRINT 'La Tabla ClaseDictada ya existe'
END CATCH;  
GO

-- 18 TABLA ACTIVIDAD REALIZADA
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
	PRINT 'La Tabla ActividadRealizada ya existe'
END CATCH;  
GO


-- 19 TABLA ACTIVIDAD EXTRA
BEGIN TRY
    CREATE TABLE Actividades.ActividadExtra (
        ID_ActividadExtra INT PRIMARY KEY,
        Tipo VARCHAR(50)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla ActividadExtra ya existe';
END CATCH;
GO

-- 20 TABLA COLONIA
BEGIN TRY
    CREATE TABLE Actividades.Colonia (
        ID_ActividadExtra INT PRIMARY KEY,
        Costo DECIMAL(10,2),
        FechaVigenciaCosto DATE,
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla Colonia ya existe';
END CATCH;
GO

-- 21 TABLA ALQUILER SUM
BEGIN TRY
    CREATE TABLE Actividades.AlquilerSUM (
        ID_ActividadExtra INT PRIMARY KEY,
        Costo DECIMAL(10,2),
        FechaVigenciaCosto DATE,
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla AlquilerSUM ya existe';
END CATCH;
GO

-- 22 TABLA COSTOS PILETA
BEGIN TRY
    CREATE TABLE Actividades.CostosPileta (
        ID_CostosPileta INT IDENTITY(1,1) PRIMARY KEY,
        CostoSocio DECIMAL (10,2) NOT NULL,
        CostoSocioMenor DECIMAL (10,2) NOT NULL,
        CostoInvitado DECIMAL (10,2) NOT NULL,
        CostoInvitadoMenor DECIMAL (10,2) NOT NULL,
        FecVigenciaCostos DATE
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla CostosPileta ya existe';
END CATCH;
GO

-- 23 TABLA PILETA VERANO
BEGIN TRY
    CREATE TABLE Actividades.PiletaVerano (
        ID_ActividadExtra INT PRIMARY KEY,
        CapacidadMaxima INT,
        ID_CostosPileta INT NOT NULL,
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra),
        FOREIGN KEY (ID_CostosPileta) REFERENCES Actividades.CostosPileta (ID_CostosPileta)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla PiletaVerano ya existe';
END CATCH;
GO

-- 24 TABLA CUOTA
BEGIN TRY
	CREATE TABLE Facturacion.Cuota (
    	ID_Cuota INT PRIMARY KEY,
    	FechaCuota DATE,
    	Descripcion VARCHAR(200),
    	ID_Actividad INT NOT NULL,
    	FOREIGN KEY (ID_Actividad) REFERENCES Actividades.Actividad(ID_Actividad)
	);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Cuota ya existe';
END CATCH;
GO

-- 25 TABLA FACTURA
BEGIN TRY
	CREATE TABLE Facturacion.Factura (
    		ID_Factura INT PRIMARY KEY,
    		Numero VARCHAR(50),
    		FechaEmision DATE,
    		FechaVencimiento DATE,
    		Importe DECIMAL(15,2),
    		Recargo DECIMAL(10,2),
    		Estado VARCHAR(30) CHECK (Estado IN ('Pagada', 'Impaga')),
			ID_Cuota INT,
			ID_Socio VARCHAR(15),
            ID_Descuento INT,
            FOREIGN KEY (ID_Cuota) REFERENCES Facturacion.Cuota(ID_Cuota),
            FOREIGN KEY (ID_Socio) REFERENCES Personas.Socio(ID_Socio),
            FOREIGN KEY (ID_Descuento) REFERENCES Facturacion.Descuento (ID_Descuento)
);
END TRY
BEGIN CATCH
	PRINT 'La Tabla Factura ya existe'
END CATCH;
GO

-- 26 TABLA PAGO
BEGIN TRY
	CREATE TABLE Facturacion.Pago (
		ID_Pago BIGINT PRIMARY KEY,
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

-- 27 TABLA REEMBOLSO
BEGIN TRY
    CREATE TABLE Facturacion.Reembolso (
        ID_Reembolso INT IDENTITY(1,1) PRIMARY KEY,               
        ID_Factura INT NOT NULL,                                 
        FechaReembolso DATE NOT NULL,                             
        ImporteReembolso DECIMAL(15,2) NOT NULL CHECK (ImporteReembolso > 0),
        Descripcion VARCHAR(200),                                
        FOREIGN KEY (ID_Factura) REFERENCES Facturacion.Factura(ID_Factura)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla Reembolso ya existe.';
END CATCH;
GO

-- 28 TABLA ITEM FACTURA
BEGIN TRY
    CREATE TABLE Facturacion.ItemFactura (
        ID_Factura INT NOT NULL,
        ID_Item INT NOT NULL,
        ID_ActividadExtra INT NULL,
        Descripcion VARCHAR(200),
        PRIMARY KEY (ID_Factura, ID_Item),
        FOREIGN KEY (ID_Factura) REFERENCES Facturacion.Factura(ID_Factura),
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla ItemFactura ya existe';
END CATCH;
GO


-- 29 TABLA INVITADO
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
    PRINT 'La Tabla Invitado ya existe';
END CATCH;
GO

-- 30 TABLA SOCIO REALIZA ACTIVIDAD EXTRA
BEGIN TRY
    CREATE TABLE Actividades.SocioRealizaActividadExtra (
        ID_Socio VARCHAR(15),
        ID_ActividadExtra INT,
        FechaRealizacion DATE,
        PRIMARY KEY (ID_Socio, ID_ActividadExtra),
        FOREIGN KEY (ID_Socio) REFERENCES Personas.Socio(ID_Socio),
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.ActividadExtra(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla SocioRealizaActividadExtra ya existe';
END CATCH;
GO

-- 31 TABLA INVITACION PILETA
BEGIN TRY
    CREATE TABLE Actividades.InvitacionPileta (
        ID_Socio_Invitante VARCHAR(15),
        ID_Socio_Invitado VARCHAR(15),
        ID_ActividadExtra INT,
        FechaInvitacion DATE,
        PRIMARY KEY (ID_Socio_Invitante, ID_Socio_Invitado, ID_ActividadExtra),
        FOREIGN KEY (ID_Socio_Invitante) REFERENCES Personas.Socio(ID_Socio),
        FOREIGN KEY (ID_Socio_Invitado) REFERENCES Personas.Socio(ID_Socio),
        FOREIGN KEY (ID_ActividadExtra) REFERENCES Actividades.PiletaVerano(ID_ActividadExtra)
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla InvitacionPileta ya existe';
END CATCH;
GO

-- 32 TABLA CLIMA

BEGIN TRY
    CREATE TABLE Actividades.Clima (
        Fecha DATETIME PRIMARY KEY,
        Temperatura FLOAT,
        Lluvia FLOAT,
        Humedad INT,
        Viento FLOAT
    );
END TRY
BEGIN CATCH
    PRINT 'La Tabla Clima ya existe';
END CATCH;
GO

-- 33 TABLA EMPLEADO
BEGIN TRY
    CREATE TABLE Administracion.Empleado(
		ID_Empleado VARCHAR(15)PRIMARY KEY,
        DNI VARBINARY(MAX),
		FechaNacimiento DATE,
        FechaIngreso DATE,
        FechaBaja DATE,
        Nombre VARBINARY(MAX),
    	Apellido VARBINARY(MAX),
    	Email VARBINARY(MAX),
    	TelefonoContacto VARBINARY(MAX),
        ID_Rol INT,
        ID_Usuario INT,
        FOREIGN KEY (ID_Rol) REFERENCES Administracion.Rol (ID_Rol),
        FOREIGN KEY (ID_Usuario) REFERENCES Administracion.Usuario (ID_Usuario)
	)
END TRY
BEGIN CATCH
    PRINT 'La Tabla Empleado ya existe';
END CATCH;
GO