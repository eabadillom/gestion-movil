import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/controller/controller.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaDatasourceImpl extends ConstanciaDatasource
{
  final LoggerSingleton log = LoggerSingleton.getInstance('ConstanciaDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  ConstanciaDatasourceImpl({required this.accessToken});

  @override
  Future<List<ConstanciaDTO>> listarConstancias(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente) async
  {
    httpService.setAccessToken(accessToken);

    try {
      String fechaI = FormatUtil.stringToISO(inicio);
      String fechaF = FormatUtil.stringToISO(fin);
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/constancia/listar/${tipo.api}';

      final response = await httpService.dio.get(url, queryParameters: {'fechaInicio': fechaI, 'fechaFin':fechaF, 'idCliente': idCliente, 'folioCliente': folioCliente});

      List<ConstanciaDTO> listConstancias = [];

      for(final constancia in response.data?? []) {
        listConstancias.add(ConstanciaMappers.jsonToEntity(constancia));
      }

      return listConstancias;
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

      if (e.response?.statusCode == 404) {
        log.logger.warning(e.message);
        throw GestionMovilException(e.message!);
      }
      
      log.logger.warning('Error interno: $e');
      throw ServerException();
    }
  }
  
}
