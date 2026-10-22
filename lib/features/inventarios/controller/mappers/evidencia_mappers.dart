import 'package:gestion_movil/conf/config.dart';

class EvidenciaMappers 
{
  static Map<String, dynamic> toJson(FotoEnvio fotoEnvio) => 
  {
    "nombre": fotoEnvio.nombre,
    "mimeType": fotoEnvio.mimeType,
    "base64": fotoEnvio.base64,
  };
  
}