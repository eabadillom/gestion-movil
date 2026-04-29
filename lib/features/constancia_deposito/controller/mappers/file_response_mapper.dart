import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class FileResponseMapper 
{
  static FileResponse jsonToEntity(Map<String, dynamic> json) => FileResponse(
    fileName: json['fileName'] as String,
    base64Content: json['base64Content'] as String,
    contentType: json['contentType'] as String,
  );
}