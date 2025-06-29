/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/


-- ╔═══════════════════════════════════╗ 
-- ║ LOTE DE PRUEBA PARA IMPORTACIONES ║ 
-- ╚═══════════════════════════════════╝ 


USE Com5600G06
GO

-- INGRESO DE PROFESORES para respetar FK

EXEC Personas.InsertarProfesor 
    @ID_Profesor = 'PF-0001', @DNI = 10000001, @Especialidad = 'Futsal', @Nombre = 'Pablo',
    @Apellido = 'Rodrigez', @Email = 'PabloR@gmail.com', @TelefonoContacto = '1100001111';

EXEC Personas.InsertarProfesor
    @ID_Profesor = 'PF-0002', @DNI = 10000002, @Especialidad = 'Vóley', @Nombre = 'Ana Paula',
    @Apellido = 'Alvarez', @Email = 'AnaPaulaA@gmail.com', @TelefonoContacto = '1122220000';

EXEC Personas.InsertarProfesor
    @ID_Profesor = 'PF-0003', @DNI = 10000003, @Especialidad = 'Taekwondo', @Nombre = 'Kito',
    @Apellido = 'Mihaji', @Email = 'KitoM@gmail.com', @TelefonoContacto = '1133330000';

EXEC Personas.InsertarProfesor
    @ID_Profesor = 'PF-0004', @DNI = 10000004, @Especialidad = 'Baile artístico', @Nombre = 'Carolina',
    @Apellido = 'Herreta', @Email = 'Carolina@gmail.com', @TelefonoContacto = '1144440000';

EXEC Personas.InsertarProfesor
    @ID_Profesor = 'PF-0005', @DNI = 10000005, @Especialidad = 'Natación', @Nombre = 'Paula',
    @Apellido = 'Quiroga', @Email = 'PaulaQ@gmail.com', @TelefonoContacto = '1155550000';

EXEC Personas.InsertarProfesor
    @ID_Profesor = 'PF-0006', @DNI = 10000006, @Especialidad = 'Ajedrez', @Nombre = 'Hector', 
    @Apellido = 'Alvarez', @Email = 'HectorA@gmail.com', @TelefonoContacto = '1166660000';

EXEC Personas.InsertarProfesor
    @ID_Profesor = 'PF-0007', @DNI = 10000007, @Especialidad = 'Ajedrez', @Nombre = 'Roxana',
    @Apellido = 'Guiterrez', @Email = 'RoxanaG@gmail.com', @TelefonoContacto = '1177770000';


-- INGRESO DE MEDIOS DE PAGO para respetar FK
EXEC Facturacion.InsertarMedioDePago
    @ID_MedioDePago = 1, @Tipo = 'Efectivo'

EXEC Facturacion.InsertarMedioDePago
    @ID_MedioDePago = 2, @Tipo = 'Tarjeta'

EXEC Facturacion.InsertarMedioDePago
    @ID_MedioDePago = 3, @Tipo = 'Transferencia'


-- ╔══════════════════════════════════╗
-- ║ PRUEBAS DE IMPORTACIÓN DE SOCIOS ║
-- ╚══════════════════════════════════╝

EXEC ImportarDatosDesdeExcel
    @RutaArchivo = 'D:\ImportacionesSQL\Datos socios.xlsx'
GO

----
/*
SELECT * FROM Personas.Socio
----
SELECT * FROM Personas.SocioTutor
SELECT * FROM Personas.GrupoFamiliar
----
SELECT * FROM Facturacion.Pago p
JOIN Facturacion.MedioDePago mp ON p.ID_MedioDePago = mp.ID_MedioDePago
SELECT * FROM Facturacion.MedioDePago
----
SELECT * FROM Actividades.ActividadRealizada
----
SELECT * FROM Actividades.Actividad
SELECT * FROM Personas.Categoria
SELECT * FROM Actividades.CostosPileta
*/

/*
DELETE FROM Personas.SocioTutor
DELETE FROM Actividades.ActividadRealizada
DELETE FROM Actividades.Actividad
DELETE FROM Personas.Categoria
DELETE FROM Actividades.CostosPileta
DELETE FROM Facturacion.Pago
DELETE FROM Personas.Socio
DELETE FROM Personas.GrupoFamiliar
*/

---------------------------------------------------------------------------------------------------

-- ╔═════════════════════════════════╗
-- ║ PRUEBAS DE IMPORTACIÓN DE CLIMA ║
-- ╚═════════════════════════════════╝

EXECUTE ImportarClimaDesdeCSV
@ruta_archivo = 'D:\ImportacionesSQL\open-meteo-buenosaires_2024.csv'

EXECUTE ImportarClimaDesdeCSV
@ruta_archivo = 'D:\ImportacionesSQL\open-meteo-buenosaires_2025.csv'

-- SELECT * FROM Actividades.Clima
