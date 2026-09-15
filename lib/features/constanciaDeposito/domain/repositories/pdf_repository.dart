import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';

abstract class PdfRepository 
{
  Future<Results<FileResponse>> getKardexPDF(String folioCliente);
  Future<Results<FileResponse>> getEntradaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara);
  Future<Results<FileResponse>> getSalidaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara);
  Future<Results<FileResponse>> getInventarioPDF(DateTime fecha, int? cliente, int? planta);
}