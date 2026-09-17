import 'package:gestion_movil/features/salidas/domain/domain.dart';

class StatusSalidaMapper
{
  static StatusSalida jsonToEntity(Map<String, dynamic> json) => StatusSalida
  (
    id: json["id"],
    descripcion: json["descripcion"],
  );

  static Map<String, dynamic> toJson(StatusSalida statusSalida) => 
  {
    "id": statusSalida.id,
    "descripcion": statusSalida.descripcion,
  };
  
}