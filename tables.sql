/*Entrega 4- Documento de instalaci�n y configuraci�n
Luego de decidirse por un motor de base de datos relacional, lleg� el momento de generar la
base de datos. En esta oportunidad utilizar�n SQL Server.
Deber� instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle
las configuraciones aplicadas (ubicaci�n de archivos, memoria asignada, seguridad, puertos,
etc.) en un documento como el que le entregar�a al DBA.
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deber� entregar
un archivo .sql con el script completo de creaci�n (debe funcionar si se lo ejecuta �tal cual� es
entregado en una sola ejecuci�n). Incluya comentarios para indicar qu� hace cada m�dulo
de c�digo.
Genere store procedures para manejar la inserci�n, modificado, borrado (si corresponde,
tambi�n debe decidir si determinadas entidades solo admitir�n borrado l�gico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con �SP�.
Algunas operaciones implicar�n store procedures que involucran varias tablas, uso de
transacciones, etc. Puede que incluso realicen ciertas operaciones mediante varios SPs.
Aseg�rense de que los comentarios que acompa�en al c�digo lo expliquen.
Genere esquemas para organizar de forma l�gica los componentes del sistema y aplique esto
en la creaci�n de objetos. NO use el esquema �dbo�.
Todos los SP creados deben estar acompa�ados de juegos de prueba. Se espera que
realicen validaciones b�sicas en los SP (p/e cantidad mayor a cero, CUIT v�lido, etc.) y que
en los juegos de prueba demuestren la correcta aplicaci�n de las validaciones.
Las pruebas deben realizarse en un script separado, donde con comentarios se indique en
cada caso el resultado esperado
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha
de entrega, n�mero de grupo, nombre de la materia, nombres y DNI de los alumnos.
Entregar todo en un zip (observar las pautas para nomenclatura antes expuestas) mediante
la secci�n de pr�cticas de MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

# Grupo6
Fecha de entrega: 24/5/25
Trabajo Practico de la materia Bases de Datos Aplicadas, 1er cuatrimestre de 2025 en Universidad Nacional de La Matanza

Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
38670422  C�spedes  Leonel  ldc.mail2@gmail.com  ldcvelez
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




