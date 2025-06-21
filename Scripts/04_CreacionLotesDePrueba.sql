/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/
-- ╔════════════════════╗ 
-- ║  PRUEBAS PARA SP   ║ 
-- ╚════════════════════╝ 

----------------------------------TABLA ROL----------------------------------
--INSERTAR ROL

-- PRUEBA 1: Insertar rol válido
USE Com5600G06;
GO
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