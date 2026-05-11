import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constancia_deposito/controller/controller.dart';
import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class PdfDatasourceImpl extends PdfDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('PosicionesPlantaDatasourceImpl');
  final String accessToken;

  PdfDatasourceImpl({required this.accessToken});
  
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
    }
  }
  
  @override
  Future<FileResponse> getEntradaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) async
  {
    httpService.setAccessToken(accessToken);

    try{
      String fechaI = FormatUtil.stringToISO(fechaInicio);
      String fechaF = FormatUtil.stringToISO(fechaFin);

      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/reporte/entrada/$fechaI/$fechaF';

      final response = await httpService.dio.get(url, queryParameters: {'cliente': cliente, 'planta': planta, 'camara': camara});
      FileResponse fileResponse = FileResponseMapper.jsonToEntity(response.data);

      return fileResponse;
    } catch (e) {
      log.logger.warning(e.toString());
      throw FileResponseErrors('Hubo algun problema al obtener la informacion');
    }
  }
  
  @override
  Future<FileResponse> getSalidaPDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) async
  {
    httpService.setAccessToken(accessToken);

    try{
      String fechaI = FormatUtil.stringToISO(fechaInicio);
      String fechaF = FormatUtil.stringToISO(fechaFin);

      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/reporte/salida/$fechaI/$fechaF';

      final response = await httpService.dio.get(url, queryParameters: {'cliente': cliente, 'planta': planta, 'camara': camara});
      FileResponse fileResponse = FileResponseMapper.jsonToEntity(response.data);

      return fileResponse;
    } catch (e) {
      log.logger.warning(e.toString());
      throw FileResponseErrors('Hubo algun problema al obtener la informacion');
    }
  }
  
  @override
  Future<FileResponse> getInventarioPDF(DateTime fecha, int? cliente, int? planta) async
  {
    httpService.setAccessToken(accessToken);
    try{
      String fechaHoy = FormatUtil.stringToISO(fecha);

      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/reporte/inventario/$fechaHoy';

      final response = await httpService.dio.get(url, queryParameters: {'cliente': cliente, 'planta': planta});
      FileResponse fileResponse = FileResponseMapper.jsonToEntity(response.data);

      return fileResponse;
    } catch (e) {
      log.logger.warning(e.toString());
      throw FileResponseErrors('Hubo algun problema al obtener la informacion');
    }
  }
  
}