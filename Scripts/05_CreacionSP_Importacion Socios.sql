USE Com5600G06
GO

--╔═════════════════════════════════════════════════════════════════╗
--║ CREACION STORE PROCEDURE PARA IMPORTACION DE SOCIOS DESDE .xlsx ║
--╚═════════════════════════════════════════════════════════════════╝

CREATE OR ALTER PROCEDURE ImportarDatosDesdeExcel
    @RutaArchivo NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
    BEGIN TRANSACTION;
-----------------------------------------------------------------

    DECLARE @sql NVARCHAR(MAX);

    --╔══════════════════════════════════╗
    --║ IMPORTACION RESPONSABLES DE PAGO ║
    --╚══════════════════════════════════╝

    --CREO LA TABLA TEMPORAL
    DROP TABLE IF EXISTS #ImportacionSocios;   


    CREATE TABLE #ImportacionSocios (
        NroDeSocio VARCHAR(100),
        Nombre VARCHAR(100),
        Apellido VARCHAR(100),
        DNI VARCHAR (100),
        Email VARCHAR(150),
        FechaNacimiento VARCHAR(100),
        TelefonoContacto VARCHAR(100),
        TelefonoEmergencia VARCHAR(100),
        ObraSocial VARCHAR(100),
        NroSocioObraSocial VARCHAR(100),
        TelefonoObraSocial VARCHAR(100)
    );



    SET @sql = '
    INSERT INTO #ImportacionSocios
    SELECT * FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=NO;IMEX=1'',
        ''SELECT * FROM [Responsables de Pago$]''
    );';

    EXEC(@sql);


    WITH CTE AS (                               -- ELIMINO LA FILA DE ENCABEZADOS
        SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM #ImportacionSocios
    )
    DELETE FROM CTE WHERE rn = 1;


    -- INSERTO EN LA TABLA DE SOCIOS
    INSERT INTO Personas.Socio(
        ID_socio, Nombre, Apellido, DNI, Email, FechaNacimiento,
        TelefonoContacto, TelefonoEmergencia, ObraSocial,
        NroSocioObraSocial, TelefonoEmergenciaObraSocial
    )
    SELECT 
        LTRIM(RTRIM(NroDeSocio)),
        UPPER(LEFT(LEFT(LTRIM(RTRIM(Nombre)), CHARINDEX(' ', LTRIM(RTRIM(Nombre)) + ' ') - 1), 1)) +    -- Normalizo primer nombre
        LOWER(SUBSTRING(LEFT(LTRIM(RTRIM(Nombre)), CHARINDEX(' ', LTRIM(RTRIM(Nombre)) + ' ') - 1), 2, LEN(Nombre))), 
        UPPER(LEFT(LTRIM(RTRIM(Apellido)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(Apellido)), 2, LEN(Apellido))),  -- Normalizo apellido
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


    -- ELIMINO LA TABLA TEMPORAL
    DROP TABLE #ImportacionSocios;

---------------------------------------------------------------------

    --╔════════════════════════════╗
    --║ IMPORTACION GRUPO FAMILIAR ║
    --╚════════════════════════════╝

    -- CREO LA TABLA TEMPORAL
    DROP TABLE IF EXISTS #ImportacionGrupoFamiliar;


    CREATE TABLE #ImportacionGrupoFamiliar (
        ID_Socio VARCHAR(100),
        ID_SocioTitular VARCHAR(100),
        Nombre VARCHAR(100),
        Apellido VARCHAR(100),
        DNI VARCHAR(100),
        Email VARCHAR(150),
        FechaNacimiento VARCHAR(100),
        TelefonoContacto VARCHAR(100),
        TelefonoEmergencia VARCHAR(100),
        ObraSocial VARCHAR(100),
        NroSocioObraSocial VARCHAR(100),
        TelefonoEmergenciaObraSocial VARCHAR(100)
    );


    SET @sql = '
    INSERT INTO #ImportacionGrupoFamiliar
    SELECT * FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=NO;IMEX=1'',
        ''SELECT * FROM [Grupo Familiar$]''
    );';

    EXEC(@sql);

    WITH CTE AS (                               -- ELIMINO LA FILA DE ENCABEZADOS
        SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM #ImportacionGrupoFamiliar
    )
    DELETE FROM CTE WHERE rn = 1;


    -- INSERTO EN GRUPO FAMILIAR CADA TITULAR DISTINTO
    INSERT INTO Personas.GrupoFamiliar (Tamaño, Nombre)
    SELECT 
        COUNT(*) AS Tamaño,
        CONCAT('Grupo de ', MIN(ID_SocioTitular)) AS Nombre
    FROM #ImportacionGrupoFamiliar
    GROUP BY ID_SocioTitular;


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
        UPPER(LEFT(LEFT(LTRIM(RTRIM(Nombre)), CHARINDEX(' ', LTRIM(RTRIM(Nombre)) + ' ') - 1), 1)) +    -- Normalizo primer nombre
        LOWER(SUBSTRING(LEFT(LTRIM(RTRIM(Nombre)), CHARINDEX(' ', LTRIM(RTRIM(Nombre)) + ' ') - 1), 2, LEN(Nombre))), 
        UPPER(LEFT(LTRIM(RTRIM(Apellido)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(Apellido)), 2, LEN(Apellido))),  -- Normalizo apellido
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


    DROP TABLE #ImportacionGrupoFamiliar

---------------------------------------------------------------------

    --╔════════════════════════════╗
    --║ IMPORTACION PAGO DE CUOTAS ║
    --╚════════════════════════════╝

    --CREO TABLA TEMPORAL
    DROP TABLE IF EXISTS #ImportacionPagos;

    CREATE TABLE #ImportacionPagos (
        ID_Pago VARCHAR(50),
        Fecha VARCHAR(50),
        Responsable VARCHAR(50),
        Valor VARCHAR(50),
        MedioDePago VARCHAR(50)
    );

    SET @sql = '
    INSERT INTO #ImportacionPagos
    SELECT * FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=NO;IMEX=1'',
        ''SELECT * FROM [pago cuotas$]''
    );';

    EXEC(@sql);


    WITH CTE AS (                               -- ELIMINO LA FILA DE ENCABEZADOS
        SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM #ImportacionPagos
    )
    DELETE FROM CTE WHERE rn = 1;


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


    DROP TABLE #ImportacionPagos


---------------------------------------------------------------------

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


    SET @sql = '
    INSERT INTO #ImportcionTarifasActividades
    SELECT * FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=NO;IMEX=1'',
        ''SELECT * FROM [Tarifas$B3:D8]''
    );';

    EXEC(@sql);

    -- INSERTO EN LA TABLA DE ACTIVIDADES
    INSERT INTO Actividades.Actividad (Nombre, CostoMensual, FecVigenciaCosto) 
    SELECT 
        CASE                                                                 -- Nombre
            WHEN LTRIM(RTRIM(Nombre)) = 'Ajederez' THEN 'Ajedrez'
            ELSE LTRIM(RTRIM(Nombre))
        END,                                    
        TRY_CAST(CostoMensual AS DECIMAL(18, 2)),                            -- Monto
        TRY_CONVERT(DATE, FechaVigenciaCosto, 103)                           -- Fecha vigencia de costo 
    FROM #ImportcionTarifasActividades


    DROP TABLE #ImportcionTarifasActividades



    -- TARIFAS CATEGORIAS

    --CREO TABLA TEMPORAL
    DROP TABLE IF EXISTS #ImportacionCuotaCategoria;


    CREATE TABLE #ImportacionCuotaCategoria(
        Categoria VARCHAR(50),
        CostoMensual VARCHAR(50),
        FechaVigenciaCosto VARCHAR(50)
    );

    SET @sql = '
    INSERT INTO #ImportacionCuotaCategoria
    SELECT * FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=NO;IMEX=1'',
        ''SELECT * FROM [Tarifas$B11:D13]''
    );';

    EXEC(@sql);

    -- INSERTO EN LA TABLA DE CATEGORIAS
    INSERT INTO Personas.Categoria (Descripcion, Importe, FecVigenciaCosto) 
    SELECT 
        LTRIM(RTRIM(Categoria)),                                             -- Nombre                            
        TRY_CAST(CostoMensual AS DECIMAL(18, 2)),                            -- Monto
        TRY_CONVERT(DATE, FechaVigenciaCosto, 103)                           -- Fecha vigencia de costo 
    FROM #ImportacionCuotaCategoria 


    DROP TABLE #ImportacionCuotaCategoria

    ----

    -- COSTOS PILETA

    --CREO TABLA TEMPORAL
    DROP TABLE IF EXISTS #ImportacionCostoPileta;

    CREATE TABLE #ImportacionCostoPileta (
        Socio VARCHAR(50),
        Invitado VARCHAR(50),
        VigenteHasta VARCHAR(50)
    );

    SET @sql = '
    INSERT INTO #ImportacionCostoPileta
    SELECT * FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=NO;IMEX=1'',
        ''SELECT * FROM [Tarifas$D17:F18]''
    );';

    EXEC(@sql);


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

    DROP TABLE #ImportacionCostoPileta


---------------------------------------------------------------------

    --╔════════════════════════════╗
    --║ IMPORTACION DE PRESENTISMO ║
    --╚════════════════════════════╝

    -- CREO LA TABLA TEMPORAL
    DROP TABLE IF EXISTS #ImportacionPresentismo;   

    CREATE TABLE #ImportacionPresentismo (
        NroDeSocio VARCHAR(30),
        Actividad VARCHAR(100),
        FechaActividad VARCHAR(50),
        Asistencia VARCHAR(50),
        NombreYApellidoProfe VARCHAR(100)
    );

    
    SET @sql = '
    INSERT INTO #ImportacionPresentismo
    SELECT F1,F2,F3,F4,F5 FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=NO;IMEX=1'',
        ''SELECT * FROM [presentismo_actividades$]''
    );';

    EXEC(@sql);

    WITH CTE AS (                                                   -- ELIMINO LA FILA DE ENCABEZADOS
        SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM #ImportacionPresentismo
    )
    DELETE FROM CTE WHERE rn = 1;

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

    COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT 'Error durante la importación: ' + ERROR_MESSAGE();
    END CATCH
END
GO
-----------------------------------------------------------------

/*
USE Com5600G06
GO

EXEC ImportarDatosDesdeExcel
    @RutaArchivo = 'C:\ImportacionesSQL\Datos socios.xlsx'
GO

----

SELECT * FROM Personas.Socio
----
SELECT * FROM Personas.SocioTutor
SELECT * FROM Personas.GrupoFamiliar
----
SELECT * FROM Facturacion.Pago p
JOIN Facturacion.MedioDePago mp ON p.ID_MedioDePago = mp.ID_MedioDePago
----
SELECT * FROM Actividades.ActividadRealizada
----
SELECT * FROM Actividades.Actividad
SELECT * FROM Personas.Categoria
SELECT * FROM Actividades.CostosPileta

GO
*/