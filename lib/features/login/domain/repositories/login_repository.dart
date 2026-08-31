import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

abstract class LoginRepository 
{
  Future<Results<LoginUsuario>> login(String numeroEmpleado, String nombre, String contrasenia);
  Future<Results<int>> checkTokenStatus(String token);
  Future<Results<String>> deshabilitar(String token);
}