import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constancia_deposito/controller/controller.dart';
import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class KardexPdfDatasourceImpl extends KardexPdfDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('PosicionesPlantaDatasourceImpl');
  final String accessToken;

  KardexPdfDatasourceImpl({required this.accessToken});
  
  @override
  Future<FileResponse> getKardexPDF(String folioCliente) async
  {
    httpService.setAccessToken(accessToken);

    try{
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/reporte/kardex/$folioCliente';

      final response = await httpService.dio.get(url);
      FileResponse fileResponse = FileResponseMapper.jsonToEntity(response.data);

      return fileResponse;
    } catch (e) {
      log.logger.warning(e.toString());
      throw FileResponseErrors('Hubo algun problema al obtener la informacion');
      //throw Exception();
    }
  }
  
}