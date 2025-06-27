/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
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
BEGIN
    PRINT 'La base de datos ya existe';
END
GO

USE Com5600G06
GO
