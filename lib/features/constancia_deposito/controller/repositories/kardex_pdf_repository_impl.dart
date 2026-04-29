import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class KardexPdfRepositoryImpl extends KardexPdfRepository 
{
  final KardexPdfDatasource datasource;

  KardexPdfRepositoryImpl(this.datasource);

  @override
  Future<FileResponse> getKardexPDF(String folioCliente) 
  {
    return datasource.getKardexPDF(folioCliente);
  }
}