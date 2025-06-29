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

--- PAGOS DE UNA FACTURA

-- Inserto socio para la prueba
EXEC Personas.InsertarSocio
    @ID_Socio = 'SN100', @DNI = 12312312, @Nombre = 'Ramiro', @Apellido = 'Silva', @Email = NULL, @TelefonoContacto = NULL,
    @TelefonoEmergencia = 'NULL', @FechaNacimiento = '1990-01-01', @ObraSocial = NULL, @NroSocioObraSocial = NULL,
    @TelefonoEmergenciaObraSocial = NULL, @ID_Categoria = NULL, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

-- Inserto descuento
EXEC Facturacion.InsertarDescuento
    @ID_Descuento = 1, @Porcentaje = 10, @Descripcion = 'Descuento Día del padre' 

-- Creo una factura
EXEC Facturacion.InsertarFactura
    @ID_Factura = 100, @Numero = 100, @FechaEmision = '2025-06-29', @FechaVencimiento = '2025-07-04',
    @Importe = 30000, @Recargo = 10000, @ID_Cuota = NULL, @ID_Socio = 'SN100', @ID_Descuento = 1;

-- Verifico su estado (Impaga), y su saldo
EXEC Facturacion.VerificarEstadoFactura 
    @ID_Factura = 100

EXEC Facturacion.ConsultarSaldoFactura
    @ID_Factura = 100

-- Inserto un pago de casi todo el importe total de la factura
EXEC Facturacion.InsertarPago
    @ID_Pago = 100, @FechaPago = '2025-06-29', @Monto = 35999, @ID_MedioDePago = 2, @NroCuenta = NULL,
    @ID_Socio = 'SN100', @ID_Factura = 100

-- Verifico su estado (Impaga), y su saldo
EXEC Facturacion.VerificarEstadoFactura 
    @ID_Factura = 100

EXEC Facturacion.ConsultarSaldoFactura
    @ID_Factura = 100

-- Inserto un pago para completar el importe total
EXEC Facturacion.InsertarPago
    @ID_Pago = 101, @FechaPago = '2025-06-30', @Monto = 1, @ID_MedioDePago = 2, @NroCuenta = NULL,
    @ID_Socio = 'SN100', @ID_Factura = 100


-- Verifico su estado (Pagada), al estar pagada se cambia su estado a 'Pagada'
EXEC Facturacion.VerificarEstadoFactura 
    @ID_Factura = 100


SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.Pago
SELECT * FROM Facturacion.Descuento


-- PRUEBAS PARA REEMBOLSOS

    

----------------------------------TABLA ROL----------------------------------
--INSERTAR ROL

-- PRUEBA 1: Insertar rol válido= '2025-07-04', 
    @TotalImporte = 30000, @Recargo = NULL, @ID_Cuota = NULL, @ID_Socio = 'SN100'

EXEC Administracion.InsertarRol 'Jefe de Tesoreria', 'Gestiona los procesos financieros del sistema', 'Tesorería'; 
-- Resultado esperado: Inserción exitosa en tabla Rol 

-- PRUEBA 2: Insertar rol con descripción NULL
-- Esperado: se inserta un nuevo rol con Nombre = 'Invitado' y Descripcion = NULL
EXEC Administracion.InsertarRol @Nombre = 'Invitado', @Descripcion = NULL, @Area = NULL;
-- Verificación: el nuevo registro tiene Nombre = 'Invitado', Descripcion = NULL

-- PRUEBA 3: Insertar rol con nombre NULL
-- Esperado: ERROR, porque Nombre es NOT NULL y es un campo obligatorio
EXEC Administracion.InsertarRol @Nombre = NULL, @Descripcion = 'Rol sin nombre', @Area = NULL;
-- Verificación: error por violación de restricción NOT NULL
SELECT * FROM Administracion.Rol

--MODIFICAR ROL

-- PRUEBA 4: Modificar rol existente con nuevos valores
-- Precondición: debe existir un ID_Rol = 1
-- Esperado: se actualizan Nombre y Descripcion del rol 1
EXEC Administracion.ModificarRol @ID_Rol = 1, @Nombre = 'Admin Actualizado', @Descripcion = 'Permisos completos';

-- PRUEBA 5: Modificar solo la Descripcion, dejar el Nombre original
-- Esperado: solo cambia Descripcion del ID_Rol = 1
EXEC Administracion.ModificarRol @ID_Rol = 2, @Descripcion = '';
-- Verificación: muestra mismo Nombre, nueva Descripcion

-- PRUEBA 6: Intentar modificar un ID_Rol que no existe
-- Esperado: no se actualiza ninguna fila, pero tampoco hay error
EXEC Administracion.ModificarRol @ID_Rol = -2, @Nombre = 'Fantasma', @Descripcion = 'No existe';

--ELIMINAR ROL

-- PRUEBA 7: Eliminar rol existente
-- Precondición: debe existir un ID_Rol = 1
-- Esperado: se elimina el rol con ID_Rol = 1
EXEC Administracion.EliminarRol @ID_Rol = 1;
-- Verificación: SELECT * FROM Administración.Rol WHERE ID_Rol = 1; no debe devolver resultados

-- PRUEBA 8: Eliminar rol inexistente
-- Esperado: no hay error, pero no se elimina ninguna fila
EXEC Administracion.EliminarRol @ID_Rol = -1;

----------------------------------TABLA USUARIO----------------------------------
--INSERTAR USUARIO

-- PRUEBA 1: Inserta un usuario válido con fecha actual
EXEC Administracion.InsertarUsuario 
    @NombreUsuario = 'Josecito', 
    @Contrasenia = 'Segura123!', 
    @FechaVigenciaContrasenia = '2025-12-01'

-- Resultado esperado: Se inserta correctamente un nuevo usuario.
-- Verificación: SELECT * FROM Administracion.Usuario;

-- PRUEBA 2: Inserción de nombre duplicado
EXEC Administracion.InsertarUsuario 
    @NombreUsuario = 'Josecito',  -- mismo nombre que en PRUEBA 1
    @Contrasenia = 'OtraClave456',
    @FechaVigenciaContrasenia = '2025-06-01';

-- Resultado esperado: Falla por restricción UNIQUE sobre NombreUsuario.

--PRUEBA 3: Inserción con nombre NULL
EXEC Administracion.InsertarUsuario 
    @NombreUsuario = NULL,
    @Contrasenia = 'Clave1234',
    @FechaVigenciaContrasenia = '2025-01-01';

-- Resultado esperado: Falla porque NombreUsuario no acepta NULL.

--PRUEBA 4: Modificamos el usuario con datos válidos
EXEC Administracion.ModificarUsuario 
	@ID_Usuario = 1,
    @NombreUsuario = 'Josecito', 
    @Contrasenia = 'SEguRA12', 
    @FechaVigenciaContrasenia = '2025-12-12'

-- Resultado esperado: Se modifican los campos.

--PRUEBA 5: Eliminamos usuario válido
EXEC Administracion.EliminarUsuario @ID_Usuario = 1;

-- Resultado esperado: Se elimina el usuario con ID = 1.

--PRUEBA 6: Eliminamos usuario inaválido
EXEC Administracion.EliminarUsuario @ID_Usuario = -1;

-- Resultado esperado: No hay error, pero no se elimina nada porque no existe ese ID.

----------------------------------TABLA GRUPO FAMILIAR----------------------------------

-- PRUEBA 1: Inserción válida

EXEC Personas.InsertarGrupoFamiliar 
	@Tamaño = 4, 
	@Nombre = 'Familia López';

-- Resultado esperado: Inserta correctamente el grupo familiar.

--PRUEBA 2: Modificación válida

EXEC Personas.InsertarGrupoFamiliar 
	@ID_GrupoFamiliar = 1,
	@Nombre = 'Familia Gómez';

-- Resultado esperado: Solo se modifica el nombre, el tamaño se mantiene igual.

-- PRUEBA 3: Eliminación válida

EXEC Personas.EliminarGrupoFamiliar 
	@ID_GrupoFamiliar = 1;
-- Resultado esperado: Se elimina el grupo familiar con ID 1.

-- PRUEBA 4: Eliminación inválida

EXEC Personas.EliminarGrupoFamiliar 
	@ID_GrupoFamiliar = -1;
-- Resultado esperado: No da error, pero no elimina nada

----------------------------------TABLA CATEGORIA----------------------------------

-- PRUEBA 1: Inserción válida de categoría

EXEC Personas.InsertarCategoria 
	@Descripcion = 'Mayor',
	@Importe = 3500.50;

-- Resultado esperado: Se inserta correctamente una nueva categoría.

-- PRUEBA 2: Inserción inválida de categoría

EXEC Personas.InsertarCategoria 
	@Descripcion = 'Mayor',
	@Importe = -100.00;

-- Resultado esperado: Falla porque hay un CHECK que no permite importes negativos.

-- PRUEBA 3: Modificación del importe solamente
-- Suponiendo que la categoría con ID 1 existe

EXEC Personas.ModificarCategoria 
	@ID_Categoria = 1,
	@Importe = 4200.00;

-- Resultado esperado: Se modifica solo el importe.

-- PRUEBA 4: Modificación de la descripción únicamente

EXEC Personas.ModificarCategoria 
	@ID_Categoria = 1,
	@Descripcion = 'Categoría Actualizada';

-- Resultado esperado: Se actualiza la descripción, el importe queda igual.

--PRUEBA 5: Eliminación válida

EXEC Personas.EliminarCategoria 
	@ID_Categoria = 1;

--  Resultado esperado: Se elimina la categoría con ID 1.


---------------------------------------------------------------------------------------------------

-- ╔══════════════════════════════╗ 
-- ║ LOTE DE PRUEBA PARA REPORTES ║ 
-- ╚══════════════════════════════╝ 

-- CREAR SOCIO
EXEC Personas.InsertarSocio
    @ID_Socio = 'SN001', @DNI = 12345678, @Nombre = 'Juan', @Apellido = 'Perez', @Email = 'juan@gmail.com', @TelefonoContacto = '1234-5678',
    @TelefonoEmergencia = '1234-9999', @FechaNacimiento = '1990-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0001',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

EXEC Personas.InsertarSocio
    @ID_Socio = 'SN002', @DNI = 23456789, @Nombre = 'José', @Apellido = 'Ramirez', @Email = 'jose@gmail.com', @TelefonoContacto = '9876-5432',
    @TelefonoEmergencia = '1111-2222', @FechaNacimiento = '1980-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0002',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

EXEC Personas.InsertarSocio
    @ID_Socio = 'SN003', @DNI = 34567890, @Nombre = 'Francisco', @Apellido = 'Gonzalez', @Email = 'francisco@gmail.com', @TelefonoContacto = '5555-6666',
    @TelefonoEmergencia = '7777-8888', @FechaNacimiento = '1970-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0003',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

-- CREAR CUENTA

EXEC Facturacion.InsertarCuenta
    @ID_Socio = 'SN001', @NroCuenta = 1, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0

EXEC Facturacion.InsertarCuenta
    @ID_Socio = 'SN002', @NroCuenta = 2, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0

EXEC Facturacion.InsertarCuenta
    @ID_Socio = 'SN003', @NroCuenta = 3, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0



-- CREAR FACTURAS 

EXEC Facturacion.InsertarFactura
    @ID_Factura = 1, @Numero = 'F0001', @FechaEmision = '2025-02-01', @FechaVencimiento = '2025-02-06',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 2, @Numero = 'F0002', @FechaEmision = '2025-02-01', @FechaVencimiento = '2025-02-06',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 3, @Numero = 'F0003', @FechaEmision = '2025-03-01', @FechaVencimiento = '2025-03-06',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 4, @Numero = 'F0004', @FechaEmision = '2025-03-01', @FechaVencimiento = '2025-03-06',
    @TotalImporte = 45000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 5, @Numero = 'F0005', @FechaEmision = '2025-04-01', @FechaVencimiento = '2025-04-06',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN001';
----------
EXEC Facturacion.InsertarFactura
    @ID_Factura = 6, @Numero = 'F0006', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 7, @Numero = 'F0007', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 25000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 8, @Numero = 'F0008', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Pagada', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 9, @Numero = 'F0009', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 45000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 10, @Numero = 'F0010', @FechaEmision = '2025-05-03', @FechaVencimiento = '2025-05-08',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN002';
----------
EXEC Facturacion.InsertarFactura
    @ID_Factura = 11, @Numero = 'F0011', @FechaEmision = '2025-05-10', @FechaVencimiento = '2025-05-15',
    @TotalImporte = 45000, @Recargo = 0, @Estado = 'Pagada', @ID_Cuota = NULL, @ID_Socio = 'SN003';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 12, @Numero = 'F0012', @FechaEmision = '2025-06-10', @FechaVencimiento = '2025-06-15',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN003';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 13, @Numero = 'F0013', @FechaEmision = '2025-07-04', @FechaVencimiento = '2025-07-09',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN003';

EXEC Facturacion.InsertarFactura
    @ID_Factura = 14, @Numero = 'F0014', @FechaEmision = '2025-08-04', @FechaVencimiento = '2025-08-09',
    @TotalImporte = 30000, @Recargo = 0, @Estado = 'Impaga', @ID_Cuota = NULL, @ID_Socio = 'SN003';


-- CREAR ITEM FACTURA (necesario por FK)

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 1, @ID_Item = 1, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Febrero', @Importe = 25000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 2, @ID_Item = 2, @ID_Actividad = 2, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Vóley Febrero', @Importe = 30000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 3, @ID_Item = 3, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Marzo', @Importe = 25000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 4, @ID_Item = 4, @ID_Actividad = 5, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Natacion Marzo', @Importe = 45000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 5, @ID_Item = 5, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Abril', @Importe = 30000;
----------
EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 6, @ID_Item = 6, @ID_Actividad = 1, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Futsal Mayo', @Importe = 25000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 7, @ID_Item = 7, @ID_Actividad = 2, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Voléy Junio', @Importe = 30000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 8, @ID_Item = 8, @ID_Actividad = 3, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Taekwondo Mayo', @Importe = 25000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 9, @ID_Item = 9, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Mayo', @Importe = 30000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 10, @ID_Item = 10, @ID_Actividad = 5, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Natación Mayo', @Importe = 45000;
----------
EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 11, @ID_Item = 11, @ID_Actividad = 5, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Natación Mayo', @Importe = 45000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 12, @ID_Item = 12, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Junio', @Importe = 30000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 13, @ID_Item = 13, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Julio', @Importe = 30000;

EXEC Facturacion.InsertarItemFactura
    @ID_Factura = 14, @ID_Item = 14, @ID_Actividad = 4, @ID_ActividadExtra = NULL,
    @Descripcion = 'Cuota Baile artístico Agosto', @Importe = 30000;


-- CREAR PAGOS
EXEC Facturacion.InsertarPago
    @ID_Pago = 1, @FechaPago = '2025-05-04', @Monto = 30000, @ID_MedioDePago = 2, 
    @NroCuenta = 2, @ID_Socio = 'SN002', @ID_Factura = 8

EXEC Facturacion.InsertarPago
    @ID_Pago = 2, @FechaPago = '2025-05-10', @Monto = 45000, @ID_MedioDePago = 3, 
    @NroCuenta = 3, @ID_Socio = 'SN003', @ID_Factura = 11

-- ╔═════════════════════╗
-- ║ PRUEBAS DE REPORTES ║
-- ╚═════════════════════╝

-- REPORTE MOROSOS RECURRENTES
EXEC Reportes.MorososRecurrentes
    @FechaInicio = '2025-01-01',
    @FechaFin = '2025-12-31';

-- REPORTE INSASISTENCIA POR CATEGORIA Y ACTIVIDAD
EXEC Reportes.InasistenciasPorCategoriaYActividad

-- REPORTE SOCIOS CON INASISTENCIA A ACTIVIDADES
EXEC Reportes.SociosConInasistenciasAActividades

-- REPORTE DE ACUMULADO MENSUAL POR ACTIVIDAD
EXEC Reportes.AcumuladoMensualPorActividad

/*
SELECT * FROM Personas.Socio
SELECT * FROM Facturacion.Cuenta
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.ItemFactura
SELECT * FROM Facturacion.Pago
SELECT * FROM Actividades.Actividad
*/


-- ╔═════════════════════════╗
-- ║ PRUEBAS DE ENCRIPTACIÓN ║
-- ╚═════════════════════════╝

-- INGRESO ROLES
EXEC Administracion.InsertarRol
    @Nombre = 'Jefe de Tesorería', @Descripcion = NULL, @Area = 'Tesorería'

EXEC Administracion.InsertarRol
    @Nombre = 'Administrativo de Cobranza', @Descripcion = NULL, @Area = 'Tesorería'

EXEC Administracion.InsertarRol
    @Nombre = 'Administrativo de Morosidad', @Descripcion = NULL, @Area = 'Tesorería'

EXEC Administracion.InsertarRol
    @Nombre = 'Administrativo de Facturación', @Descripcion = NULL, @Area = 'Tesorería'

EXEC Administracion.InsertarRol
    @Nombre = 'Administrativo Socio', @Descripcion = NULL, @Area = 'Socios'

EXEC Administracion.InsertarRol
    @Nombre = 'Socios web', @Descripcion = NULL, @Area = 'Socios'

EXEC Administracion.InsertarRol
    @Nombre = 'Presidente', @Descripcion = NULL, @Area = 'Autoridades'

EXEC Administracion.InsertarRol
    @Nombre = 'Vicepresidente', @Descripcion = NULL, @Area = 'Autoridades'

EXEC Administracion.InsertarRol
    @Nombre = 'Secretario', @Descripcion = NULL, @Area = 'Autoridades'

EXEC Administracion.InsertarRol
    @Nombre = 'Vocales', @Descripcion = NULL, @Area = 'Autoridades'


-- INGRESO USUARIOS
EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'PedroRamirez', @Contrasenia = 'Pedro123', @FechaVigenciaContrasenia = '2025-12-31'

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'LauraFernandez', @Contrasenia = 'Laura123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'MarcosGonzalez', @Contrasenia = 'Marcos123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'AnaLopez', @Contrasenia = 'Ana123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'RicardoMartinez', @Contrasenia = 'Ricardo123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'JulietaSuarez', @Contrasenia = 'Julieta123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'CarlosDominguez', @Contrasenia = 'Carlos123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'VeronicaTorres', @Contrasenia = 'Veronica123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'DiegoMoreno', @Contrasenia = 'Diego123', @FechaVigenciaContrasenia = '2025-12-31';

EXEC Administracion.InsertarUsuario
    @NombreUsuario = 'CamilaGarcia', @Contrasenia = 'Camila123', @FechaVigenciaContrasenia = '2025-12-31';

-- INGRESO EMPLEADOS
EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0001', @DNI = 20000001, @FecNac = '1980-02-20', @FecIngreso = '2004-06-15', @FecBaja = NULL, 
    @Nombre = 'Pedro', @Apellido = 'Ramirez', @Email = 'PedroR@gmail.com', 
    @TelContacto = '1120001111', @ID_Rol = 1, @ID_Usuario = 1

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0002', @DNI = 20000002, @FecNac = '1982-03-10', @FecIngreso = '2004-06-16', @FecBaja = NULL,
    @Nombre = 'Laura', @Apellido = 'Fernandez', @Email = 'LauraF@gmail.com',
    @TelContacto = '1120002222', @ID_Rol = 2, @ID_Usuario = 2;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0003', @DNI = 20000003, @FecNac = '1985-04-25', @FecIngreso = '2004-06-17', @FecBaja = NULL,
    @Nombre = 'Marcos', @Apellido = 'Gonzalez', @Email = 'MarcosG@gmail.com',
    @TelContacto = '1120003333', @ID_Rol = 3, @ID_Usuario = 3;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0004', @DNI = 20000004, @FecNac = '1987-06-14', @FecIngreso = '2004-06-18', @FecBaja = NULL,
    @Nombre = 'Ana', @Apellido = 'Lopez', @Email = 'AnaL@gmail.com',
    @TelContacto = '1120004444', @ID_Rol = 4, @ID_Usuario = 4;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0005', @DNI = 20000005, @FecNac = '1990-07-30', @FecIngreso = '2004-06-19', @FecBaja = NULL,
    @Nombre = 'Ricardo', @Apellido = 'Martinez', @Email = 'RicardoM@gmail.com',
    @TelContacto = '1120005555', @ID_Rol = 5, @ID_Usuario = 5;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0006', @DNI = 20000006, @FecNac = '1988-09-05', @FecIngreso = '2004-06-20', @FecBaja = NULL,
    @Nombre = 'Julieta', @Apellido = 'Suarez', @Email = 'JulietaS@gmail.com',
    @TelContacto = '1120006666', @ID_Rol = 6, @ID_Usuario = 6;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0007', @DNI = 20000007, @FecNac = '1991-10-22', @FecIngreso = '2004-06-21', @FecBaja = NULL,
    @Nombre = 'Carlos', @Apellido = 'Dominguez', @Email = 'CarlosD@gmail.com',
    @TelContacto = '1120007777', @ID_Rol = 7, @ID_Usuario = 7;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0008', @DNI = 20000008, @FecNac = '1983-11-11', @FecIngreso = '2004-06-22', @FecBaja = NULL,
    @Nombre = 'Verónica', @Apellido = 'Torres', @Email = 'VeronicaT@gmail.com',
    @TelContacto = '1120008888', @ID_Rol = 8, @ID_Usuario = 8;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0009', @DNI = 20000009, @FecNac = '1986-12-03', @FecIngreso = '2004-06-23', @FecBaja = NULL,
    @Nombre = 'Diego', @Apellido = 'Moreno', @Email = 'DiegoM@gmail.com',
    @TelContacto = '1120009999', @ID_Rol = 9, @ID_Usuario = 9;

EXEC Administracion.InsertarEmpleado
    @ID_Empleado = 'EM-0010', @DNI = 20000010, @FecNac = '1992-01-08', @FecIngreso = '2004-06-24', @FecBaja = NULL,
    @Nombre = 'Camila', @Apellido = 'Garcia', @Email = 'CamilaG@gmail.com',
    @TelContacto = '1120010000', @ID_Rol = 10, @ID_Usuario = 10;


SELECT * FROM Administracion.Rol
SELECT * FROM Administracion.Usuario
SELECT * FROM Administracion.Empleado

EXEC Administracion.MostrarEmpleadoDesencriptado
    @ClaveSecreta = 'ClaveGrupo06'
-- ╔═══════════════════════════════════════╗
-- ║ CREACION DE ROLES EN LA BASE DE DATOS ║
-- ╚═══════════════════════════════════════╝

USE Com5600G06
GO

CREATE ROLE RolTesoreria;
CREATE ROLE RolSocios;
CREATE ROLE RolAutoridades;
GO


GRANT SELECT, CONTROL ON SCHEMA::Facturacion TO RolTesoreria;
-------------------------------------------------------------------
GRANT SELECT, CONTROL ON SCHEMA::Personas TO RolSocios;
GRANT SELECT, CONTROL ON SCHEMA::Actividades TO RolSocios;
-------------------------------------------------------------------
GRANT SELECT, CONTROL ON SCHEMA::Facturacion TO RolAutoridades;
GRANT SELECT, CONTROL ON SCHEMA::Administracion TO RolAutoridades;
GRANT SELECT, CONTROL ON SCHEMA::Personas TO RolAutoridades;
GRANT SELECT, CONTROL ON SCHEMA::Actividades TO RolAutoridades;