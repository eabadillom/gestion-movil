import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/saldos/domain/domain.dart';

class ValidacionSaldoRepositoryImpl extends ValidacionSaldoRepository
{
  final ValidacionSaldoDatasource datasource;

  ValidacionSaldoRepositoryImpl(this.datasource);
  
  @override
  Future<Results<ValidacionSaldo>> getValidacionSaldo(int idCliente, DateTime fecha) async
  {
    try {
      final resultado = await datasource.getValidacionSaldo(idCliente, fecha);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

}
