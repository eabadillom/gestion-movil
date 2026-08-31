import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';

class ConstanciaDepositoRepositoryImpl implements ConstanciaDepositoRepository 
{
  final ConstanciaDepositoDatasource datasource;

  ConstanciaDepositoRepositoryImpl(this.datasource);

  @override
  Future<Results<List<ConstanciaDeposito>>> getListKardex(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta) async
  {
    try {
      final resultado = await datasource.getListKardex(fechaInicio, fechaFin, cliente, planta);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
}
