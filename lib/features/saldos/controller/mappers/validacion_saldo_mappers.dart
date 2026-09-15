import 'package:decimal/decimal.dart';
import 'package:gestion_movil/features/saldos/domain/entities/validacion_saldo.dart';

class ValidacionSaldoMappers 
{
  static ValidacionSaldo jsonToEntity(Map<String, dynamic> json) => ValidacionSaldo(
    isHabilitarSalida: json['isHabilitarSalida'] as bool,
    saldoVencido: Decimal.parse(json['saldoVencido'].toString()),
    descripcion: json['descripcion']
  );
  
}