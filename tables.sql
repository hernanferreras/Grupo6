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




