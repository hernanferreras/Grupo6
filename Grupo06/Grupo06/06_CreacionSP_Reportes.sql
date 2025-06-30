USE Com5600G06
GO

-- ╔════════════════════════════════╗
-- ║ REPORTE DE MOROSOS RECURRENTES ║
-- ╚════════════════════════════════╝

CREATE OR ALTER PROCEDURE Facturacion.MorososRecurrentes
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Facturas impagas dentro del período
    WITH FacturasImpagas AS (
        SELECT
            f.ID_Factura,
            f.ID_Socio,
            s.Nombre,
            s.Apellido,
            FORMAT(f.FechaVencimiento, 'yyyy-MM') AS MesIncumplido
        FROM Facturacion.Factura f
        INNER JOIN Personas.Socio s ON f.ID_Socio = s.ID_Socio
        WHERE f.Estado = 'Impaga'
          AND f.FechaVencimiento BETWEEN @FechaInicio AND @FechaFin
    ),
    -- 2. Cuotas impagas por socio por mes
    CuotasPorMes AS (
        SELECT
            ID_Socio,
            Nombre,
            Apellido,
            MesIncumplido,
            COUNT(*) AS CantFacturasImpagas
        FROM FacturasImpagas
        GROUP BY ID_Socio, Nombre, Apellido, MesIncumplido
    ),
    -- 3. Total de morosidades (facturas impagas) por socio
    TotalMorosidades AS (
        SELECT
            ID_Socio,
            COUNT(*) AS CantTotMorosidades
        FROM FacturasImpagas
        GROUP BY ID_Socio
    ),
    -- 4. Ranking por cantidad total de morosidades
    Ranking AS (
        SELECT
            ID_Socio,
            CantTotMorosidades,
            RANK() OVER (ORDER BY CantTotMorosidades DESC) AS RankingMorosidad
        FROM TotalMorosidades
    )

    -- 5. Resultado final
    SELECT
        'Morosos Recurrentes' AS NombreReporte,
        @FechaInicio AS FechaInicio,
        @FechaFin AS FechaFin,
        c.ID_Socio AS NroSocio,
        c.Nombre + ' ' + c.Apellido AS NombreCompleto,
        c.MesIncumplido,
        c.CantFacturasImpagas,
        r.CantTotMorosidades,
        r.RankingMorosidad
    FROM CuotasPorMes c
    INNER JOIN Ranking r ON c.ID_Socio = r.ID_Socio
    ORDER BY r.RankingMorosidad, NombreCompleto, c.MesIncumplido;
END;
GO

-------------------------------------------------------------------------------

-- ╔═════════════════════════════════════════╗
-- ║ REPORTE ACUMULADO MENSUAL POR ACTIVIDAD ║
-- ╚═════════════════════════════════════════╝
CREATE OR ALTER PROCEDURE Facturacion.AcumuladoMensualPorActividad
AS
BEGIN
    SET NOCOUNT ON;

    WITH PagosPorActividad AS (
    SELECT
        a.ID_Actividad,
        a.Nombre AS Actividad,
        FORMAT(p.FechaPago, 'yyyy-MM') AS Periodo,
        SUM(p.Monto) AS MontoMes
    FROM Facturacion.Pago p
    INNER JOIN Facturacion.Factura f ON p.ID_Factura = f.ID_Factura
    INNER JOIN Facturacion.Cuota c ON f.ID_Cuota = c.ID_Cuota
    INNER JOIN Actividades.Actividad a ON c.ID_Actividad = a.ID_Actividad
    GROUP BY a.ID_Actividad, a.Nombre, FORMAT(p.FechaPago, 'yyyy-MM')
),
    PagosConMesInt AS (
        SELECT *,
            CAST(LEFT(Periodo, 4) AS INT) AS Anio,
            CAST(RIGHT(Periodo, 2) AS INT) AS Mes
        FROM PagosPorActividad
    ),
    PagosAcumulados AS (
        SELECT 
            p1.ID_Actividad,
            p1.Actividad,
            p1.Periodo,
            p1.MontoMes,
            SUM(p2.MontoMes) AS MontoAcumulado
        FROM PagosConMesInt p1
        INNER JOIN PagosConMesInt p2
            ON p1.ID_Actividad = p2.ID_Actividad
            AND (p2.Anio < p1.Anio OR (p2.Anio = p1.Anio AND p2.Mes <= p1.Mes))
        GROUP BY p1.ID_Actividad, p1.Actividad, p1.Periodo, p1.MontoMes
    )
    SELECT 
        Actividad,
        Periodo,
        MontoMes,
        MontoAcumulado
    FROM PagosAcumulados
    ORDER BY Actividad, Periodo;
END;
GO

-----------------------------------------------------

-- ╔════════════════════════════════════════════════╗
-- ║ REPORTE INASISTENCIA POR CATEGORIA Y ACTIVIDAD ║
-- ╚════════════════════════════════════════════════╝

CREATE OR ALTER PROCEDURE Actividades.InasistenciasPorCategoriaYActividad
AS
BEGIN
    SET NOCOUNT ON;

    WITH Inasistencias AS (
        SELECT
            s.ID_Socio,
            s.Nombre + ' ' + s.Apellido AS NombreCompleto,
            c.Descripcion AS Categoria,
            a.Nombre AS Actividad,
            COUNT(*) AS CantidadInasistencias
        FROM Actividades.ActividadRealizada ar
        INNER JOIN Personas.Socio s ON ar.ID_Socio = s.ID_Socio
        LEFT JOIN Personas.Categoria c ON s.ID_Categoria = c.ID_Categoria
        INNER JOIN Actividades.Actividad a ON ar.ID_Actividad = a.ID_Actividad
        WHERE ar.Asistencia = 'A'
        GROUP BY s.ID_Socio, s.Nombre, s.Apellido, c.Descripcion, a.Nombre
    )
    SELECT 
        Categoria,
        Actividad,
        NombreCompleto,
        CantidadInasistencias
    FROM Inasistencias
    ORDER BY CantidadInasistencias DESC, Categoria, Actividad, NombreCompleto;
END;
GO

--------------------------------------------------------

-- ╔══════════════════════════════════════════════╗
-- ║ REPORTE INASISTENCIA DE SOCIOS A ACTIVIDADES ║
-- ╚══════════════════════════════════════════════╝
CREATE OR ALTER PROCEDURE Actividades.SociosConInasistenciasAActividades
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
        s.Nombre,
        s.Apellido,
        DATEDIFF(YEAR, s.FechaNacimiento, GETDATE()) AS Edad,
        c.Descripcion AS Categoria,
        a.Nombre AS Actividad
    FROM Actividades.ActividadRealizada ar
    INNER JOIN Personas.Socio s ON ar.ID_Socio = s.ID_Socio
    INNER JOIN Actividades.Actividad a ON ar.ID_Actividad = a.ID_Actividad
    LEFT JOIN Personas.Categoria c ON s.ID_Categoria = c.ID_Categoria
    WHERE ar.Asistencia = 'A'
    ORDER BY s.Apellido, s.Nombre, a.Nombre;
END;

-----------------------------------------------------