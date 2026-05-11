import 'package:gestion_movil/features/camaras/domain/domain.dart';

class CamaraMapper 
{
  static Camara jsonToEntity(Map<String, dynamic> json) => Camara(
    id: json['id'] as int,
    descripcion: json['descripcion']     
  );
}
