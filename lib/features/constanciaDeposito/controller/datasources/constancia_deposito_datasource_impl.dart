import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/controller/controller.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';

class ConstanciaDepositoDatasourceImpl extends ConstanciaDepositoDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  ConstanciaDepositoDatasourceImpl({required this.accessToken});
  
  @override
  Future<List<ConstanciaDeposito>> getListKardex(DateTime? fechaInicio, DateTime? fechaFin, int? cliente, int? planta, String? folioCliente) async
  {
    httpService.setAccessToken(accessToken);

    try {
      String fechaI = FormatUtil.stringToISO(fechaInicio!);
      String fechaF = FormatUtil.stringToISO(fechaFin!);
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/constancias/kardex';

      final response = await httpService.dio.get(url, queryParameters: {'fechaInicio': fechaI, 'fechaFin':fechaF, 'cliente': cliente, 'planta': planta, 'folioCliente': folioCliente});

      List<ConstanciaDeposito> listConstanciaDeposito = [];

      for(final constancia in response.data?? []) {
        listConstanciaDeposito.add(ConstanciaDepositoMapper.jsonToEntity(constancia));
      }

      return listConstanciaDeposito;
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
        throw GestionMovilException('No se encontró el kardex con el folio indicado.');
      }
      
      log.logger.warning('Error interno: $e');
      throw ServerException();
    }
  }

}
