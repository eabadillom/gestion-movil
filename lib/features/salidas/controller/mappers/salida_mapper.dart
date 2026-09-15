import 'package:flutter/material.dart';
import 'package:gestion_movil/conf/util/format_util.dart';
import 'package:gestion_movil/features/salidas/controller/controller.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';

class SalidaMapper 
{
  static Salida jsonToEntity(Map<String, dynamic> json) => Salida(
    id: json["id"],
    folio: json["folio"],
    fechaSalida: DateTime.parse(json["fechaSalida"]),
    horaSalida: _parseTime(json["horaSalida"]),
    nombreTransportista: json["nombreTransportista"] ?? '',
    placasTransporte: json["placasTransporte"] ?? '',
    observaciones: json["observaciones"] ?? '',
    statusSalida: StatusSalidaMapper.jsonToEntity(json["statusSalida"]), 
    salidaDetalles: List<SalidaDetalle>.from(json["salidaDetalles"].map((x) => SalidaDetalleMapper.jsonToEntity(x))),
  );

  static Map<String, dynamic> toJson(Salida salida) => {
    "id": salida.id,
    "folio": salida.folio,
    "fechaSalida": FormatUtil.stringToISO(salida.fechaSalida),
    "horaSalida": _timeOfDayToString(salida.horaSalida),
    "nombreTransportista": salida.nombreTransportista,
    "placasTransporte": salida.placasTransporte,
    "observaciones": salida.observaciones,
    "statusSalida": StatusSalidaMapper.toJson(salida.statusSalida),
    "salidaDetalles": List<dynamic>.from(salida.salidaDetalles.map((x) => SalidaDetalleMapper.toJson(x))),
  };

  static TimeOfDay _parseTime(String value) 
  {
    final partes = value.split(':');

    return TimeOfDay(
      hour: int.parse(partes[0]),
      minute: int.parse(partes[1]),
    );
  }

  static String _timeOfDayToString(TimeOfDay time) 
  {
    return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}:00';
  }

}