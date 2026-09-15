import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';

class SalidasRepositoryImpl implements SalidasRepository
{
  final SalidasDatasource datasource;

  SalidasRepositoryImpl(this.datasource);

  @override
  Future<Results<List<Salidas>>> getSalidas(int? idCliente, DateTime fechaInicio, DateTime fechaFin) async
  {
    try {
      final resultado = await datasource.getSalidas(idCliente, fechaInicio, fechaFin);
      
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

  @override
  Future<Results<Salida>> getDetalleSalida(int idSalida) async 
  {
    try {
      final resultado = await datasource.getDetalleSalida(idSalida);

      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

  @override
  Future<Results<bool>> candelarSalida(int idSalida) async
  {
    try {
      await datasource.cancelarSalida(idSalida);

      return const Success(true);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

}
