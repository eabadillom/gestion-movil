import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ServicioMappers 
{
  static Servicio fromJson(Map<String, dynamic> json) 
  {
    return Servicio(
      id: json['id'] as int,
      descripcion: json['descripcion'] as String?,
      cantidad: _toDouble(json['cantidad']),
      precio: _toDouble(json['precio']),
      subtotal: _toDouble(json['subtotal']),
    );
  }

  static double? _toDouble(dynamic value) 
  {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

}
