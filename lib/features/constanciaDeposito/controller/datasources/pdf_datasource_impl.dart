import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/controller/controller.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';

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
