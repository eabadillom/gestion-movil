import 'package:gestion_movil/features/inventarios/controller/controller.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaDetalleMappers 
{
  static ConstanciaDetalle detalleFromJson(Map<String, dynamic> json) 
  {
    return ConstanciaDetalle(
      id: json['id'] as int,
      folioCliente: json['folioCliente'] as String?,
      fecha: _parseFecha(json['fecha']),
      nombre: json['nombre'] as String?,

      observaciones: json['observaciones'] as String?,
      nombreTransportista: json['nombreTransportista'] as String?,
      placasTransporte: json['placasTransporte'] as String?,
      temperatura: json['temperatura'] as String?,

      productos: _mapProductos(json['productos']),
      servicios: _mapServicios(json['servicios']),
    );
  }

  static List<Producto> _mapProductos(dynamic value) 
  {
    if (value == null || value is! List) {
      return [];
    }

    return value.whereType<Map<String, dynamic>>().map(ProductoMappers.fromJson).toList();
  }

  static List<Servicio> _mapServicios(dynamic value) 
  {
    if (value == null || value is! List) {
      return [];
    }

    return value.whereType<Map<String, dynamic>>().map(ServicioMappers.fromJson).toList();
  }

  static DateTime? _parseFecha(dynamic value) 
  {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }
  
}
