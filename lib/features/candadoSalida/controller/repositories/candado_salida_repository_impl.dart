import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';

class CandadoSalidaRepositoryImpl extends CandadoSalidaRepository
{
  final CandadoSalidaDatasource datasource;

  CandadoSalidaRepositoryImpl(this.datasource);
  
  @override
  Future<Results<CandadoSalida>> getCandadoSalida(int idCliente) async
  {
    try {
      final resultado = await datasource.getCandadoSalida(idCliente);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
  
  @override
  Future<Results<CandadoSalida>> guardarCandadoSalida(CandadoSalida candadoSalida) async
  {
    try {
      final resultado = await datasource.guardarCandadoSalida(candadoSalida);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

}
