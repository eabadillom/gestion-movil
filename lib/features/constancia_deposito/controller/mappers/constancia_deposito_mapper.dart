import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class ConstanciaDepositoMapper 
{
  static ConstanciaDeposito jsonToEntity(Map<String, dynamic> json) => ConstanciaDeposito
  (
    folio: json['folio'],
    fechaIngreso: DateTime.parse(json['fechaIngreso']),
    folioCliente: json['folioCliente'],
  );
  
}
