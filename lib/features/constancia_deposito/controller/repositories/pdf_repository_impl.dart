import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class PdfRepositoryImpl extends PdfRepository 
{
  final PdfDatasource datasource;

  PdfRepositoryImpl(this.datasource);

  @override
  Future<FileResponse> getKardexPDF(String folioCliente) 
  {
    return datasource.getKardexPDF(folioCliente);
  }
  
  @override
  Future<FileResponse> getEntradaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) 
  {
    return datasource.getEntradaPDF(fechaInicio, fechaFin, cliente, planta, camara);
  }
  
  @override
  Future<FileResponse> getSalidaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) 
  {
    return datasource.getSalidaPDF(fechaInicio, fechaFin, cliente, planta, camara);
  }
  
  @override
  Future<FileResponse> getInventarioPDF(DateTime fecha, int? cliente, int? planta) 
  {
    return datasource.getInventarioPDF(fecha, cliente, planta);
  }

}