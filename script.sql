/*Entrega 4- Documento de instalación y configuración
Luego de decidirse por un motor de base de datos relacional, llegó el momento de generar la
base de datos. En esta oportunidad utilizarán SQL Server.
Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle
las configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos,
etc.) en un documento como el que le entregaría al DBA.
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar
un archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es
entregado en una sola ejecución). Incluya comentarios para indicar qué hace cada módulo
de código.
Genere store procedures para manejar la inserción, modificado, borrado (si corresponde,
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con “SP”.
Algunas operaciones implicarán store procedures que involucran varias tablas, uso de
transacciones, etc. Puede que incluso realicen ciertas operaciones mediante varios SPs.
Asegúrense de que los comentarios que acompañen al código lo expliquen.
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto
en la creación de objetos. NO use el esquema “dbo”.
Todos los SP creados deben estar acompañados de juegos de prueba. Se espera que
realicen validaciones básicas en los SP (p/e cantidad mayor a cero, CUIT válido, etc.) y que
en los juegos de prueba demuestren la correcta aplicación de las validaciones.
Las pruebas deben realizarse en un script separado, donde con comentarios se indique en
cada caso el resultado esperado
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha
de entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.
Entregar todo en un zip (observar las pautas para nomenclatura antes expuestas) mediante
la sección de prácticas de MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

# Grupo6
Fecha de entrega: 24/5/25
Trabajo Practico de la materia Bases de Datos Aplicadas, 1er cuatrimestre de 2025 en Universidad Nacional de La Matanza

Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
38670422  Céspedes  Leonel  ldc.mail2@gmail.com  ldcvelez
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
*/

create database bdd2025
use bdd2025

CREATE TABLE Rol (
    ID INT PRIMARY KEY,
    Descripcion NVARCHAR(100)
);
GO

CREATE TABLE Usuario (
    DNI INT PRIMARY KEY,
    Nombre NVARCHAR(100),
    Apellido NVARCHAR(100),
    Email NVARCHAR(100),
    TelefonoContacto NVARCHAR(20),
    FechaNacimiento DATE,
    Contrasenia NVARCHAR(100),
    ID_Rol INT,
    FOREIGN KEY (ID_Rol) REFERENCES Rol(ID)
);
GO

CREATE TABLE GrupoFamiliar (
    ID INT PRIMARY KEY,
    Nombre NVARCHAR(100),
    Descripcion NVARCHAR(255)
);
GO

CREATE TABLE Pertenece (
    ID_GrupoFamiliar INT,
    DNI_Usuario INT,
    Es_Titular BIT,
    PRIMARY KEY (ID_GrupoFamiliar, DNI_Usuario),
    FOREIGN KEY (ID_GrupoFamiliar) REFERENCES GrupoFamiliar(ID),
    FOREIGN KEY (DNI_Usuario) REFERENCES Usuario(DNI)
);
GO

CREATE TABLE Cuenta (
    ID INT PRIMARY KEY,
    Alias NVARCHAR(100),
    CVU NVARCHAR(50),
    Moneda NVARCHAR(10),
    Saldo DECIMAL(18, 2),
    Estado NVARCHAR(50)
);
GO

CREATE TABLE Tiene (
    DNI_Usuario INT,
    ID_Cuenta INT,
    PRIMARY KEY (DNI_Usuario, ID_Cuenta),
    FOREIGN KEY (DNI_Usuario) REFERENCES Usuario(DNI),
    FOREIGN KEY (ID_Cuenta) REFERENCES Cuenta(ID)
);
GO

CREATE TABLE Socio (
    DNI INT PRIMARY KEY,
    FechaIngreso DATE NOT NULL,
    Estado NVARCHAR(50) NOT NULL,
    CategoriaID INT NOT NULL,
    FOREIGN KEY (DNI) REFERENCES Usuario(DNI),
    FOREIGN KEY (CategoriaID) REFERENCES Categoria(ID)
);
GO

CREATE TABLE Categoria (
    ID INT PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Importe DECIMAL(18, 2) NOT NULL
);
GO


CREATE TABLE Actividad (
    ID INT PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Costo DECIMAL(18, 2) NOT NULL
);
GO


CREATE TABLE Clase (
    ID INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    ID_Actividad INT NOT NULL,
    DNI_Profesor INT NOT NULL,
    FOREIGN KEY (ID_Actividad) REFERENCES Actividad(ID),
    FOREIGN KEY (DNI_Profesor) REFERENCES Usuario(DNI)
);
GO

GO




--Stored Procedures


--INSERTAR USUARIO
CREATE PROCEDURE insertar_usuario
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
CREATE PROCEDURE modificar_usuario
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
CREATE PROCEDURE borrar_usuario
    @DNI INT
AS
BEGIN
    DELETE FROM Usuario WHERE DNI = @DNI;
END;
GO
--INSERTAR CUENTA
CREATE PROCEDURE insertar_cuenta
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
CREATE PROCEDURE modificar_cuenta
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
CREATE PROCEDURE borrar_cuenta
    @ID INT
AS
BEGIN
    DELETE FROM Cuenta WHERE ID = @ID;
END;
GO

--INSERTAR GRUPO FAMILIAR
CREATE PROCEDURE insertar_grupo_familiar
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
CREATE PROCEDURE modificar_grupo_familiar
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
CREATE PROCEDURE borrar_grupo_familiar
    @ID INT
AS
BEGIN
    DELETE FROM GrupoFamiliar WHERE ID = @ID;
END;
GO

--INSERTAR PERTENECE
CREATE PROCEDURE insertar_pertenece
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
CREATE PROCEDURE borrar_pertenece
    @ID_GrupoFamiliar INT,
    @DNI_Usuario INT
AS
BEGIN
    DELETE FROM Pertenece
    WHERE ID_GrupoFamiliar = @ID_GrupoFamiliar AND DNI_Usuario = @DNI_Usuario;
END;
GO

--INSERTAR TIENE
CREATE PROCEDURE insertar_tiene
    @DNI_Usuario INT,
    @ID_Cuenta INT
AS
BEGIN
    INSERT INTO Tiene (DNI_Usuario, ID_Cuenta)
    VALUES (@DNI_Usuario, @ID_Cuenta);
END;
GO

--BORRAR TIENE
CREATE PROCEDURE borrar_tiene
    @DNI_Usuario INT,
    @ID_Cuenta INT
AS
BEGIN
     DELETE FROM Tiene
    WHERE DNI_Usuario = @DNI_Usuario AND ID_Cuenta = @ID_Cuenta;
END;
GO

-- INSERTAR SOCIO
CREATE PROCEDURE insertar_socio
    @DNI INT,
    @FechaIngreso DATE,
    @Estado NVARCHAR(50)
AS
BEGIN
    INSERT INTO Socio (DNI, FechaIngreso, Estado)
    VALUES (@DNI, @FechaIngreso, @Estado);
END;
GO

-- MODIFICAR SOCIO
CREATE PROCEDURE modificar_socio
    @DNI INT,
    @FechaIngreso DATE,
    @Estado NVARCHAR(50)
AS
BEGIN
    UPDATE Socio
    SET FechaIngreso = @FechaIngreso,
        Estado = @Estado
    WHERE DNI = @DNI;
END;
GO

-- BORRAR SOCIO
CREATE PROCEDURE borrar_socio
    @DNI INT
AS
BEGIN
    DELETE FROM Socio WHERE DNI = @DNI;
END;
GO

-- INSERTAR CATEGORIA
CREATE PROCEDURE insertar_categoria
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    INSERT INTO Categoria (ID, Nombre, Descripcion)
    VALUES (@ID, @Nombre, @Descripcion);
END;
GO

-- MODIFICAR CATEGORIA
CREATE PROCEDURE modificar_categoria
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255)
AS
BEGIN
    UPDATE Categoria
    SET Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE ID = @ID;
END;
GO

-- BORRAR CATEGORIA
CREATE PROCEDURE borrar_categoria
    @ID INT
AS
BEGIN
    DELETE FROM Categoria WHERE ID = @ID;
END;
GO


-- INSERTAR ACTIVIDAD
CREATE PROCEDURE insertar_actividad
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @ID_Categoria INT
AS
BEGIN
    INSERT INTO Actividad (ID, Nombre, Descripcion, ID_Categoria)
    VALUES (@ID, @Nombre, @Descripcion, @ID_Categoria);
END;
GO

-- MODIFICAR ACTIVIDAD
CREATE PROCEDURE modificar_actividad
    @ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @ID_Categoria INT
AS
BEGIN
    UPDATE Actividad
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        ID_Categoria = @ID_Categoria
    WHERE ID = @ID;
END;
GO

-- BORRAR ACTIVIDAD
CREATE PROCEDURE borrar_actividad
    @ID INT
AS
BEGIN
    DELETE FROM Actividad WHERE ID = @ID;
END;
GO

-- INSERTAR CLASE
CREATE PROCEDURE insertar_clase
    @ID INT,
    @ID_Actividad INT,
    @FechaHora DATETIME,
    @Duracion INT,
    @CupoMaximo INT,
    @Lugar NVARCHAR(100)
AS
BEGIN
    INSERT INTO Clase (ID, ID_Actividad, FechaHora, Duracion, CupoMaximo, Lugar)
    VALUES (@ID, @ID_Actividad, @FechaHora, @Duracion, @CupoMaximo, @Lugar);
END;
GO

-- MODIFICAR CLASE
CREATE PROCEDURE modificar_clase
    @ID INT,
    @ID_Actividad INT,
    @FechaHora DATETIME,
    @Duracion INT,
    @CupoMaximo INT,
    @Lugar NVARCHAR(100)
AS
BEGIN
    UPDATE Clase
    SET ID_Actividad = @ID_Actividad,
        FechaHora = @FechaHora,
        Duracion = @Duracion,
        CupoMaximo = @CupoMaximo,
        Lugar = @Lugar
    WHERE ID = @ID;
END;
GO

-- BORRAR CLASE
CREATE PROCEDURE borrar_clase
    @ID INT
AS
BEGIN
    DELETE FROM Clase WHERE ID = @ID;
END;
GO
