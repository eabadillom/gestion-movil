import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/constants/environment.dart';
import 'package:gestion_movil/features/cambiarcontrasenia/domain/domain.dart';

import '../../../../conf/errors/custom_exception.dart';
import '../../../../conf/loggers/logger_singleton.dart';
import '../../../../conf/security/dio_client.dart';

class CambiarContraseniaDatasourceImpl extends CambiarContraseniaDatasource {
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'CambiarContraseniaDatasourceImpl',
  );
  final String accessToken;

  CambiarContraseniaDatasourceImpl({required this.accessToken});

  @override
  Future<ControlMovil> cambiarPalabra(String palabra) async {
    log.setupLoggin();

    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/dispositivos/cambiarPassword';

      final response = await httpService.dio.post(url);

      ControlMovil controlMovil = response.data;

      return controlMovil;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
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

      log.logger.warning('Error interno: $e');
      throw ServerException();
    }
  }
}
