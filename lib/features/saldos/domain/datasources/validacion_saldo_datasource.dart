import 'package:gestion_movil/features/saldos/domain/domain.dart';

abstract class ValidacionSaldoDatasource 
{
  Future<ValidacionSaldo> getValidacionSaldo(int idCliente, DateTime fecha);
}
