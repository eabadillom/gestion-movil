import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/controller/controller.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class FileResponseDatasourceImpl extends FileResponseDatasource
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('FileResponseDatasourceImpl');
  final String accessToken;

  FileResponseDatasourceImpl({required this.accessToken});

  @override
  Future<FileResponse> getPosicionesPlantaPDF(DateTime fecha, String numUsuario, List<int>? idsSeleccionados) async
  {
    httpService.setAccessToken(accessToken);
    
    try{
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/ocupacion/reporte/$numUsuario';
      
      final response = await httpService.dio.get(url, queryParameters: {'fecha': FormatUtil.stringToISO(fecha), 'clientes': idsSeleccionados});

      FileResponse fileResponse = FileResponseMapper.jsonToEntity(response.data);
      
      return fileResponse;
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
