/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/

-- ╔══════════════════════╗
-- ║ CREACION DE ESQUEMAS ║
-- ╚══════════════════════╝


USE Com5600G06;
GO
	
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Personas')
BEGIN
	EXEC('CREATE SCHEMA Personas')
	PRINT 'El schema se creo correctamente'
END
ELSE
BEGIN
	PRINT 'El schema ya existe'
END;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Actividades')
BEGIN
	EXEC('CREATE SCHEMA Actividades')
	PRINT 'El schema se creo correctamente'
END
ELSE
BEGIN
	PRINT 'El schema ya existe'
END;
GO
	
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Facturacion')
BEGIN
	EXEC('CREATE SCHEMA Facturacion')
	PRINT 'El schema se creo correctamente'
END
ELSE
BEGIN
	PRINT 'El schema ya existe'
END;
GO
	
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Administracion')
BEGIN
	EXEC('CREATE SCHEMA Administracion')
	PRINT 'El schema se creo correctamente'
END
ELSE
BEGIN
	PRINT 'El schema ya existe'
END;
GO
