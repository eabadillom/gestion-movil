import 'package:gestion_movil/features/login/domain/domain.dart';

class LoginUsuarioMapper 
{
  static LoginUsuario tokenJsonToEntity(Map<String,dynamic> json) => 
  LoginUsuario(
    numeroUsuario: json['numeroUsuario'],
    nombreUsuario: json['nombreUsuario'],
    primerApUsuario: json['primerApUsuario'],
    segundoApUsuario: json['segundoApUsuario'],
    puesto: json['puesto'],
    perfil: json['perfil'] as int,
    accessToken: json['token'],
    refreshToken: json['refreshToken']
  );
}
