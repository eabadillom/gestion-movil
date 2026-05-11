import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

abstract class PdfRepository 
{
  Future<FileResponse> getKardexPDF(String folioCliente);
  Future<FileResponse> getEntradaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara);
  Future<FileResponse> getSalidaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara);
  Future<FileResponse> getInventarioPDF(DateTime fecha, int? cliente, int? planta);
}