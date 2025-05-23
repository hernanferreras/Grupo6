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




