import 'package:gestion_movil/features/constancia_deposito/domain/entities/constancia_deposito.dart';

abstract class ConstanciaDepositoDatasource 
{
  Future<List<ConstanciaDeposito>> getListConstanciaDeposito(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta);
}