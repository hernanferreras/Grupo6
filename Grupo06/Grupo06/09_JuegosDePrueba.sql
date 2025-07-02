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

--- FACTURAS DE ACTIVIDADES

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

-- Verifico su estado (Impaga), y su saldo
EXEC Facturacion.ActualizarEstadoFactura  @ID_Factura = 100

EXEC Facturacion.ConsultarSaldoFactura @ID_Factura = 100

EXEC Facturacion.InsertarItemFacturaActividad  @ID_Factura = 100, @ID_Item = 1, @Descripcion = 'Pago Cuota Futsal Junio';

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

/*
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.Pago
SELECT * FROM Facturacion.Descuento
SELECT * FROM Facturacion.Reembolso
SELECT * FROM Facturacion.ItemFactura
*/  

-- FACTURAS DE ACTIVIDADES EXTRA

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
/*
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.ItemFactura
SELECT * FROM Facturacion.Pago p WHERE p.ID_Pago = '2003'
SELECT * FROM Facturacion.Reembolso
*/

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




-- ╔═════════════════════════╗
-- ║ PRUEBAS DE ENCRIPTACIÓN ║
-- ╚═════════════════════════╝

-- INGRESO ROLES
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


-- INGRESO USUARIOS
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
