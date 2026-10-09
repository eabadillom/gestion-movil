import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ProductoMappers 
{
  static Producto fromJson(Map<String, dynamic> json) 
  {
    return Producto(
      id: json['id'] as int,
      descripcion: json['descripcion'] as String?,
      tarima: json['tarima'] as String?,
      piezas: json['piezas'] as int?,
      unidad: json['unidad'] as String?,
      cantidadCobro: _toDouble(json['cantidadCobro']),
      peso: _toDouble(json['peso']),
      folioEntrada: json['folioEntrada'] as String?,
      camara: json['camara'] as String?,
      origen: json['origen'] as String?,
      destino: json['destino'] as String?,
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
