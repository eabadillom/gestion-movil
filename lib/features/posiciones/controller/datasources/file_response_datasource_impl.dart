import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/controller/controller.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class FileResponseDatasourceImpl extends FileResponseDatasource
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('PosicionesPlantaDatasourceImpl');
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
    } catch (e) {
      log.logger.warning(e.toString());
      throw PosicionesPlantaErrors('Hubo algun problema al obtener la informacion');
      //throw Exception();
    }
  }

}
