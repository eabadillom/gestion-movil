import 'package:gestion_movil/features/salidas/domain/entities/salida_detalle.dart';

class SalidaDetalleMapper 
{
  static SalidaDetalle jsonToEntity(Map<String, dynamic> json) => SalidaDetalle
  (
    id: json["id"],
    descripcion: json["descripcion"],
    cantidad: json["cantidad"],
    peso: (json["peso"] as num).toDouble(),
  );

  static Map<String, dynamic> toJson(SalidaDetalle salidaDetalle) => {
    "id": salidaDetalle.id,
    "descripcion": salidaDetalle.descripcion,
    "cantidad": salidaDetalle.cantidad,
    "peso": salidaDetalle.peso,
  };

}