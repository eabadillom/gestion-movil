import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

abstract class KardexPdfDatasource 
{
  Future<FileResponse> getKardexPDF(String folioCliente);
}