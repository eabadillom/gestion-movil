import 'package:flutter/material.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';

class Salida 
{
  final int id;
  final String folio;
  final String nombre;
  final DateTime fechaSalida;
  final TimeOfDay horaSalida;
  final String? nombreTransportista;
  final String? placasTransporte;
  final String? observaciones;
  final StatusSalida statusSalida;
  final List<SalidaDetalle> salidaDetalles;

  Salida({
    required this.id,
    required this.folio,
    required this.nombre,
    required this.fechaSalida,
    required this.horaSalida,
    this.nombreTransportista,
    this.placasTransporte,
    this.observaciones,
    required this.statusSalida,
    required this.salidaDetalles,
  });

  Salida copyWith({
    int? id,
    String? folio,
    String? nombre,
    DateTime? fechaSalida,
    TimeOfDay? horaSalida,
    String? nombreTransportista,
    String? placasTransporte,
    String? observaciones,
    StatusSalida? statusSalida,
    List<SalidaDetalle>? salidaDetalles,
  }) {
    return Salida(
      id: id ?? this.id,
      folio: folio ?? this.folio,
      nombre: nombre ?? this.nombre,
      fechaSalida: fechaSalida ?? this.fechaSalida,
      horaSalida: horaSalida ?? this.horaSalida,
      nombreTransportista: nombreTransportista ?? this.nombreTransportista,
      placasTransporte: placasTransporte ?? this.placasTransporte,
      observaciones: observaciones ?? this.observaciones,
      statusSalida: statusSalida ?? this.statusSalida,
      salidaDetalles: salidaDetalles ?? this.salidaDetalles,
    );
  }

}