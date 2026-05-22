import 'package:dio/dio.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/candadoSalida/controller/errors/candado_salida_errors.dart' show CandadoSalidaErrors;
import 'package:gestion_movil/features/candadoSalida/controller/mappers/candado_salida_mappers.dart';
import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';

class CandadoSalidaDatasourceImpl extends CandadoSalidaDatasource
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('CandadoSalidaDatasourceImpl');
  final String accessToken;

  CandadoSalidaDatasourceImpl({required this.accessToken});
  
  @override
  Future<CandadoSalida> getCandadoSalida(int idCliente) async
  {
    httpService.setAccessToken(accessToken);

    try
    {
      String contexto = Environment.obtenerUrlPorNombre('Movil');

      String url = '$contexto/candadoSalida/$idCliente';

      final response = await httpService.dio.get(url);

      CandadoSalida candadoSalida = CandadoSalidaMappers.jsonToEntity(response.data);

      return candadoSalida;
    } catch (e) {
      log.logger.warning(e.toString());
      throw CandadoSalidaErrors('Hubo algun problema al obtener la informacion');
    }
  }
  
  @override
  Future<CandadoSalida> guardarCandadoSalida(CandadoSalida candadoSalida) async 
  {
    httpService.setAccessToken(accessToken);

    try
    {
      final String method = 'PATCH';
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/candadoSalida/${candadoSalida.id}';

      Map<String, dynamic> candadoActualizar = CandadoSalidaMappers.toJson(candadoSalida);

      final response = await httpService.dio.request(url, data: candadoActualizar, options: Options(method: method));

      final candado = CandadoSalidaMappers.jsonToEntity(response.data);
      return candado;
    } catch (e) {
      log.logger.warning(e.toString());
      throw CandadoSalidaErrors('Hubo algun problema al obtener la informacion');
    }
  }

}
