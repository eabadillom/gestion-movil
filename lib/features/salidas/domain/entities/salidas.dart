import 'package:flutter/material.dart';

class Salidas 
{
  int id;
  String folio;
  String nombre;
  DateTime fechaSalida;
  TimeOfDay horaSalida;

  Salidas({
    required this.id,
    required this.folio,
    required this.nombre,
    required this.fechaSalida,
    required this.horaSalida
  });

  Salidas copyWith({
    int? id,
    String? folio,
    String? nombre,
    DateTime? fechaSalida,
    TimeOfDay? horaSalida
  }) {
    return Salidas(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre, 
      folio: folio ?? this.folio, 
      fechaSalida: fechaSalida ?? this.fechaSalida, 
      horaSalida: horaSalida ?? this.horaSalida
    );
  }

}