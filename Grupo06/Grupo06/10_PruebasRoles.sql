/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/

--                                             ╔═══════════════════════╗
/*═════════════════════════════════════════════╣ EJECUCIÓN PASO A PASO ╠═════════════════════════════════════════════*/
--                                             ╚═══════════════════════╝


USE Com5600G06
GO

-- ╔════════════════════════════════════════════╗
-- ║ CREACION DE ROLES Y ASIGNACIÓN DE PERMISOS ║
-- ╚════════════════════════════════════════════╝

-- Creo los nuevos roles
CREATE ROLE RolTesoreria;
CREATE ROLE RolSocios;
CREATE ROLE RolAutoridades;
GO


-- Asigno los permisos necesarios a cada ROL
GRANT SELECT, CONTROL ON SCHEMA::Facturacion TO RolTesoreria;
-------------------------------------------------------------------
GRANT SELECT, CONTROL ON SCHEMA::Personas TO RolSocios;
GRANT SELECT, CONTROL ON SCHEMA::Actividades TO RolSocios;
-------------------------------------------------------------------
GRANT SELECT, CONTROL ON SCHEMA::Facturacion TO RolAutoridades;
GRANT SELECT, CONTROL ON SCHEMA::Administracion TO RolAutoridades;
GRANT SELECT, CONTROL ON SCHEMA::Personas TO RolAutoridades;
GRANT SELECT, CONTROL ON SCHEMA::Actividades TO RolAutoridades;




-- ╔═══════════════════════════════════════════╗
-- ║ PRUEBAS PARA LA COMPROBACIÓN DE LOS ROLES ║
-- ╚═══════════════════════════════════════════╝


-- Crear LOGIN y USER para PedroRamirez (Jefe de Tesorería)
CREATE LOGIN Login_PedroRamirez WITH PASSWORD = 'Pedro123', DEFAULT_DATABASE = Com5600G06;
CREATE USER Usuario_PedroRamirez FOR LOGIN Login_PedroRamirez;
ALTER ROLE RolTesoreria ADD MEMBER Usuario_PedroRamirez;

-- Crear LOGIN y USER para JulietaSuarez (Administrativo Socio)
CREATE LOGIN Login_JulietaSuarez WITH PASSWORD = 'Julieta123', DEFAULT_DATABASE = Com5600G06;
CREATE USER Usuario_JulietaSuarez FOR LOGIN Login_JulietaSuarez;
ALTER ROLE RolSocios ADD MEMBER Usuario_JulietaSuarez;

-- Crear LOGIN y USER para CarlosDominguez (Presidente)
CREATE LOGIN Login_CarlosDominguez WITH PASSWORD = 'Carlos123', DEFAULT_DATABASE = Com5600G06;
CREATE USER Usuario_CarlosDominguez FOR LOGIN Login_CarlosDominguez;
ALTER ROLE RolAutoridades ADD MEMBER Usuario_CarlosDominguez;


    
/* 
    LLEGADO A ESTE PUNTO SE DEBEN EJECUTAR LAS PRUEBAS SEGUN EL USUARIO CORRESPONDIENTE 
    CREANDO UNA CONEXION CON DICHO USUARIO, Y LUEGO PROBARLAS CON USUARIOS DISTINTOS AL INDICADO
    PARA CORROBORAR LOS PERMISOS DE CADA AREA/ROL

    El resultado esperado es:
                             - El area Tesoreria (RolTesoreria) tenga acceso solamente al esquema Facturacion
                             - El area Socios (RolSocios) tenga acceso solamente al esquema Personas
                             - El area Autoridades (RolAutoridades) tenga acceso a todos los esquemas
*/

--══════════════════════════════════ AREA TESORERÍA ══════════════════════════════════--

-- Se debe logear con el usuario Login_PedroRamirez. Constraseña: Pedro123

SELECT * FROM Facturacion.Pago;

-- Insertar Pago
EXEC Facturacion.InsertarPago
    @ID_Pago = 3, @FechaPago = '2025-10-05', @Monto = 30000, @ID_MedioDePago = 3, 
	@NroCuenta = 3, @ID_Socio = 'SN003', @ID_Factura = 14

-- Modificar medio de pago
EXEC Facturacion.ModificarPago
	@ID_Pago = 3, @FechaPago = NULL, @Monto = NULL, @ID_MedioDePago = 2, 
	@NroCuenta = NULL, @ID_Socio = NULL, @ID_Factura = 14

-- Eliminar pago
EXEC Facturacion.EliminarPago
	@ID_Pago = 3


--══════════════════════════════════ AREA SOCIOS ══════════════════════════════════--

-- Se debe logear con el usuario Login_JulietaSuarez. Constraseña: Julieta123

SELECT * FROM Personas.Socio;

-- Insertar nuevo socio
EXEC Personas.InsertarSocio
    @ID_Socio = 'SN005', @DNI = 12345678, @Nombre = 'José', @Apellido = 'Sosa', @Email = 'JoséSosa@gmail.com', @TelefonoContacto = '2222-3333',
    @TelefonoEmergencia = '2222-4444', @FechaNacimiento = '1995-03-06', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0005',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

-- Modificar Email
EXEC Personas.ModificarSocio
    @ID_Socio = 'SN005', @DNI = NULL, @Nombre = NULL, @Apellido = NULL, @Email = 'SosaJuanJose@gmail.com', @TelefonoContacto = NULL,
    @TelefonoEmergencia = NULL, @FechaNacimiento = NULL, @ObraSocial = NULL, @NroSocioObraSocial = NULL,
    @TelefonoEmergenciaObraSocial = NULL, @ID_Categoria = NULL, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

-- Eliminar socio
EXEC Personas.EliminarSocio
    @ID_Socio = 'SN005'

    
--══════════════════════════════════ AREA AUTORIDADES ══════════════════════════════════--

-- Se debe logear con el usuario Login_CarlosDominguez. Constraseña: Carlos123

EXEC Administracion.MostrarEmpleadoDesencriptado
    @ClaveSecreta = 'ClaveGrupo06'

--Insertar Empleado
EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0011', @DNI = 20000011, @FecNac = '2000-09-15', @FecIngreso = '2021-02-11', @FecBaja = NULL,
    @Nombre = 'Rodrigo', @Apellido = 'Peralta', @Email = 'RodrigoP@gmail.com',
    @TelContacto = '1120011000', @ID_Rol = 5, @ID_Usuario = NULL;

-- Modificar fecha de baja
EXEC Administracion.ModificarEmpleado
    @ID_Empleado = 'EM-0011', @DNI = NULL, @FecNac = NULL, @FecIngreso = NULL, @FecBaja = '2023-06-03',
    @Nombre = NULL, @Apellido = NULL, @Email = NULL,
    @TelContacto = NULL, @ID_Rol = NULL, @ID_Usuario = NULL;

EXEC Administracion.EliminarEmpleado
    @ID_Empleado = 'EM-0011'


/*
DROP USER  Usuario_PedroRamirez;
DROP USER  Usuario_JulietaSuarez;
DROP USER  Usuario_CarlosDominguez;

DROP LOGIN Login_PedroRamirez;
DROP LOGIN Login_JulietaSuarez;
DROP LOGIN Login_CarlosDominguez;

ALTER ROLE RolTesoreria DROP MEMBER Usuario_PedroRamirez;
ALTER ROLE RolSocios DROP MEMBER Usuario_JulietaSuarez;
ALTER ROLE RolAutoridades DROP MEMBER Usuario_CarlosDominguez;

DROP ROLE RolTesoreria;
DROP ROLE RolSocios;
DROP ROLE RolAutoridades;

