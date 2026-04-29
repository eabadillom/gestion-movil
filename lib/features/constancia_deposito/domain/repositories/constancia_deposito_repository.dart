import 'package:gestion_movil/features/constancia_deposito/domain/entities/constancia_deposito.dart';

abstract class ConstanciaDepositoRepository 
{
  Future<List<ConstanciaDeposito>> getConstanciaDeposito(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta);
}