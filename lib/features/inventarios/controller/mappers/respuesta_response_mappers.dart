import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class RespuestaResponseMappers 
{
  static RespuestaResponse fromJson(Map<String, dynamic> json) 
  {
    return RespuestaResponse(
      respuesta: json['mensaje'] as String, 
      exito: json['exito'] as bool
    );
  }
  
}
