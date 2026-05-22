import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/saldos/controller/controller.dart';
import 'package:gestion_movil/features/saldos/domain/domain.dart';

class ValidacionSaldoDatasourceImpl extends ValidacionSaldoDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('ValidacionSaldoDatasourceImpl');
  final String accessToken;

  ValidacionSaldoDatasourceImpl({required this.accessToken});
  
  @override
  Future<ValidacionSaldo> getValidacionSaldo(int idCliente, DateTime fecha) async
  {
    httpService.setAccessToken(accessToken);

    try{
      String contexto = Environment.obtenerUrlPorNombre('Movil');

      String url = '$contexto/saldo';

      final response = await httpService.dio.get(url, queryParameters: {'idCliente': idCliente, 'fecha': FormatUtil.stringToISO(fecha)});

      ValidacionSaldo validacionSaldo = ValidacionSaldoMappers.jsonToEntity(response.data);

      return validacionSaldo;
    } catch (e) {
      log.logger.warning(e.toString());
      throw ValidacionSaldoErrors('Hubo algun problema al obtener la informacion');
    }
  }
}