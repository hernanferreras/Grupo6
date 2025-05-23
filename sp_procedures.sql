
--INSERTAR USUARIO
CREATE PROCEDURE sp_insert_usuario
    @DNI INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Email NVARCHAR(100),
    @TelefonoContacto NVARCHAR(20),
    @FechaNacimiento DATE,
    @Contrasenia NVARCHAR(100),
    @ID_Rol INT
AS
BEGIN
    INSERT INTO Usuario VALUES (
        @DNI, @Nombre, @Apellido, @Email, @TelefonoContacto,
        @FechaNacimiento, @Contrasenia, @ID_Rol
    );
END;
GO

--MODIFICAR USAURIO
CREATE PROCEDURE sp_update_usuario
    @DNI INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Email NVARCHAR(100),
    @TelefonoContacto NVARCHAR(20),
    @FechaNacimiento DATE,
    @Contrasenia NVARCHAR(100),
    @ID_Rol INT
AS
BEGIN
    UPDATE Usuario
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Email = @Email,
        TelefonoContacto = @TelefonoContacto,
        FechaNacimiento = @FechaNacimiento,
        Contrasenia = @Contrasenia,
        ID_Rol = @ID_Rol
    WHERE DNI = @DNI;
END;
GO

--BORRAR USUARIO
CREATE PROCEDURE sp_delete_usuario
    @DNI INT
AS
BEGIN
    DELETE FROM Usuario WHERE DNI = @DNI;
END;
GO
--INSERTAR CUENTA
CREATE PROCEDURE sp_insert_cuenta
    @ID INT,
    @Alias NVARCHAR(100),
    @CVU NVARCHAR(50),
    @Moneda NVARCHAR(10),
    @Saldo DECIMAL(18,2),
    @Estado NVARCHAR(50)
AS
BEGIN
    INSERT INTO Cuenta (ID, Alias, CVU, Moneda, Saldo, Estado)
    VALUES (@ID, @Alias, @CVU, @Moneda, @Saldo, @Estado);
END;
GO

--MODIFICAR CUENTA
CREATE PROCEDURE sp_update_cuenta
    @ID INT,
    @Alias NVARCHAR(100),
    @CVU NVARCHAR(50),
    @Moneda NVARCHAR(10),
    @Saldo DECIMAL(18,2),
    @Estado NVARCHAR(50)
AS
BEGIN
    UPDATE Cuenta
    SET Alias = @Alias,
        CVU = @CVU,
        Moneda = @Moneda,
        Saldo = @Saldo,
        Estado = @Estado
    WHERE ID = @ID;
END;
GO

GO

--BORRAR CUENTA
CREATE PROCEDURE sp_delete_cuenta
    @ID INT
AS
BEGIN
    DELETE FROM Cuenta WHERE ID = @ID;
END;
GO

--INSERTAR GRUPO FAMILIAR
CREATE PROCEDURE sp_insert_grupo_familiar
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    INSERT INTO GrupoFamiliar (ID, Nombre, Descripcion)
    VALUES (@ID, @Nombre, @Descripcion);
END;
GO

--MODIFICAR GRUPO FAMILIAR
CREATE PROCEDURE sp_update_grupo_familiar
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    UPDATE GrupoFamiliar
    SET Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE ID = @ID;
END;
GO

--BORRAR GRUPO FAMILIAR
CREATE PROCEDURE sp_delete_grupo_familiar
    @ID INT
AS
BEGIN
    DELETE FROM GrupoFamiliar WHERE ID = @ID;
END;
GO

--INSERTAR PERTENECE
CREATE PROCEDURE sp_insert_pertenece
    @ID_GrupoFamiliar INT,
    @DNI_Usuario INT,
    @Es_Titular BIT
AS
BEGIN
    INSERT INTO Pertenece (ID_GrupoFamiliar, DNI_Usuario, Es_Titular)
    VALUES (@ID_GrupoFamiliar, @DNI_Usuario, @Es_Titular);
END;
GO

--BORRAR PERTENECE
CREATE PROCEDURE sp_delete_pertenece
    @ID_GrupoFamiliar INT,
    @DNI_Usuario INT
AS
BEGIN
    DELETE FROM Pertenece
    WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar AND DNI_Usuario = @DNI_Usuario;
END;
GO

--INSERTAR TIENE
CREATE PROCEDURE sp_insert_tiene
    @DNI_Usuario INT,
    @ID_Cuenta INT
AS
BEGIN
    INSERT INTO Tiene (DNI_Usuario, ID_Cuenta)
    VALUES (@DNI_Usuario, @ID_Cuenta);
END;
GO

--BORRAR TIENE
CREATE PROCEDURE sp_insert_tiene
    @DNI_Usuario INT,
    @ID_Cuenta INT
AS
BEGIN
    INSERT INTO Tiene (DNI_Usuario, ID_Cuenta)
    VALUES (@DNI_Usuario, @ID_Cuenta);
END;
GO



GO