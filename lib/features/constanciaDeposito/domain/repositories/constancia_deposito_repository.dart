import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/entities/constancia_deposito.dart';

abstract class ConstanciaDepositoRepository 
{
  Future<Results<List<ConstanciaDeposito>>> getListKardex(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta);
}
