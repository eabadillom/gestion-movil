import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/salidas/controller/controller.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';

class SalidasDatasourceImpl extends SalidasDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('SalidasDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  SalidasDatasourceImpl({required this.accessToken});

  @override
  Future<List<Salidas>> getSalidas(int? idCliente, DateTime fechaInicio, DateTime fechaFin) async
  {
    httpService.setAccessToken(accessToken);

    try {
      String fechaI = FormatUtil.stringToISO(fechaInicio);
      String fechaF = FormatUtil.stringToISO(fechaFin);
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/salidas';

      final response = await httpService.dio.get(url, queryParameters: {'fechaInicio': fechaI, 'fechaFin': fechaF, 'idCliente': idCliente});

      List<Salidas> listSalidas = [];

      for(final salida in response.data?? []) {
        listSalidas.add(SalidasMapper.jsonToEntity(salida));
      }

      return listSalidas;
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
      
      log.logger.warning('Error interno: $e');
      throw ServerException();
    }
  }

  @override
  Future<Salida> getDetalleSalida(int idSalida) async
  {
    httpService.setAccessToken(accessToken);

    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/salida';

      final response = await httpService.dio.get(url, queryParameters: {'idSalida': idSalida});

      Salida salida = SalidaMapper.jsonToEntity(response.data);

      return salida;
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
      
      log.logger.warning('Error interno: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> cancelarSalida(int idSalida) async
  {
    httpService.setAccessToken(accessToken);
    
    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/salida/$idSalida/cancelar';

      await httpService.dio.patch(url);
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

      if (e.response?.statusCode == 409) {
        final message = e.response?.data['message'] ?? 'La salida no puede ser cancelada.';

        throw GestionMovilException(message);
      }
      
      log.logger.warning('Error interno: $e');
      throw ServerException();
    }
  }
  
}