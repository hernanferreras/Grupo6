/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
38670422  Céspedes  Leonel  ldc.mail2@gmail.com  ldcvelez
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
*/

-- ╔══════════════════════════════╗
-- ║ CREACION DE LA BASE DE DATOS ║
-- ╚══════════════════════════════╝

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Com5600G06')
BEGIN 
    CREATE DATABASE Com5600G06;
    PRINT 'La base de datos se creó correctamente';
END
ELSE
    PRINT 'La base de datos ya existe';
GO

USE Com5600G06;
GO
