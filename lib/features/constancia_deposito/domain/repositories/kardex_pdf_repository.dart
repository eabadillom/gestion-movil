import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

abstract class KardexPdfRepository 
{
  Future<FileResponse> getKardexPDF(String folioCliente);
}