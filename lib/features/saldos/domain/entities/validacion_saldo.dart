import 'package:decimal/decimal.dart';

class ValidacionSaldo 
{
  bool isHabilitarSalida;
  Decimal saldoVencido;
  String descripcion;

  ValidacionSaldo({
    required this.isHabilitarSalida,
    required this.saldoVencido,
    required this.descripcion
  });

  ValidacionSaldo copyWith({
    bool? isHabilitarSalida,
    Decimal? saldoVencido,
    String? descripcion,
  }) {
    return ValidacionSaldo(
      isHabilitarSalida: isHabilitarSalida ?? this.isHabilitarSalida,
      saldoVencido: saldoVencido ?? this.saldoVencido,
      descripcion: descripcion ?? this.descripcion,
    );
  }

}
