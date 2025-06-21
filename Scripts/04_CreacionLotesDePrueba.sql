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

-- Inserta un usuario válido con fecha actual
EXEC ingresarUsuario 
    @NombreUsuario = 'juan.perez', 
    @Contrasenia = 'Segura123!', 
    @FechaVigenciaContrasenia = GETDATE();

-- Resultado esperado: Se inserta correctamente un nuevo usuario.
-- Verificación: SELECT * FROM Administracion.Usuario;