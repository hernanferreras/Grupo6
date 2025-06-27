/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/

USE Com5600G06
GO


-- ╔═════════════════╗ 
-- ║ PRUEBAS PARA SP ║ 
-- ╚═════════════════╝ 

----------------------------------TABLA ROL----------------------------------
--INSERTAR ROL

-- PRUEBA 1: Insertar rol válido

EXEC insertarRol 'Jefe de Tesoreria', 'Gestiona los procesos financieros del sistema', 'Tesorería'; 
-- Resultado esperado: Inserción exitosa en tabla Rol 

-- PRUEBA 2: Insertar rol con descripción NULL
-- Esperado: se inserta un nuevo rol con Nombre = 'Invitado' y Descripcion = NULL
EXEC insertarRol @Nombre = 'Invitado', @Descripcion = NULL, @Area = NULL;
-- Verificación: el nuevo registro tiene Nombre = 'Invitado', Descripcion = NULL

-- PRUEBA 3: Insertar rol con nombre NULL
-- Esperado: ERROR, porque Nombre es NOT NULL y es un campo obligatorio
EXEC insertarRol @Nombre = NULL, @Descripcion = 'Rol sin nombre', @Area = NULL;
-- Verificación: error por violación de restricción NOT NULL
SELECT * FROM Administracion.Rol

--MODIFICAR ROL

-- PRUEBA 4: Modificar rol existente con nuevos valores
-- Precondición: debe existir un ID_Rol = 1
-- Esperado: se actualizan Nombre y Descripcion del rol 1
EXEC modificarRol @ID_Rol = 1, @Nombre = 'Admin Actualizado', @Descripcion = 'Permisos completos';

-- PRUEBA 5: Modificar solo la Descripcion, dejar el Nombre original
-- Esperado: solo cambia Descripcion del ID_Rol = 1
EXEC modificarRol @ID_Rol = 2, @Descripcion = '';
-- Verificación: muestra mismo Nombre, nueva Descripcion

-- PRUEBA 6: Intentar modificar un ID_Rol que no existe
-- Esperado: no se actualiza ninguna fila, pero tampoco hay error
EXEC modificarRol @ID_Rol = -2, @Nombre = 'Fantasma', @Descripcion = 'No existe';

--ELIMINAR ROL

-- PRUEBA 7: Eliminar rol existente
-- Precondición: debe existir un ID_Rol = 1
-- Esperado: se elimina el rol con ID_Rol = 1
EXEC eliminarRol @ID_Rol = 1;
-- Verificación: SELECT * FROM Administración.Rol WHERE ID_Rol = 1; no debe devolver resultados

-- PRUEBA 8: Eliminar rol inexistente
-- Esperado: no hay error, pero no se elimina ninguna fila
EXEC eliminarRol @ID_Rol = -1;

----------------------------------TABLA USUARIO----------------------------------
--INSERTAR USUARIO

-- PRUEBA 1: Inserta un usuario válido con fecha actual
EXEC ingresarUsuario 
    @NombreUsuario = 'Josecito', 
    @Contrasenia = 'Segura123!', 
    @FechaVigenciaContrasenia = '2025-12-01'

-- Resultado esperado: Se inserta correctamente un nuevo usuario.
-- Verificación: SELECT * FROM Administracion.Usuario;

-- PRUEBA 2: Inserción de nombre duplicado
EXEC ingresarUsuario 
    @NombreUsuario = 'Josecito',  -- mismo nombre que en PRUEBA 1
    @Contrasenia = 'OtraClave456',
    @FechaVigenciaContrasenia = '2025-06-01';

-- Resultado esperado: Falla por restricción UNIQUE sobre NombreUsuario.

--PRUEBA 3: Inserción con nombre NULL
EXEC ingresarUsuario 
    @NombreUsuario = NULL,
    @Contrasenia = 'Clave1234',
    @FechaVigenciaContrasenia = '2025-01-01';

-- Resultado esperado: Falla porque NombreUsuario no acepta NULL.

--PRUEBA 4: Modificamos el usuario con datos válidos
EXEC modificarUsuario 
	@ID_Usuario = 1,
    @NombreUsuario = 'Josecito', 
    @Contrasenia = 'SEguRA12', 
    @FechaVigenciaContrasenia = '2025-12-12'

-- Resultado esperado: Se modifican los campos.

--PRUEBA 5: Eliminamos usuario válido
EXEC eliminarUsuario @ID_Usuario = 1;

-- Resultado esperado: Se elimina el usuario con ID = 1.

--PRUEBA 6: Eliminamos usuario inaválido
EXEC eliminarUsuario @ID_Usuario = -1;

-- Resultado esperado: No hay error, pero no se elimina nada porque no existe ese ID.

----------------------------------TABLA GRUPO FAMILIAR----------------------------------

-- PRUEBA 1: Inserción válida

EXEC ingresarGrupoFamiliar 
	@Tamaño = 4, 
	@Nombre = 'Familia López';

-- Resultado esperado: Inserta correctamente el grupo familiar.

--PRUEBA 2: Modificación válida

EXEC modificarGrupoFamiliar 
	@ID_GrupoFamiliar = 1,
	@Nombre = 'Familia Gómez';

-- Resultado esperado: Solo se modifica el nombre, el tamaño se mantiene igual.

-- PRUEBA 3: Eliminación válida

EXEC eliminarGrupoFamiliar 
	@ID_GrupoFamiliar = 1;
-- Resultado esperado: Se elimina el grupo familiar con ID 1.

-- PRUEBA 4: Eliminación inválida

EXEC eliminarGrupoFamiliar 
	@ID_GrupoFamiliar = -1;
-- Resultado esperado: No da error, pero no elimina nada

----------------------------------TABLA CATEGORIA----------------------------------

-- PRUEBA 1: Inserción válida de categoría

EXEC ingresarCategoria 
	@Descripcion = 'Mayor',
	@Importe = 3500.50;

-- Resultado esperado: Se inserta correctamente una nueva categoría.

-- PRUEBA 2: Inserción inválida de categoría

EXEC ingresarCategoria 
	@Descripcion = 'Mayor',
	@Importe = -100.00;

-- Resultado esperado: Falla porque hay un CHECK que no permite importes negativos.

-- PRUEBA 3: Modificación del importe solamente
-- Suponiendo que la categoría con ID 1 existe

EXEC modificarCategoria 
	@ID_Categoria = 1,
	@Importe = 4200.00;

-- Resultado esperado: Se modifica solo el importe.

-- PRUEBA 4: Modificación de la descripción únicamente

EXEC modificarCategoria 
	@ID_Categoria = 1,
	@Descripcion = 'Categoría Actualizada';

-- Resultado esperado: Se actualiza la descripción, el importe queda igual.

--PRUEBA 5: Eliminación válida

EXEC eliminarCategoria 
	@ID_Categoria = 1;

--  Resultado esperado: Se elimina la categoría con ID 1.

---------------------------------------------------------------------------------------------------

-- ╔═══════════════════════════════════╗ 
-- ║ LOTE DE PRUEBA PARA IMPORTACIONES ║ 
-- ╚═══════════════════════════════════╝ 

-- PROFESORES

EXEC ingresarProfesor 
    @ID_Profesor = 'PF-0001', @DNI = 10000001, @Especialidad = 'Futsal', @Nombre = 'Pablo',
    @Apellido = 'Rodrigez', @Email = 'PabloR@gmail.com', @TelefonoContacto = '1100001111';

EXEC ingresarProfesor 
    @ID_Profesor = 'PF-0002', @DNI = 10000002, @Especialidad = 'Vóley', @Nombre = 'Ana Paula',
    @Apellido = 'Alvarez', @Email = 'AnaPaulaA@gmail.com', @TelefonoContacto = '1122220000';

EXEC ingresarProfesor 
    @ID_Profesor = 'PF-0003', @DNI = 10000003, @Especialidad = 'Taekwondo', @Nombre = 'Kito',
    @Apellido = 'Mihaji', @Email = 'KitoM@gmail.com', @TelefonoContacto = '1133330000';

EXEC ingresarProfesor 
    @ID_Profesor = 'PF-0004', @DNI = 10000004, @Especialidad = 'Baile artístico', @Nombre = 'Carolina',
    @Apellido = 'Herreta', @Email = 'Carolina@gmail.com', @TelefonoContacto = '1144440000';

EXEC ingresarProfesor
    @ID_Profesor = 'PF-0005', @DNI = 10000005, @Especialidad = 'Natación', @Nombre = 'Paula',
    @Apellido = 'Quiroga', @Email = 'PaulaQ@gmail.com', @TelefonoContacto = '1155550000';

EXEC ingresarProfesor 
    @ID_Profesor = 'PF-0006', @DNI = 10000006, @Especialidad = 'Ajedrez', @Nombre = 'Hector', 
    @Apellido = 'Alvarez', @Email = 'HectorA@gmail.com', @TelefonoContacto = '1166660000';

EXEC ingresarProfesor 
    @ID_Profesor = 'PF-0007', @DNI = 10000007, @Especialidad = 'Ajedrez', @Nombre = 'Roxana',
    @Apellido = 'Guiterrez', @Email = 'RoxanaG@gmail.com', @TelefonoContacto = '1177770000';


-- MEDIOS DE PAGO
EXEC ingresarMedioDePago 
    @ID_MedioDePago = 1, @Tipo = 'Efectivo'

EXEC ingresarMedioDePago 
    @ID_MedioDePago = 2, @Tipo = 'Tarjeta'

EXEC ingresarMedioDePago 
    @ID_MedioDePago = 3, @Tipo = 'Transferencia'


-- ╔══════════════════════════════════╗
-- ║ PRUEBAS DE IMPORTACIÓN DE SOCIOS ║
-- ╚══════════════════════════════════╝


EXEC ImportarDatosDesdeExcel
    @RutaArchivo = 'C:\ImportacionesSQL\Datos socios.xlsx'
GO

----
/*
SELECT * FROM Personas.Socio
----
SELECT * FROM Personas.SocioTutor
SELECT * FROM Personas.GrupoFamiliar
----
SELECT * FROM Facturacion.Pago p
JOIN Facturacion.MedioDePago mp ON p.ID_MedioDePago = mp.ID_MedioDePago
----
SELECT * FROM Actividades.ActividadRealizada
----
SELECT * FROM Actividades.Actividad
SELECT * FROM Personas.Categoria
SELECT * FROM Actividades.CostosPileta
*/


---------------------------------------------------------------------------------------------------

-- ╔═════════════════════════════════╗
-- ║ PRUEBAS DE IMPORTACIÓN DE CLIMA ║
-- ╚═════════════════════════════════╝

EXECUTE ImportarClimaDesdeCSV
@ruta_archivo = 'C:\ImportacionesSQL\open-meteo-buenosaires_2024.csv'

EXECUTE ImportarClimaDesdeCSV
@ruta_archivo = 'C:\ImportacionesSQL\open-meteo-buenosaires_2025.csv'


-- SELECT * FROM Actividades.Clima


---------------------------------------------------------------------------------------------------

-- ╔══════════════════════════════╗ 
-- ║ LOTE DE PRUEBA PARA REPORTES ║ 
-- ╚══════════════════════════════╝ 

-- CREAR SOCIO
EXEC ingresarSocio
    @ID_Socio = 'SN001', @DNI = 12345678, @Nombre = 'Juan', @Apellido = 'Perez', @Email = 'juan@gmail.com', @TelefonoContacto = '1234-5678',
    @TelefonoEmergencia = '1234-9999', @FechaNacimiento = '1990-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0001',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

EXEC ingresarSocio
    @ID_Socio = 'SN002', @DNI = 23456789, @Nombre = 'José', @Apellido = 'Ramirez', @Email = 'jose@gmail.com', @TelefonoContacto = '9876-5432',
    @TelefonoEmergencia = '1111-2222', @FechaNacimiento = '1980-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0002',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

EXEC ingresarSocio
    @ID_Socio = 'SN003', @DNI = 34567890, @Nombre = 'Francisco', @Apellido = 'Gonzalez', @Email = 'francisco@gmail.com', @TelefonoContacto = '5555-6666',
    @TelefonoEmergencia = '7777-8888', @FechaNacimiento = '1970-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0003',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

-- CREAR CUENTA

EXEC ingresarCuenta
    @ID_Socio = 'SN001', @NroCuenta = 1, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0

EXEC ingresarCuenta
    @ID_Socio = 'SN002', @NroCuenta = 2, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0

EXEC ingresarCuenta
    @ID_Socio = 'SN003', @NroCuenta = 3, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0



-- CREAR FACTURAS 

EXEC ingresarFactura
    @ID_Factura = 1, @Numero = 'F0001', @FechaEmision = '2025-02-01', @FechaVencimiento = '2025-02-06',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC ingresarFactura
    @ID_Factura = 2, @Numero = 'F0002', @FechaEmision = '2025-02-01', @FechaVencimiento = '2025-02-06',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC ingresarFactura
    @ID_Factura = 3, @Numero = 'F0003', @FechaEmision = '2025-03-01', @FechaVencimiento = '2025-03-06',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC ingresarFactura
    @ID_Factura = 4, @Numero = 'F0004', @FechaEmision = '2025-03-01', @FechaVencimiento = '2025-03-06',
    @TotalImporte = 45000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC ingresarFactura
    @ID_Factura = 5, @Numero = 'F0005', @FechaEmision = '2025-04-01', @FechaVencimiento = '2025-04-06',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';
----------
EXEC ingresarFactura
    @ID_Factura = 6, @Numero = 'F0006', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC ingresarFactura
    @ID_Factura = 7, @Numero = 'F0007', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC ingresarFactura
    @ID_Factura = 8, @Numero = 'F0008', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Pagada', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC ingresarFactura
    @ID_Factura = 9, @Numero = 'F0009', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 45000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC ingresarFactura
    @ID_Factura = 10, @Numero = 'F0010', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';
----------
EXEC ingresarFactura
    @ID_Factura = 11, @Numero = 'F0011', @FechaEmision = '2025-05-10', @FechaVencimiento = '2025-05-15',
    @TotalImporte = 45000, @Recargo = 0, @Estado = 'Pagada', @ID_Cuota = NULL, @ID_Socio = 'SN003';

EXEC ingresarFactura
    @ID_Factura = 12, @Numero = 'F0012', @FechaEmision = '2025-06-10', @FechaVencimiento = '2025-06-15',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN003';

EXEC ingresarFactura
    @ID_Factura = 13, @Numero = 'F0013', @FechaEmision = '2025-07-04', @FechaVencimiento = '2025-07-09',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN003';

EXEC ingresarFactura
    @ID_Factura = 14, @Numero = 'F0014', @FechaEmision = '2025-08-04', @FechaVencimiento = '2025-08-09',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN003';


-- CREAR ITEM FACTURA (necesario por FK)

EXEC ingresarItemFactura
    @ID_Factura = 1, @ID_Item = 1, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Febrero', @Importe = 25000;

EXEC ingresarItemFactura
    @ID_Factura = 2, @ID_Item = 2, @ID_Actividad = 2, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Vóley Febrero', @Importe = 30000;

EXEC ingresarItemFactura
    @ID_Factura = 3, @ID_Item = 3, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Marzo', @Importe = 25000;

EXEC ingresarItemFactura
    @ID_Factura = 4, @ID_Item = 4, @ID_Actividad = 5, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Natacion Marzo', @Importe = 45000;

EXEC ingresarItemFactura
    @ID_Factura = 5, @ID_Item = 5, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Abril', @Importe = 30000;
----------
EXEC ingresarItemFactura
    @ID_Factura = 6, @ID_Item = 6, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Mayo', @Importe = 25000;

EXEC ingresarItemFactura
    @ID_Factura = 7, @ID_Item = 7, @ID_Actividad = 2, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Voléy Junio', @Importe = 30000;

EXEC ingresarItemFactura
    @ID_Factura = 8, @ID_Item = 8, @ID_Actividad = 3, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Taekwondo Mayo', @Importe = 25000;

EXEC ingresarItemFactura
    @ID_Factura = 9, @ID_Item = 9, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Mayo', @Importe = 30000;

EXEC ingresarItemFactura
    @ID_Factura = 10, @ID_Item = 10, @ID_Actividad = 5, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Natación Mayo', @Importe = 45000;
----------
EXEC ingresarItemFactura
    @ID_Factura = 11, @ID_Item = 11, @ID_Actividad = 5, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Natación Mayo', @Importe = 45000;

EXEC ingresarItemFactura
    @ID_Factura = 12, @ID_Item = 12, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Junio', @Importe = 30000;

EXEC ingresarItemFactura
    @ID_Factura = 13, @ID_Item = 13, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Julio', @Importe = 30000;

EXEC ingresarItemFactura
    @ID_Factura = 14, @ID_Item = 14, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Agosto', @Importe = 30000;


-- CREAR PAGOS
EXEC ingresarPago
    @ID_Pago = 1, @FechaPago = '2025-05-04', @Monto = 30000, @ID_MedioDePago = 2, 
    @NroCuenta = 2, @ID_Socio = 'SN002', @ID_Factura = 8

EXEC ingresarPago
    @ID_Pago = 2, @FechaPago = '2025-05-10', @Monto = 45000, @ID_MedioDePago = 3, 
    @NroCuenta = 3, @ID_Socio = 'SN003', @ID_Factura = 11

-- ╔═════════════════════╗
-- ║ PRUEBAS DE REPORTES ║
-- ╚═════════════════════╝

-- REPORTE MOROSOS RECURRENTES
EXEC Reportes.MorososRecurrentes
    @FechaInicio = '2025-01-01',
    @FechaFin = '2025-12-31';
GO

-- REPORTE INSASISTENCIA POR CATEGORIA Y ACTIVIDAD
EXEC Reportes.InasistenciasPorCategoriaYActividad
GO

-- REPORTE SOCIOS CON INASISTENCIA A ACTIVIDADES
EXEC Reportes.SociosConInasistenciasAActividades
GO

-- REPORTE DE ACUMULADO MENSUAL POR ACTIVIDAD
EXEC Reportes.AcumuladoMensualPorActividad
GO

/*
SELECT * FROM Personas.Socio
SELECT * FROM Facturacion.Cuenta
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.ItemFactura
SELECT * FROM Facturacion.Pago
SELECT * FROM Actividades.Actividad
*/
