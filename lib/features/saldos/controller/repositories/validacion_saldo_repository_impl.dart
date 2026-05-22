import 'package:gestion_movil/features/saldos/domain/domain.dart';

class ValidacionSaldoRepositoryImpl extends ValidacionSaldoRepository
{
  final ValidacionSaldoDatasource datasource;

  ValidacionSaldoRepositoryImpl(this.datasource);
  
  @override
  Future<ValidacionSaldo> getValidacionSaldo(int idCliente, DateTime fecha) 
  {
    return datasource.getValidacionSaldo(idCliente, fecha);
  }

}
