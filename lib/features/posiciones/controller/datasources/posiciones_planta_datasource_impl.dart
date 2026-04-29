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
    } catch (e) {
      log.logger.warning(e.toString());
      throw PosicionesPlantaErrors('Hubo algun problema al obtener la informacion');
      //throw Exception();
    }
  }

}