import '../../domain/entities/controlmovil.dart';

class ControlMovilMapper {
  static ControlMovil jsonToEntity(Map<String, dynamic> json) => ControlMovil(
    id: json['id'],
    token: json['token'],
    expiracion: DateTime.parse(json['expiracion']),
    sistema: json['sistema'],
    valido: json['valido'],
  );
}
