import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/camaras/controller/controller.dart';
import 'package:gestion_movil/features/camaras/domain/domain.dart';

class CamaraDatasourceImpl extends CamaraDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('CamaraDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  CamaraDatasourceImpl({required this.accessToken});
  
  @override
  Future<List<Camara>> getListCamaras(int? idPlanta) async 
  {
    httpService.setAccessToken(accessToken);
    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/camaras';

      final response = await httpService.dio.get(url, queryParameters: {'idPlanta': idPlanta});

      List<Camara> listCamaras = [];

      for(final camara in response.data?? []) {
        listCamaras.add(CamaraMapper.jsonToEntity(camara));
      }

      return listCamaras;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
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
