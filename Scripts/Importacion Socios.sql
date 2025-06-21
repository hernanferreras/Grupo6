USE  Com5600G06
-- Habilita la visualización de opciones avanzadas en SQL Server para poder configurarlas
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

-- Permite ejecutar consultas ad hoc como OPENROWSET para importar datos desde archivos externos como Excel.
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

--╔══════════════════════════════════╗
--║ IMPORTACION RESPONSABLES DE PAGO ║
--╚══════════════════════════════════╝

--CREO LA TABLA TEMPORAL
DROP TABLE IF EXISTS #ImportacionSocios;   
GO

CREATE TABLE #ImportacionSocios (
    NroDeSocio VARCHAR(30),
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    DNI VARCHAR (10),
    Email VARCHAR(150),
    FechaNacimiento VARCHAR(50),
    TelefonoContacto VARCHAR(50),
    TelefonoEmergencia VARCHAR(50),
    ObraSocial VARCHAR(100),
    NroSocioObraSocial VARCHAR(50),
    TelefonoObraSocial VARCHAR(50)
);
GO


INSERT INTO #ImportacionSocios                --INSERTO TODA LA TABLA
SELECT *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\ImportacionesSQL\Datos socios.xlsx;HDR=NO;IMEX=1',
    'SELECT * FROM [Responsables de Pago$]'
);
GO

WITH CTE AS (                               -- ELIMINO LA FILA DE ENCABEZADOS
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM #ImportacionSocios
)
DELETE FROM CTE WHERE rn = 1;
GO

-- INSERTO EN LA TABLA DE SOCIOS
INSERT INTO Personas.Socio(
    ID_socio, Nombre, Apellido, DNI, Email, FechaNacimiento,
    TelefonoContacto, TelefonoEmergencia, ObraSocial,
    NroSocioObraSocial, TelefonoEmergenciaObraSocial
)
SELECT 
    LTRIM(RTRIM(NroDeSocio)),
    LTRIM(RTRIM(Nombre)),                                         -- Nombre
    LTRIM(RTRIM(Apellido)),                                       -- Apellido    
    TRY_CAST(LEFT(DNI, 8) AS INT),                                -- DNI
    Email,                                                        -- Email
    ISNULL(                                                       -- Fecha de nacimiento
        TRY_CONVERT(DATE, FechaNacimiento, 103),
        NULL
    ),
    LEFT(TelefonoContacto, 15),                                   -- Teléfono
    LEFT(TelefonoEmergencia,15),                                  -- Teléfono Emergencia
    LTRIM(RTRIM(ObraSocial)),                                     -- Obra Social
    LTRIM(RTRIM(NroSocioObraSocial)),                             -- Numero Obra Social
    LEFT(TelefonoObraSocial,15)                                   -- Telefono Obra Social
FROM #ImportacionSocios;
GO

-- ELIMINO LA TABLA TEMPORAL
DROP TABLE #ImportacionSocios;
GO
-------------------------------


--╔════════════════════════════╗
--║ IMPORTACION GRUPO FAMILIAR ║
--╚════════════════════════════╝

-- CREO LA TABLA TEMPORAL
DROP TABLE IF EXISTS #ImportacionGrupoFamiliar;
GO

CREATE TABLE #ImportacionGrupoFamiliar (
    ID_Socio VARCHAR(50),
    ID_SocioTitular VARCHAR(50),
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    DNI VARCHAR(50),
    Email VARCHAR(150),
    FechaNacimiento VARCHAR(50),
    TelefonoContacto VARCHAR(50),
    TelefonoEmergencia VARCHAR(50),
    ObraSocial VARCHAR(50),
    NroSocioObraSocial VARCHAR(50),
    TelefonoEmergenciaObraSocial VARCHAR(50)
);
GO

INSERT INTO #ImportacionGrupoFamiliar                --INSERTO TODA LA TABLA
SELECT *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\ImportacionesSQL\Datos socios.xlsx;HDR=NO;IMEX=1',
    'SELECT * FROM [Grupo Familiar$]'
);
GO

WITH CTE AS (                               -- ELIMINO LA FILA DE ENCABEZADOS
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM #ImportacionGrupoFamiliar
)
DELETE FROM CTE WHERE rn = 1;
GO

-- INSERTO EN GRUPO FAMILIAR CADA TITULAR DISTINTO
INSERT INTO Personas.GrupoFamiliar (Tamaño, Nombre)
SELECT 
    COUNT(*) AS Tamaño,
    CONCAT('Grupo de ', MIN(ID_SocioTitular)) AS Nombre
FROM #ImportacionGrupoFamiliar
GROUP BY ID_SocioTitular;
GO

-- JUNTO SOCIO TITULAR CON SU GRUPO FAMILIAR CON JOIN
WITH MapeoGrupo AS (
    SELECT 
        gf.ID_GrupoFamiliar,                                        -- ID GRUPO FAMILIAR
        sf.ID_SocioTitular                                          -- ID SOCIO TITULAR    
    FROM Personas.GrupoFamiliar gf
    JOIN (
        SELECT DISTINCT ID_SocioTitular FROM #ImportacionGrupoFamiliar
    ) sf ON CONCAT('Grupo de ', sf.ID_SocioTitular) = gf.Nombre
)
-- INSERTO AL NUEVO SOCIO A LA TABLA SOCIO USANDO EL JOIN ANTERIOR PARA EL GRUPO FAMILIAR
INSERT INTO Personas.Socio (
    ID_Socio, DNI, Nombre, Apellido, Email, TelefonoContacto,
    FechaNacimiento, TelefonoEmergencia, ObraSocial, NroSocioObraSocial,
    TelefonoEmergenciaObraSocial, ID_GrupoFamiliar
)
SELECT 
    ID_Socio,                                               -- ID SOCIO
    TRY_CAST(DNI AS INT),                                   -- DNI
    Nombre,                                                 -- NOMBRE
    Apellido,                                               -- APELLIDO
    Email,                                                  -- EMAIL
    TelefonoContacto,                                       -- TELEFONO CONTACTO
    TRY_CONVERT(DATE, FechaNacimiento, 103),                -- FECHA NACIMIENTO
    TelefonoEmergencia,                                     -- TELEFONO EMERGENCIA
    ObraSocial,                                             -- OBRA SOCIAL
    NroSocioObraSocial,                                     -- NRO DE SOCIO DE OBRA SOCIAL
    TelefonoEmergenciaObraSocial,                           -- TELEFONO DE EMERGENCIA DE OBRA SOCIAL
    mg.ID_GrupoFamiliar                                     -- ID GRUPO FAMILIAR
FROM #ImportacionGrupoFamiliar igf
JOIN MapeoGrupo mg ON igf.ID_SocioTitular = mg.ID_SocioTitular;
GO


-- INSERTO SOCIOS Y TUTORES EN SOCIOTUTOR
INSERT INTO Personas.SocioTutor (ID_Tutor, ID_Menor)
SELECT 
    igf.ID_SocioTitular,                                        -- ID SOCIO TUTOR
    s.ID_Socio                                                  -- ID SOCIO 
FROM #ImportacionGrupoFamiliar igf
JOIN Personas.Socio s 
    ON s.DNI = igf.DNI 
    AND LTRIM(RTRIM(LOWER(s.Nombre))) = LTRIM(RTRIM(LOWER(igf.Nombre)))
    AND LTRIM(RTRIM(LOWER(s.Apellido))) = LTRIM(RTRIM(LOWER(igf.Apellido)))
WHERE 
    igf.ID_SocioTitular IN (SELECT ID_Socio FROM Personas.Socio)
    AND NOT EXISTS (
        SELECT 1 FROM Personas.SocioTutor st 
        WHERE st.ID_Tutor = igf.ID_SocioTitular AND st.ID_Menor = s.ID_Socio
    );
GO

DROP TABLE #ImportacionGrupoFamiliar
GO
-------------------------------


--╔════════════════════════════╗
--║ IMPORTACION PAGO DE CUOTAS ║
--╚════════════════════════════╝

--INSERTO LOS MEDIOS DE PAGO, AUNQUE DEBERIAN YA ESTAR CREADOS
IF NOT EXISTS (SELECT 1 FROM Facturacion.MedioDePago WHERE Tipo = 'Efectivo')
    INSERT INTO Facturacion.MedioDePago (Tipo) VALUES ('Efectivo');

IF NOT EXISTS (SELECT 1 FROM Facturacion.MedioDePago WHERE Tipo = 'Tarjeta')
    INSERT INTO Facturacion.MedioDePago (Tipo) VALUES ('Tarjeta');

IF NOT EXISTS (SELECT 1 FROM Facturacion.MedioDePago WHERE Tipo = 'Transferencia')
    INSERT INTO Facturacion.MedioDePago (Tipo) VALUES ('Transferencia');

--CREO TABLA TEMPORAL
DROP TABLE IF EXISTS #ImportacionPagos;

CREATE TABLE #ImportacionPagos (
    ID_Pago VARCHAR(50),
    Fecha VARCHAR(50),
    Responsable VARCHAR(50),
    Valor VARCHAR(50),
    MedioDePago VARCHAR(50)
);

INSERT INTO #ImportacionPagos               --INSERTO TODA LA TABLA
SELECT *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\ImportacionesSQL\Datos socios.xlsx;HDR=NO;IMEX=1',
    'SELECT * FROM [pago cuotas$]'
);
GO

WITH CTE AS (                               -- ELIMINO LA FILA DE ENCABEZADOS
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM #ImportacionPagos
)
DELETE FROM CTE WHERE rn = 1;
GO

-- INSERTO EN LA TABLA DE PAGOS
INSERT INTO Facturacion.Pago (ID_Pago, FechaPago, ID_Socio, Monto, ID_MedioDePago)
SELECT 
    LTRIM(RTRIM(ID_Pago)),                                        -- ID de pago
    ISNULL(                                                       -- Fecha de pago
        TRY_CONVERT(DATE, Fecha, 103),
        NULL
    ),                                      
    LTRIM(RTRIM(Responsable)),                                    -- ID de pago
    TRY_CAST(Valor AS INT),                                       -- Monto
    mp.ID_MedioDePago                                             -- ID real del medio de pago
 FROM #ImportacionPagos p
   JOIN Facturacion.MedioDePago mp
    ON LTRIM(RTRIM(p.MedioDePago)) = LTRIM(RTRIM(mp.Tipo))
GO

DROP TABLE #ImportacionPagos
GO
-------------------------------


--╔════════════════════════╗
--║ IMPORTACION DE TARIFAS ║
--╚════════════════════════╝

-- TARIFAS ACTVIDADES 

--CREO TABLA TEMPORAL
DROP TABLE IF EXISTS #ImportcionTarifasActividades;

CREATE TABLE #ImportcionTarifasActividades(
    Nombre VARCHAR(50),
    CostoMensual VARCHAR(50),
    FechaVigenciaCosto VARCHAR(50)
);

INSERT INTO #ImportcionTarifasActividades              --INSERTO TODA LA TABLA
SELECT *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\ImportacionesSQL\Datos socios.xlsx;HDR=NO;IMEX=1',
    'SELECT * FROM [Tarifas$B3:D8]'
);
GO

-- INSERTO EN LA TABLA DE ACTIVIDADES
INSERT INTO Actividades.Actividad (Nombre, CostoMensual, FecVigenciaCosto) 
SELECT 
    LTRIM(RTRIM(Nombre)),                                                -- Nombre                            
    TRY_CAST(CostoMensual AS DECIMAL(18, 2)),                            -- Monto
    TRY_CONVERT(DATE, FechaVigenciaCosto, 103)                           -- Fecha vigencia de costo 
FROM #ImportcionTarifasActividades
GO

DROP TABLE #ImportcionTarifasActividades
GO


-- TARIFAS CATEGORIAS

--CREO TABLA TEMPORAL
DROP TABLE IF EXISTS #ImportacionCuotaCategoria;
GO

CREATE TABLE #ImportacionCuotaCategoria(
    Categoria VARCHAR(50),
    CostoMensual VARCHAR(50),
    FechaVigenciaCosto VARCHAR(50)
);
GO

INSERT INTO #ImportacionCuotaCategoria               --INSERTO TODA LA TABLA
SELECT *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\ImportacionesSQL\Datos socios.xlsx;HDR=NO;IMEX=1',
    'SELECT * FROM [Tarifas$B11:D13]'
);
GO

-- INSERTO EN LA TABLA DE CATEGORIAS
INSERT INTO Personas.Categoria (Descripcion,  Importe, FecVigenciaCosto) 
SELECT 
    LTRIM(RTRIM(Categoria)),                                             -- Nombre                            
    TRY_CAST(CostoMensual AS DECIMAL(18, 2)),                            -- Monto
    TRY_CONVERT(DATE, FechaVigenciaCosto, 103)                           -- Fecha vigencia de costo 
FROM #ImportacionCuotaCategoria 
GO

DROP TABLE #ImportacionCuotaCategoria
GO
----

-- COSTOS PILETA

--CREO TABLA TEMPORAL
DROP TABLE IF EXISTS #ImportacionCostoPileta;
GO

CREATE TABLE #ImportacionCostoPileta (
    Socio VARCHAR(50),
    Invitado VARCHAR(50),
    VigenteHasta VARCHAR(50)
);
GO

INSERT INTO #ImportacionCostoPileta               --INSERTO TODA LA TABLA
SELECT *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\ImportacionesSQL\Datos socios.xlsx;HDR=NO;IMEX=1',
    'SELECT * FROM [Tarifas$D17:F18]'
);
GO

-- INSERTO EN LA TABLA DE CATEGORIAS
WITH Datos AS (                         -- SEPARO LOS DATOS POR FILAS
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS fila,
        Socio,
        Invitado,
        VigenteHasta
    FROM #ImportacionCostoPileta
)
INSERT INTO Actividades.CostosPileta (CostoSocio, CostoSocioMenor, CostoInvitado, CostoInvitadoMenor, FecVigenciaCostos)
SELECT             -- INSERTO SEGUN LA FILA, PARA GENERAR UNA UNICA FILA
    TRY_CAST(MAX(CASE WHEN fila = 1 THEN Socio END) AS DECIMAL(18,2)),       -- Adulto socio
    TRY_CAST(MAX(CASE WHEN fila = 2 THEN Socio END) AS DECIMAL(18,2)),       -- Menor socio
    TRY_CAST(MAX(CASE WHEN fila = 1 THEN Invitado END) AS DECIMAL(18,2)),    -- Adulto invitado
    TRY_CAST(MAX(CASE WHEN fila = 2 THEN Invitado END) AS DECIMAL(18,2)),    -- Menor invitado
    TRY_CONVERT(DATE, MAX(VigenteHasta), 103)                                -- Fecha común
FROM Datos;
GO
DROP TABLE #ImportacionCostoPileta
GO
-------------------------------


--╔════════════════════════════╗
--║ IMPORTACION DE PRESENTISMO ║
--╚════════════════════════════╝

-- INSERSION PARA PODER IMPORTAR, ESTOS DEBERIAN ESTAR EN UN JUEGO DE PRUEBA
INSERT INTO Personas.Profesor (ID_Profesor, Nombre, Apellido)
SELECT *
FROM (
    VALUES 
        ('PF-0001', 'Pablo', 'Rodrigez'),
        ('PF-0002', 'Ana Paula', 'Alvarez'),
        ('PF-0003', 'Kito', 'Mihaji'),
        ('PF-0004', 'Carolina', 'Herreta'),
        ('PF-0005', 'Paula', 'Quiroga'),
        ('PF-0006', 'Hector', 'Alvarez'),
        ('PF-0007', 'Roxana', 'Guiterrez')
) AS v(ID_Profesor, Nombre, Apellido)
WHERE NOT EXISTS (
    SELECT 1 FROM Personas.Profesor p WHERE p.ID_Profesor = v.ID_Profesor
);


-- CREO LA TABLA TEMPORAL
DROP TABLE IF EXISTS #ImportacionPresentismo;   
GO

CREATE TABLE #ImportacionPresentismo (
    NroDeSocio VARCHAR(30),
    Actividad VARCHAR(100),
    FechaActividad VARCHAR(50),
    Asistencia VARCHAR(50),
    NombreYApellidoProfe VARCHAR(100)
);
GO


INSERT INTO #ImportacionPresentismo                             --INSERTO TODA LA TABLA
SELECT F1,F2,F3,F4,F5
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\ImportacionesSQL\Datos socios.xlsx;HDR=NO;IMEX=1',
    'SELECT * FROM [presentismo_actividades$]'
);
GO

WITH CTE AS (                                                   -- ELIMINO LA FILA DE ENCABEZADOS
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM #ImportacionPresentismo
)
DELETE FROM CTE WHERE rn = 1;
GO

-- INSERTO EN LA TABLA ACTIVIDAD REALIZADA
INSERT INTO Actividades.ActividadRealizada (ID_Actividad, ID_Socio, FechaActividad, Asistencia, ID_Profesor)
SELECT 
    act.ID_Actividad,                                                                     -- ID_Actividad
    imp.NroDeSocio,                                                                       -- ID_Socio
    TRY_CONVERT(DATE, imp.FechaActividad, 103),                                           -- Fecha de Actividad       
    CASE                                                                                  -- Asistencia (A, P, J)
        WHEN LOWER(LTRIM(RTRIM(imp.Asistencia))) IN ('p', 'pp', 'presente') THEN 'P'
        WHEN LOWER(LTRIM(RTRIM(imp.Asistencia))) IN ('a', 'aa', 'ausente') THEN 'A'
        WHEN LOWER(LTRIM(RTRIM(imp.Asistencia))) IN ('j', 'jj', 'justificado') THEN 'J'
    END,
    prof.ID_Profesor                                                                      -- ID_Profesor
FROM #ImportacionPresentismo imp
JOIN Actividades.Actividad act 
    ON LTRIM(RTRIM(LOWER(act.Nombre))) = LTRIM(RTRIM(LOWER(imp.Actividad)))
JOIN Personas.Profesor prof 
    ON LTRIM(RTRIM(LOWER(prof.Nombre + ' ' + prof.Apellido))) = LTRIM(RTRIM(LOWER(imp.NombreYApellidoProfe)))
WHERE EXISTS (
    SELECT 1 FROM Personas.Socio s WHERE s.ID_Socio = imp.NroDeSocio
);

-- ELIMINO TABLA TEMPORAL
DROP TABLE #ImportacionPresentismo
GO
-------------------------------


SELECT * FROM Personas.Socio

SELECT * FROM Personas.Socio
SELECT * FROM Personas.SocioTutor
SELECT * FROM Personas.GrupoFamiliar

SELECT * FROM Facturacion.Pago p
JOIN Facturacion.MedioDePago mp ON p.ID_MedioDePago = mp.ID_MedioDePago

SELECT * FROM Actividades.ActividadRealizada

SELECT * FROM Actividades.Actividad
SELECT * FROM Personas.Categoria
SELECT * FROM Actividades.CostosPileta

GO