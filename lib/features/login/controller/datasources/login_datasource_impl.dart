import 'dart:async';
import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/login/controller/controller.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

class LoginDatasourceImpl extends LoginDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('LoginDatasourceImpl');

  @override
  Future<int> checkTokenStatus(String token) async 
  {
    log.setupLoggin();
    final int status;
    try {
      httpService.setAccessToken(token);
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/verificar';
      final response = await httpService.dio.get(url);

      if (response.statusCode == 200) {
        log.logger.info('Token con salud');
        status = 200;
      } else {
        log.logger.info('Token expirado');
        status = -1;
      }

      //Token tokenOb = TokenMapper.tokenJsonToEntity(response.data);
      //log.logger.info('Token: $tokenOb');
      return status;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        log.logger.warning('Error de conexión: $e');
        throw ConnectionTimeoutException();
      }

      if (e.type == DioExceptionType.unknown) {
        log.logger.warning('Error desconocido: $e');
        throw NetworkException();
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Token invalido: $e');
        throw InvalidTokenException();
      }

      if (e.response?.statusCode == 403) {
        log.logger.warning('Credenciales incorrectas: $e');
        throw WrongCredentialsException();
      }
      
      log.logger.warning('Error interno del servidor: $e');
      throw ServerException();
    } 

  }

  @override
  Future<LoginUsuario> login(String numeroEmpleado, String nombre, String contrasenia) async 
  {
    log.setupLoggin();
    try {
      httpService.setBasicAuth(nombre, contrasenia);
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/generar';
      final response = await httpService.dio.request(
        url,
        data: {'numeroUsuario': numeroEmpleado},
        options: Options(method: 'GET'),
      );

      LoginUsuario loginUsuario = LoginUsuarioMapper.tokenJsonToEntity(response.data);

      return loginUsuario;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        log.logger.warning('Error de conexión: $e');
        throw ConnectionTimeoutException();
      }

      if (e.type == DioExceptionType.unknown) {
        log.logger.warning('Error general: $e');
        throw NetworkException();
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Token invalido: $e');
        throw InvalidTokenException();
      }

      if (e.response?.statusCode == 403) {
        log.logger.warning('Credenciales incorrectas: $e');
        throw WrongCredentialsException();
      }
      
      log.logger.warning('Error interno: $e');
      throw ServerException();
    } 

  }

  @override
  Future<String> deshabilitar(String token) async
  {
    log.setupLoggin();
    try{
      httpService.setAccessToken(token);
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/deshabilitar';
      String method = 'GET';

      final response = await httpService.dio.request(url, options: Options(method: method));

      if (response.statusCode == 200) {
        log.logger.info('Respuesta ${response.data}');
        return 'Has cerrado sesión correctamente';
      } else {
        log.logger.warning('Logout fallido: ${response.data}');
        return 'Fallo al cerrar sesión';
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw ConnectionTimeoutException();
      }

      if (e.type == DioExceptionType.unknown) {
        throw NetworkException();
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Token invalido: $e');
        throw InvalidTokenException();
      }

      if (e.response?.statusCode == 403) {
        log.logger.warning('Credenciales incorrectas: $e');
        throw WrongCredentialsException();
      }
      
      log.logger.warning('Error interno: $e');
      throw ServerException();
    } 
    
  }

}
