import 'package:gestion_movil/features/constanciaDeposito/domain/entities/constancia_deposito.dart';

abstract class ConstanciaDepositoDatasource 
{
  Future<List<ConstanciaDeposito>> getListKardex(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta);
}