import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class ConstanciaDepositoRepositoryImpl implements ConstanciaDepositoRepository 
{
  final ConstanciaDepositoDatasource datasource;

  ConstanciaDepositoRepositoryImpl(this.datasource);

  @override
  Future<List<ConstanciaDeposito>> getListKardex(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta) {
    return datasource.getListKardex(fechaInicio, fechaFin, cliente, planta);
  }
}