import '../../domain/domain.dart';

class ClienteMapper 
{
  static Cliente jsonToEntity(Map<String, dynamic> json) 
  {
    return Cliente(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
    );
  }
}