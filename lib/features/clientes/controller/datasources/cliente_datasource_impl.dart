import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/controller/controller.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';

class ClienteDatasourceImpl implements ClienteDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  ClienteDatasourceImpl({required this.accessToken});
  
  @override
  Future<List<Cliente>> getListClientes() async
  {
    httpService.setAccessToken(accessToken);
    
    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/clientes';

      final response = await httpService.dio.get<List>(url);

      final List<Cliente> clientes = [];
      
      for (final cliente in response.data!) {
        clientes.add(ClienteMapper.jsonToEntity(cliente));
      }

      return clientes;
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