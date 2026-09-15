import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';

class PdfRepositoryImpl extends PdfRepository 
{
  final PdfDatasource datasource;

  PdfRepositoryImpl(this.datasource);

  @override
  Future<Results<FileResponse>> getKardexPDF(String folioCliente) async
  {
    try {
      final resultado = await datasource.getKardexPDF(folioCliente);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
  
  @override
  Future<Results<FileResponse>> getEntradaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) async
  {
    try {
      final resultado = await datasource.getEntradaPDF(fechaInicio, fechaFin, cliente, planta, camara);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
  
  @override
  Future<Results<FileResponse>> getSalidaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) async
  {
    try {
      final resultado = await datasource.getSalidaPDF(fechaInicio, fechaFin, cliente, planta, camara);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
  
  @override
  Future<Results<FileResponse>> getInventarioPDF(DateTime fecha, int? cliente, int? planta) async
  {
    try {
      final resultado = await datasource.getInventarioPDF(fecha, cliente, planta);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

}
