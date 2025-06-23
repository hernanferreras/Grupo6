/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/
-- ╔═════════════════╗ 
-- ║ PRUEBAS PARA SP ║ 
-- ╚═════════════════╝ 

USE Com5600G06;
GO

----------------------------------TABLA ROL----------------------------------
--INSERTAR ROL

-- PRUEBA 1: Insertar rol válido

EXEC insertarRol 'Jefe de Tesoreria', 'Gestiona los procesos financieros del sistema'; 
-- Resultado esperado: Inserción exitosa en tabla Rol 

-- PRUEBA 2: Insertar rol con descripción NULL
-- Esperado: se inserta un nuevo rol con Nombre = 'Invitado' y Descripcion = NULL
EXEC insertarRol @Nombre = 'Invitado', @Descripcion = NULL;
-- Verificación: el nuevo registro tiene Nombre = 'Invitado', Descripcion = NULL

-- PRUEBA 3: Insertar rol con nombre NULL
-- Esperado: ERROR, porque Nombre es NOT NULL y es un campo obligatorio
EXEC insertarRol @Nombre = NULL, @Descripcion = 'Rol sin nombre';
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



-- ╔══════════════════════════════╗ 
-- ║ LOTE DE PRUEBA PARA REPORTES ║ 
-- ╚══════════════════════════════╝ 

/*-- CREAR CATEGORIA
INSERT INTO Personas.Categoria(Descripcion, FecVigenciaCosto, Importe)
VALUES
    ('Menor', '2025-12-31', 1000),
    ('Cadete', '2025-12-31', 2000),
    ('Adulto', '2025-12-31', 3000);
GO*/

-- CREAR SOCIO
INSERT INTO Personas.Socio (ID_Socio, DNI, Nombre, Apellido, Email, TelefonoContacto, TelefonoEmergencia, FechaNacimiento, ObraSocial, NroSocioObraSocial, TelefonoEmergenciaObraSocial, ID_Categoria, ID_GrupoFamiliar, ID_Usuario)
VALUES 
    ('SN001', 12345678, 'Juan', 'Perez', 'juan@gmail.com', '1234-5678', '1234-9999', '1990-01-01', 'OSDE', '0001', '1234-0000', 3, NULL, NULL),
    ('SN002', 23456789, 'José', 'Ramirez', 'jose@gmail.com', '9876-5432', '1111-2222', '1980-01-01', 'OSDE', '0002', '1234-0000', 3, NULL, NULL),
    ('SN003', 34567890, 'Francisco', 'Gonzalez', 'francisco@gmail.com', '5555-6666', '7777-8888', '1970-01-01', 'OSDE', '0003', '1234-0000', 3, NULL, NULL);
GO

-- CREAR CUENTA
INSERT INTO Facturacion.Cuenta (ID_Socio, NroCuenta, FechaAlta, Debito, Credito, Saldo)
VALUES 
    ('SN001', 1, '2025-01-01', 0, 0, 0),
    ('SN002', 2, '2025-01-01', 0, 0, 0),
    ('SN003', 3, '2025-01-01', 0, 0, 0);
GO

-- CREAR FACTURAS 
INSERT INTO Facturacion.Factura (ID_Factura, Numero, FechaEmision, FechaVencimiento, TotalImporte, Recargo, Estado, ID_Socio)
VALUES 
(1, 'F0001', '2025-02-01', '2025-02-06', 25000, 0, 'Impaga', 'SN001'),
(2, 'F0002', '2025-02-01', '2025-02-06', 30000, 0, 'Impaga', 'SN001'),
(3, 'F0003', '2025-03-01', '2025-03-06', 25000, 0, 'Impaga', 'SN001'),
(4, 'F0004', '2025-03-01', '2025-03-06', 45000, 0, 'Impaga', 'SN001'),
(5, 'F0005', '2025-04-01', '2025-04-06', 25000, 0, 'Impaga', 'SN001'),
--------------------------------------------------------------
(6, 'F0006', '2025-05-03', '2025-05-08', 25000, 0, 'Impaga', 'SN002'),
(7, 'F0007', '2025-05-03', '2025-05-08', 25000, 0, 'Impaga', 'SN002'),
(8, 'F0008', '2025-05-03', '2025-05-08', 30000, 0, 'Pagada', 'SN002'),
(9, 'F0009', '2025-05-03', '2025-05-08', 45000, 0, 'Impaga', 'SN002'),
(10, 'F0010', '2025-05-03', '2025-05-08', 30000, 0, 'Impaga', 'SN002'),
---------------------------------------------------------------
(11, 'F0011', '2025-05-10', '2025-05-15', 45000, 0, 'Pagada', 'SN003'),
(12, 'F0012', '2025-06-10', '2025-06-15', 30000, 0, 'Impaga', 'SN003'),
(13, 'F0013', '2025-07-04', '2025-07-09', 30000, 0, 'Impaga', 'SN003'),
(14, 'F0014', '2025-08-04', '2025-08-09', 30000, 0, 'Impaga', 'SN003');
GO

-- CREAR ITEM FACTURA (necesario por FK)
INSERT INTO Facturacion.ItemFactura (ID_Factura, ID_Item, Descripcion, ID_Actividad, Importe)
VALUES
(1, 1, 'Cuota Futsal Febrero', 1, 25000),
(2, 2, 'Cuota Vóley Febrero', 2, 30000),
(3, 3, 'Cuota Futsal Marzo', 1, 25000),
(4, 4, 'Cuota Natacion Marzo', 5, 45000),
(5, 5, 'Cuota Futsal Abril', 1, 30000),
------------------------------
(6, 6, 'Cuota Futsal Mayo', 1, 25000),
(7, 7, 'Cuota Voléy Junio', 2, 30000),
(8, 8, 'Cuota Taekwondo Mayo', 3, 25000),
(9, 9, 'Cuota Baile artístico Mayo', 4, 30000),
(10, 10, 'Cuota Natación Mayo', 5, 45000),
------------------------------
(11, 11, 'Cuota Natación Mayo', 5, 45000),
(12, 12, 'Cuota Baile artístico Junio', 4, 30000),
(13, 13, 'Cuota Baile artístico Julio', 4, 30000),
(14, 14, 'Cuota Baile artístico Agosto', 4, 30000);
GO

-- CREAR PAGOS
INSERT INTO Facturacion.Pago (ID_Pago, FechaPago, Monto, ID_MedioDePago, NroCuenta, ID_Socio, ID_Factura)
VALUES
('1', '2025-05-04', 30000, 2, 2, 'SN002', 8), -- pago dentro de término
---------------------------------------------------
('2', '2025-05-10', 45000, 3, 3, 'SN003', 11);   -- pago dentro de término
GO

-- ╔═══════════════════════════════════╗ 
-- ║ LOTE DE PRUEBA PARA IMPORTACIONES ║ 
-- ╚═══════════════════════════════════╝ 

-- MEDIOS DE PAGO
IF NOT EXISTS (SELECT 1 FROM Facturacion.MedioDePago WHERE Tipo = 'Efectivo')
    INSERT INTO Facturacion.MedioDePago (Tipo) VALUES ('Efectivo');

IF NOT EXISTS (SELECT 1 FROM Facturacion.MedioDePago WHERE Tipo = 'Tarjeta')
    INSERT INTO Facturacion.MedioDePago (Tipo) VALUES ('Tarjeta');

IF NOT EXISTS (SELECT 1 FROM Facturacion.MedioDePago WHERE Tipo = 'Transferencia')
    INSERT INTO Facturacion.MedioDePago (Tipo) VALUES ('Transferencia');

-- PROFESORES
INSERT INTO Personas.Profesor (ID_Profesor, DNI, Especialidad, Nombre, Apellido, Email, TelefonoContacto)
SELECT *
FROM (
    VALUES 
        ('PF-0001', '10000000', 'Futsal', 'Pablo', 'Rodrigez', 'PabloR@gmail.com', '1100001111'),
        ('PF-0002', '10000001', 'Vóley', 'Ana Paula', 'Alvarez', 'AnaPaulaA@gmail.com', '1122220000'),
        ('PF-0003', '10000002', 'Taekwondo', 'Kito', 'Mihaji', 'KitoM@gmail.com', '1133330000'),
        ('PF-0004', '10000003', 'Baile artístico', 'Carolina', 'Herreta', 'Carolina@gmail.com', '1144440000'),
        ('PF-0005', '10000004', 'Natación', 'Paula', 'Quiroga', 'PaulaQ@gmail.com', '1155550000'),
        ('PF-0006', '10000005', 'Ajedrez', 'Hector', 'Alvarez', 'HectorA@gmail.com', '1166660000'),
        ('PF-0007', '10000006', 'Ajedrez', 'Roxana', 'Guiterrez', 'RoxanaG@gmail.com', '1177770000')
) AS v(ID_Profesor, DNI, Especialidad, Nombre, Apellido, Email, TelefonoContacto)
WHERE NOT EXISTS (
    SELECT 1 FROM Personas.Profesor p WHERE p.ID_Profesor = v.ID_Profesor
);

/*
SELECT * FROM Personas.Socio
SELECT * FROM Facturacion.Cuenta
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.ItemFactura
SELECT * FROM Facturacion.Pago

SELECT * FROM Personas.Profesor
*/
