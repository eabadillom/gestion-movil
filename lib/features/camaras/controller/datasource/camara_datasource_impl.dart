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
    } catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

}
