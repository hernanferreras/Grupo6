/*
# Grupo6
Integrantes:
DNI  /  Apellido  /  Nombre  /  Email / usuario GitHub
46291918  Almada  Keila Mariel  kei.alma01@gmail.com  Kei3131
23103568  Ferreras  Hernan  maxher73@gmail.com  hernanferreras
44793833 Bustamante Alan bustamantealangabriel@hotmail.com Alanbst
*/


-- ╔══════════════════════════════╗ 
-- ║ LOTE DE PRUEBA PARA REPORTES ║ 
-- ╚══════════════════════════════╝ 

-- CREAR SOCIO
EXEC Personas.InsertarSocio
    @ID_Socio = 'SN001', @DNI = 12345678, @Nombre = 'Juan', @Apellido = 'Perez', @Email = 'juan@gmail.com', @TelefonoContacto = '1234-5678',
    @TelefonoEmergencia = '1234-9999', @FechaNacimiento = '1990-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0001',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

EXEC Personas.InsertarSocio
    @ID_Socio = 'SN002', @DNI = 23456789, @Nombre = 'José', @Apellido = 'Ramirez', @Email = 'jose@gmail.com', @TelefonoContacto = '9876-5432',
    @TelefonoEmergencia = '1111-2222', @FechaNacimiento = '1980-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0002',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

EXEC Personas.InsertarSocio
    @ID_Socio = 'SN003', @DNI = 34567890, @Nombre = 'Francisco', @Apellido = 'Gonzalez', @Email = 'francisco@gmail.com', @TelefonoContacto = '5555-6666',
    @TelefonoEmergencia = '7777-8888', @FechaNacimiento = '1970-01-01', @ObraSocial = 'OSDE', @NroSocioObraSocial = '0003',
    @TelefonoEmergenciaObraSocial = '1234-0000', @ID_Categoria = 3, @ID_GrupoFamiliar = NULL, @ID_Usuario = NULL;

-- CREAR CUENTA

EXEC Facturacion.InsertarCuenta
    @ID_Socio = 'SN001', @NroCuenta = 1, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0
EXEC Facturacion.InsertarCuenta
    @ID_Socio = 'SN002', @NroCuenta = 2, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0
EXEC Facturacion.InsertarCuenta
    @ID_Socio = 'SN003', @NroCuenta = 3, @FechaAlta = '2025-01-01', @FechaBaja = NULL, @Debito = 0, @Credito = 0, @Saldo = 0



EXEC Facturacion.InsertarCuota @ID_Cuota = 1, @FechaCuota = '2025-02-01', @Descripcion = 'Cuota Futsal Febrero', @ID_Actividad = 1;
EXEC Facturacion.InsertarCuota @ID_Cuota = 2, @FechaCuota = '2025-02-01', @Descripcion = 'Cuota Vóley Febrero', @ID_Actividad = 2;
EXEC Facturacion.InsertarCuota @ID_Cuota = 3, @FechaCuota = '2025-03-01', @Descripcion = 'Cuota Futsal Marzo', @ID_Actividad = 1;
EXEC Facturacion.InsertarCuota @ID_Cuota = 4, @FechaCuota = '2025-03-01', @Descripcion = 'Cuota Natación Marzo', @ID_Actividad = 5;
EXEC Facturacion.InsertarCuota @ID_Cuota = 5, @FechaCuota = '2025-04-01', @Descripcion = 'Cuota Futsal Abril', @ID_Actividad = 1;
EXEC Facturacion.InsertarCuota @ID_Cuota = 6, @FechaCuota = '2025-05-01', @Descripcion = 'Cuota Futsal Mayo', @ID_Actividad = 1;
EXEC Facturacion.InsertarCuota @ID_Cuota = 7, @FechaCuota = '2025-06-01', @Descripcion = 'Cuota Vóley Junio', @ID_Actividad = 2;
EXEC Facturacion.InsertarCuota @ID_Cuota = 8, @FechaCuota = '2025-05-01', @Descripcion = 'Cuota Taekwondo Mayo', @ID_Actividad = 3;
EXEC Facturacion.InsertarCuota @ID_Cuota = 9, @FechaCuota = '2025-05-01', @Descripcion = 'Cuota Baile artístico Mayo', @ID_Actividad = 4;
EXEC Facturacion.InsertarCuota @ID_Cuota = 10, @FechaCuota = '2025-05-01', @Descripcion = 'Cuota Natación Mayo', @ID_Actividad = 5;
EXEC Facturacion.InsertarCuota @ID_Cuota = 11, @FechaCuota = '2025-06-01', @Descripcion = 'Cuota Baile artístico Junio', @ID_Actividad = 4;
EXEC Facturacion.InsertarCuota @ID_Cuota = 12, @FechaCuota = '2025-07-01', @Descripcion = 'Cuota Baile artístico Julio', @ID_Actividad = 4;
EXEC Facturacion.InsertarCuota @ID_Cuota = 13, @FechaCuota = '2025-08-01', @Descripcion = 'Cuota Baile artístico Agosto', @ID_Actividad = 4;

-- Crear Facturas (el SP InsertarFactura ya obtiene el importe de la actividad asociada a la cuota)
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 1, @Numero = 'F0001', @FechaEmision = '2025-02-01', 
                                          @FechaVencimiento = '2025-02-06', @Recargo = 0, @ID_Cuota = 1, 
                                          @ID_Socio = 'SN001', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 2, @Numero = 'F0002', @FechaEmision = '2025-02-01',
                                          @FechaVencimiento = '2025-02-06', @Recargo = 0, @ID_Cuota = 2, 
                                          @ID_Socio = 'SN001', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 3, @Numero = 'F0003', @FechaEmision = '2025-03-01', 
                                          @FechaVencimiento = '2025-03-06', @Recargo = 0, @ID_Cuota = 3, 
                                          @ID_Socio = 'SN001', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 4, @Numero = 'F0004', @FechaEmision = '2025-03-01', 
                                          @FechaVencimiento = '2025-03-06', @Recargo = 0, @ID_Cuota = 4, 
                                          @ID_Socio = 'SN001', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 5, @Numero = 'F0005', @FechaEmision = '2025-04-01', 
                                          @FechaVencimiento = '2025-04-06', @Recargo = 0, @ID_Cuota = 5, 
                                          @ID_Socio = 'SN001', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 6, @Numero = 'F0006', @FechaEmision = '2025-05-03', 
                                          @FechaVencimiento = '2025-05-08', @Recargo = 0, @ID_Cuota = 6, 
                                          @ID_Socio = 'SN002', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 7, @Numero = 'F0007', @FechaEmision = '2025-05-03', 
                                          @FechaVencimiento = '2025-05-08', @Recargo = 0, @ID_Cuota = 7, 
                                          @ID_Socio = 'SN002', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 8, @Numero = 'F0008', @FechaEmision = '2025-05-03', 
                                          @FechaVencimiento = '2025-05-08', @Recargo = 0, @ID_Cuota = 8, 
                                          @ID_Socio = 'SN002', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 9, @Numero = 'F0009', @FechaEmision = '2025-05-03', 
                                          @FechaVencimiento = '2025-05-08', @Recargo = 0, @ID_Cuota = 9, 
                                          @ID_Socio = 'SN002', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 10, @Numero = 'F0010', @FechaEmision = '2025-05-03', 
                                          @FechaVencimiento = '2025-05-08', @Recargo = 0, @ID_Cuota = 10, 
                                          @ID_Socio = 'SN002', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 11, @Numero = 'F0011', @FechaEmision = '2025-05-10',
                                          @FechaVencimiento = '2025-05-15', @Recargo = 0, @ID_Cuota = 10, 
                                          @ID_Socio = 'SN003', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 12, @Numero = 'F0012', @FechaEmision = '2025-06-10',
                                          @FechaVencimiento = '2025-06-15', @Recargo = 0, @ID_Cuota = 11, 
                                          @ID_Socio = 'SN003', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 13, @Numero = 'F0013', @FechaEmision = '2025-07-04', 
                                          @FechaVencimiento = '2025-07-09', @Recargo = 0, @ID_Cuota = 12, 
                                          @ID_Socio = 'SN003', @ID_Descuento = NULL;
EXEC Facturacion.InsertarFacturaActividad @ID_Factura = 14, @Numero = 'F0014', @FechaEmision = '2025-08-04', 
                                          @FechaVencimiento = '2025-08-09', @Recargo = 0, @ID_Cuota = 13, 
                                          @ID_Socio = 'SN003', @ID_Descuento = NULL;

-- Crear ItemFactura
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 1, @ID_Item = 1, @Descripcion = 'Cuota Futsal Febrero';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 2, @ID_Item = 2, @Descripcion = 'Cuota Vóley Febrero';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 3, @ID_Item = 3, @Descripcion = 'Cuota Futsal Marzo';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 4, @ID_Item = 4, @Descripcion = 'Cuota Natación Marzo';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 5, @ID_Item = 5, @Descripcion = 'Cuota Futsal Abril';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 6, @ID_Item = 6, @Descripcion = 'Cuota Futsal Mayo';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 7, @ID_Item = 7, @Descripcion = 'Cuota Vóley Junio';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 8, @ID_Item = 8, @Descripcion = 'Cuota Taekwondo Mayo';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 9, @ID_Item = 9, @Descripcion = 'Cuota Baile artístico Mayo';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 10, @ID_Item = 10, @Descripcion = 'Cuota Natación Mayo';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 11, @ID_Item = 11, @Descripcion = 'Cuota Natación Mayo';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 12, @ID_Item = 12, @Descripcion = 'Cuota Baile artístico Junio';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 13, @ID_Item = 13, @Descripcion = 'Cuota Baile artístico Julio';
EXEC Facturacion.InsertarItemFacturaActividad @ID_Factura = 14, @ID_Item = 14, @Descripcion = 'Cuota Baile artístico Agosto';


-- CREAR PAGOS
EXEC Facturacion.InsertarPago @ID_Pago = 1, @FechaPago = '2025-05-04', @Monto = 30000, @ID_MedioDePago = 2, 
    @NroCuenta = 2, @ID_Socio = 'SN002', @ID_Factura = 8
EXEC Facturacion.InsertarPago @ID_Pago = 2, @FechaPago = '2025-05-10', @Monto = 45000, @ID_MedioDePago = 3, 
    @NroCuenta = 3, @ID_Socio = 'SN003', @ID_Factura = 11

-- ACTUALIZAR FACTURAS
EXEC Facturacion.ActualizarEstadoFactura @ID_Factura = 8
EXEC Facturacion.ActualizarEstadoFactura @ID_Factura = 11


-- ╔═════════════════════╗
-- ║ PRUEBAS DE REPORTES ║
-- ╚═════════════════════╝

-- REPORTE MOROSOS RECURRENTES
EXEC Facturacion.MorososRecurrentes
    @FechaInicio = '2025-01-01',
    @FechaFin = '2025-12-31';

-- REPORTE INSASISTENCIA POR CATEGORIA Y ACTIVIDAD
EXEC Actividades.InasistenciasPorCategoriaYActividad

-- REPORTE SOCIOS CON INASISTENCIA A ACTIVIDADES
EXEC Actividades.SociosConInasistenciasAActividades

-- REPORTE DE ACUMULADO MENSUAL POR ACTIVIDAD
EXEC Facturacion.AcumuladoMensualPorActividad

/*
SELECT * FROM Personas.Socio
SELECT * FROM Facturacion.Cuenta
SELECT * FROM Facturacion.Factura
SELECT * FROM Facturacion.ItemFactura
SELECT * FROM Facturacion.Pago
SELECT * FROM Actividades.Actividad
*/