import 'package:flutter/material.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';

class SalidasMapper 
{
  static Salidas jsonToEntity(Map<String, dynamic> json) => Salidas
  (
    id: json['id'],
    folio: json['folio'],
    fechaSalida: DateTime.parse(json['fechaSalida']),
    horaSalida: _parseTime(json['horaSalida'])
  );

  static TimeOfDay _parseTime(String value) 
  {
    final partes = value.split(':');

    return TimeOfDay(
      hour: int.parse(partes[0]),
      minute: int.parse(partes[1]),
    );
  }
}