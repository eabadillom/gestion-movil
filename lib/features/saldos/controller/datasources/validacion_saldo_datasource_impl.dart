import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/saldos/controller/controller.dart';
import 'package:gestion_movil/features/saldos/domain/domain.dart';

class ValidacionSaldoDatasourceImpl extends ValidacionSaldoDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('ValidacionSaldoDatasourceImpl');
  final String accessToken;

  ValidacionSaldoDatasourceImpl({required this.accessToken});
  
  @override
  Future<ValidacionSaldo> getValidacionSaldo(int idCliente, DateTime fecha) async
  {
    httpService.setAccessToken(accessToken);

    try{
      String contexto = Environment.obtenerUrlPorNombre('Movil');

      String url = '$contexto/saldo';

      final response = await httpService.dio.get(url, queryParameters: {'idCliente': idCliente, 'fecha': FormatUtil.stringToISO(fecha)});

      ValidacionSaldo validacionSaldo = ValidacionSaldoMappers.jsonToEntity(response.data);

      return validacionSaldo;
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
}