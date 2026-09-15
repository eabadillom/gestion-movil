import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/saldos/domain/domain.dart';

abstract class ValidacionSaldoRepository 
{
  Future<Results<ValidacionSaldo>> getValidacionSaldo(int idCliente, DateTime fecha);
}
