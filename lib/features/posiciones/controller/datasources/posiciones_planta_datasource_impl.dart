import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/controller/controller.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class PosicionesPlantaDatasourceImpl extends PosicionesPlantaDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('PosicionesPlantaDatasourceImpl');
  final String accessToken;

  PosicionesPlantaDatasourceImpl({required this.accessToken});

  @override
  Future<List<PosicionesPlanta>> obtenerPosicionesPlanta(DateTime fecha, String numUsuario, List<int>? idsSeleccionados) async
  {
    httpService.setAccessToken(accessToken);
    
    try{
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/ocupacion/planta/$numUsuario';
      
      final response = await httpService.dio.get(url, queryParameters: {'fecha': FormatUtil.stringToISO(fecha), 'clientes': idsSeleccionados});

      List<PosicionesPlanta> listPosiciones = [];

      for(final posiciones in response.data?? []) {
        listPosiciones.add(PosicionesPlantaMapper.jsonToEntity(posiciones));
      }

      return listPosiciones;
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