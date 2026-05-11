import 'package:gestion_movil/features/login/domain/entities/usuario_detalle.dart';

class UsuarioDetalleMapper
{
  static UsuarioDetalle tokenJsonToEntity(Map<String,dynamic> json) => 
  UsuarioDetalle(
    numeroUsuario: json['numeroUsuario'],
    nombreUsuario: json['nombreUsuario'],
    primerApUsuario: json['primerApUsuario'],
    segundoApUsuario: json['segundoApUsuario'],
    puesto: json['puesto'],
    perfil: json['perfil'] as int,
  );
}