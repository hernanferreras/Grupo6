/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/

--                                             ╔═════════════════════╗
/*═════════════════════════════════════════════╣ EJECUCIÓN EN BLOQUE ╠═════════════════════════════════════════════*/
--                                             ╚═════════════════════╝


USE Com5600G06
GO

--╔═══════════════════════════════════════════════════════════════╗
--║ CREACION STORE PROCEDURE PARA IMPORTACION DE CLIMA DESDE .CSV ║
--╚═══════════════════════════════════════════════════════════════╝

CREATE OR ALTER PROCEDURE ImportarClimaDesdeCSV
    @ruta_archivo NVARCHAR(500)
AS
BEGIN
    -- Eliminar tabla temporal previa si existe
    IF OBJECT_ID('tempdb..#ClimaImportRaw') IS NOT NULL
        DROP TABLE #ClimaTemporal;

    -- Crear tabla temporal staging con columnas como NVARCHAR
    CREATE TABLE #ClimaTemporal (
        Fecha NVARCHAR(50),
        Temperatura NVARCHAR(50),
        Lluvia NVARCHAR(50),
        Humedad NVARCHAR(50),
        Viento NVARCHAR(50)
    );

    BEGIN TRY
        -- Realizar el BULK INSERT sobre la tabla staging
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = '
        BULK INSERT #ClimaTemporal
        FROM ''' + @ruta_archivo + '''
        WITH (
            FIRSTROW = 4,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0a'',
            CODEPAGE = ''65001''
        );';

        EXEC sp_executesql @sql;

        -- Comenzamos una transacción para asegurar atomicidad
        BEGIN TRANSACTION;

        -- Insertar datos casteados a la tabla destino
        -- Aclaración: LTRIM elimina espacios vacios al principio de la cadena.
        --             RTRIM elimina espacios vacios al final de la cadena
        INSERT INTO Actividades.Clima (fecha, temperatura, lluvia, humedad, viento)
        SELECT 
            TRY_CAST(REPLACE(LTRIM(RTRIM(Fecha)), 'T', ' ') AS DATETIME),
            TRY_CAST(LTRIM(RTRIM(Temperatura)) AS FLOAT),
            TRY_CAST(LTRIM(RTRIM(Lluvia)) AS FLOAT),
            TRY_CAST(LTRIM(RTRIM(Humedad)) AS INT),
            TRY_CAST(LTRIM(RTRIM(Viento)) AS FLOAT)
        FROM #ClimaTemporal
        WHERE 
            -- Validamos sólo insertar datos válidos
            TRY_CAST(REPLACE(LTRIM(RTRIM(Fecha)), 'T', ' ') AS DATETIME) IS NOT NULL
            AND TRY_CAST(LTRIM(RTRIM(Temperatura)) AS FLOAT) IS NOT NULL
            AND TRY_CAST(LTRIM(RTRIM(Lluvia)) AS FLOAT) IS NOT NULL
            AND TRY_CAST(LTRIM(RTRIM(Humedad)) AS INT) IS NOT NULL
            AND TRY_CAST(LTRIM(RTRIM(Viento)) AS FLOAT) IS NOT NULL
            AND NOT EXISTS (            -- Para que me evitar fechas que ya esten insertadas
                SELECT 1
                FROM Actividades.Clima c
                WHERE c.fecha = TRY_CAST(REPLACE(LTRIM(RTRIM(#ClimaTemporal.Fecha)), 'T', ' ') AS DATETIME)
             );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error durante la importación.' + ERROR_MESSAGE()
    END CATCH
END
GO
----------------------------------------------------------------------