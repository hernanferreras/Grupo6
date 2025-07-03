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


-- ╔═════════════════╗ 
-- ║ PRUEBAS PARA SP ║ 
-- ╚═════════════════╝ 

--- FACTURAS ASOCIADAS A ACTIVIDADES

-- Inserto socio para la prueba
EXEC Personas.InsertarSocio
    @ID_Socio = 'SN100', @DNI = 12312312, @Nombre = 'Ramiro', @Apellido = 'Silva', @Email = NULL, @TelefonoContacto = NULL,
    @TelefonoEmergencia = 'NULL', @FechaNacimiento = '1990-01-01', @ObraSocial = NULL, @NroSocioObraSocial = NULL,
    @TelefonoEmergenciaObraSocial = NULL, @ID_Categoria = NULL, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

-- Inserto descuento
EXEC Facturacion.InsertarDescuento
    @ID_Descuento = 1, @Porcentaje = 10, @Descripcion = 'Descuento mes del padre' 

-- Inserto una cuota
EXEC Facturacion.InsertarCuota @ID_Cuota = 100, @FechaCuota = '2025-06-01', @Descripcion = 'Cuota Futsal Junio', 
                               @ID_Actividad = 1;

-- Creo una factura
EXEC Facturacion.InsertarFacturaActividad
    @ID_Factura = 100, @Numero = 'F0100', @FechaEmision = '2025-06-02', @FechaVencimiento = '2025-06-07',
    @Recargo = 10000, @ID_Cuota = 100, @ID_Socio = 'SN100', @ID_Descuento = 1;

-- Inserto su item de factura
EXEC Facturacion.InsertarItemFacturaActividad  @ID_Factura = 100, @ID_Item = 1, @Descripcion = 'Pago Cuota Futsal Junio';

-- Verifico su estado (Impaga), y su saldo
EXEC Facturacion.ActualizarEstadoFactura  @ID_Factura = 100

EXEC Facturacion.ConsultarSaldoFactura @ID_Factura = 100

-- Inserto un pago de casi todo el importe total de la factura
EXEC Facturacion.InsertarPago
    @ID_Pago = 100, @FechaPago = '2025-06-29', @Monto = 31499, @ID_MedioDePago = 2, @NroCuenta = NULL,
    @ID_Socio = 'SN100', @ID_Factura = 100

-- Verifico su estado (Impaga), y su saldo
EXEC Facturacion.ActualizarEstadoFactura @ID_Factura = 100

EXEC Facturacion.ConsultarSaldoFactura @ID_Factura = 100
    
-- Intento insertar un reembolso a una factura impaga
EXEC Facturacion.InsertarReembolso
    @ID_Factura = 100, @FechaReembolso = '2025-06-29', @ImporteReembolso = 5000, @Descripcion = 'Semana con cortes de luz'

-- Inserto un pago para completar el importe total
EXEC Facturacion.InsertarPago
    @ID_Pago = 101, @FechaPago = '2025-06-30', @Monto = 1, @ID_MedioDePago = 2, @NroCuenta = NULL,
    @ID_Socio = 'SN100', @ID_Factura = 100


-- Verifico su estado (Pagada), al estar pagada se cambia su estado a 'Pagada'
EXEC Facturacion.ActualizarEstadoFactura @ID_Factura = 100

EXEC Facturacion.ConsultarSaldoFactura @ID_Factura = 100

-- Inserto un reembolso con la factura ya totalmente pagada
EXEC Facturacion.InsertarReembolso
    @ID_Factura = 100, @FechaReembolso = '2025-06-29', @ImporteReembolso = 5000, @Descripcion = 'Semana con cortes de luz'

---- Muestras para la corroborar la correcta insercion de los datos
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.Pago
SELECT * FROM Facturacion.Descuento
SELECT * FROM Facturacion.Reembolso
SELECT * FROM Facturacion.ItemFactura

-----------------------------------------------------------------------------

-- FACTURAS ASOCIADAS A ACTIVIDADES EXTRA

-- Inserto las actividades extra
EXEC Actividades.InsertarActividadExtra @ID_ActividadExtra = 1, @Tipo = 'Colonia';
EXEC Actividades.InsertarActividadExtra @ID_ActividadExtra = 2, @Tipo = 'Alquiler SUM';
EXEC Actividades.InsertarActividadExtra @ID_ActividadExtra = 3, @Tipo = 'Pileta Verano';

-- Inserto los costos
EXEC Actividades.InsertarColonia @ID_ActividadExtra = 1, @Costo = 10000, @FecVigenciaCosto = '2025-12-31';
EXEC Actividades.InsertarAlquilerSUM @ID_ActividadExtra = 2, @Costo = 15000, @FecVigenciaCosto = '2025-12-31';
EXEC Actividades.InsertarPiletaVerano @ID_ActividadExtra = 3, @CapacidadMaxima = 20, @ID_CostosPileta = 1;

-- Creo factura para Colonia
EXEC Facturacion.InsertarFacturaActividadExtra @ID_Factura = 2001, @Numero = 'FX2001', @FechaEmision = '2025-07-01',
                                               @FechaVencimiento = '2025-07-05', @Importe = 10000, @Recargo = 0, 
                                               @ID_ActividadExtra = 1, @ID_Socio = 'SN100', @ID_Descuento = NULL;
-- Creo su item de factura
EXEC Facturacion.InsertarItemFacturaActividadExtra @ID_Factura = 2001, @ID_Item = 1, @ID_ActividadExtra = 1,
                                                   @Descripcion = 'Colonia - Julio 2025';

-- Creo factura para Alquiler de SUM
EXEC Facturacion.InsertarFacturaActividadExtra @ID_Factura = 2002, @Numero = 'FX2002', @FechaEmision = '2025-07-20',
                                               @FechaVencimiento = '2025-07-25', @Importe = 15000, @Recargo = 0,
                                               @ID_ActividadExtra = 2, @ID_Socio = 'SN100', @ID_Descuento = NULL;
-- Creo su item de factura
EXEC Facturacion.InsertarItemFacturaActividadExtra @ID_Factura = 2002, @ID_Item = 1, @ID_ActividadExtra = 2,
                                                   @Descripcion = 'Alquiler de SUM - 22 de Julio';

-- Creo factura para Pileta de Verano
EXEC Facturacion.InsertarFacturaActividadExtra @ID_Factura = 2003, @Numero = 'FX2003', @FechaEmision = '2025-07-10',
                                               @FechaVencimiento = '2025-07-15', @Importe = 25000, @Recargo = 0,
                                               @ID_ActividadExtra = 3, @ID_Socio = 'SN100', @ID_Descuento = NULL;
-- Creo su item de factura
EXEC Facturacion.InsertarItemFacturaActividadExtra @ID_Factura = 2003, @ID_Item = 1, @ID_ActividadExtra = 3,
                                                   @Descripcion = 'Pileta de Verano - 15 de Julio';

-- Creo un pago de la totalidad del costo de la pileta
EXEC Facturacion.InsertarPago @ID_Pago = 2003, @FechaPago = '2025-07-15', @Monto = 25000, @ID_MedioDePago = 2,
                              @NroCuenta = NULL, @ID_Socio = 'SN-100', @ID_Factura = 2003;

-- Actualizo el estado de la factura de la pileta
EXEC Facturacion.ActualizarEstadoFactura 
    @ID_Factura = 2003
-- Y verifico su saldo
EXEC Facturacion.ConsultarSaldoFactura
    @ID_Factura = 2003

-- Creo un reembolso a la Pileta de Verano
EXEC Facturacion.InsertarReembolso @ID_Factura = 2003, @FechaReembolso = '2025-07-15', 
                                   @ImporteReembolso = 25000, @Descripcion = 'Dia de lluvia';


---- Muestras para la corroborar la correcta insercion de los datos
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.ItemFactura
SELECT * FROM Facturacion.Pago p WHERE p.ID_Pago = '2003'
SELECT * FROM Facturacion.Reembolso


-----------------------------------------------------------------------------


-- ╔═════════════════════════╗
-- ║ PRUEBAS DE ENCRIPTACIÓN ║
-- ╚═════════════════════════╝

-- Ingrsamos ROLES
EXEC Administracion.InsertarRol @Nombre = 'Jefe de Tesorería', @Descripcion = NULL, @Area = 'Tesorería'
EXEC Administracion.InsertarRol @Nombre = 'Administrativo de Cobranza', @Descripcion = NULL, @Area = 'Tesorería'
EXEC Administracion.InsertarRol @Nombre = 'Administrativo de Morosidad', @Descripcion = NULL, @Area = 'Tesorería'
EXEC Administracion.InsertarRol @Nombre = 'Administrativo de Facturación', @Descripcion = NULL, @Area = 'Tesorería'
EXEC Administracion.InsertarRol @Nombre = 'Administrativo Socio', @Descripcion = NULL, @Area = 'Socios'
EXEC Administracion.InsertarRol @Nombre = 'Socios web', @Descripcion = NULL, @Area = 'Socios'
EXEC Administracion.InsertarRol @Nombre = 'Presidente', @Descripcion = NULL, @Area = 'Autoridades'
EXEC Administracion.InsertarRol @Nombre = 'Vicepresidente', @Descripcion = NULL, @Area = 'Autoridades'
EXEC Administracion.InsertarRol @Nombre = 'Secretario', @Descripcion = NULL, @Area = 'Autoridades'
EXEC Administracion.InsertarRol @Nombre = 'Vocales', @Descripcion = NULL, @Area = 'Autoridades'


-- Ingresamos USUARIOS
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_PedroRamirez', 
                                    @Contrasenia = 'Pedro123', @FechaVigenciaContrasenia = '2025-12-31'
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_LauraFernandez', 
                                    @Contrasenia = 'Laura123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_MarcosGonzalez', 
                                    @Contrasenia = 'Marcos123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_AnaLopez',
                                    @Contrasenia = 'Ana123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_RicardoMartinez', 
                                    @Contrasenia = 'Ricardo123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_JulietaSuarez', 
                                    @Contrasenia = 'Julieta123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_CarlosDominguez',
                                    @Contrasenia = 'Carlos123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_VeronicaTorres', 
                                    @Contrasenia = 'Veronica123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_DiegoMoreno',
                                    @Contrasenia = 'Diego123', @FechaVigenciaContrasenia = '2025-12-31';
EXEC Administracion.InsertarUsuario @NombreUsuario = 'Usuario_CamilaGarcia',
                                    @Contrasenia = 'Camila123', @FechaVigenciaContrasenia = '2025-12-31';

-- Ingresamos los EMPLEADOS, con sus respectivos roles y usuarios
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


---- Muestras para la corroborar la correcta insercion de los datos
SELECT * FROM Administracion.Rol
SELECT * FROM Administracion.Usuario
SELECT * FROM Administracion.Empleado

---- Muestra de los empleados con sus datos desencriptados
EXEC Administracion.MostrarEmpleadoDesencriptado
    @ClaveSecreta = 'ClaveGrupo06'

---------------------------------------------------------------------------------------------------
