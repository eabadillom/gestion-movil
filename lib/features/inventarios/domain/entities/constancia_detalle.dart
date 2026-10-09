import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaDetalle extends Constancia 
{
  final String? observaciones;
  final String? nombreTransportista;
  final String? placasTransporte;
  final String? temperatura;
  final List<Producto> productos;
  final List<Servicio> servicios;

  ConstanciaDetalle({
    required super.id,
    super.folioCliente,
    super.fecha,
    super.nombre,
    this.observaciones,
    this.nombreTransportista,
    this.placasTransporte,
    this.temperatura,
    this.productos = const [],
    this.servicios = const [],
  });

}
