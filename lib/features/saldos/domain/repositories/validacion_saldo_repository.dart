import 'package:gestion_movil/features/saldos/domain/domain.dart';

abstract class ValidacionSaldoRepository 
{
  Future<ValidacionSaldo> getValidacionSaldo(int idCliente, DateTime fecha);
}
