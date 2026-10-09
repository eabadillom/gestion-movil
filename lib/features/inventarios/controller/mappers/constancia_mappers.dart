import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaMappers 
{
  static Constancia jsonToEntity(Map<String, dynamic> json) => Constancia(
    id: json['id'] as int, 
    folioCliente: json['folioCliente'], 
    fecha: DateTime.parse(json['fecha']), 
    nombre: json['nombre'],
  );

  static Map<String, dynamic> toJson(Constancia entity) => 
  {
    "id" : entity.id,
    "folioCliente" : entity.folioCliente,
    "fecha" : entity.fecha,
    "nombre" : entity.nombre,
  };

}
