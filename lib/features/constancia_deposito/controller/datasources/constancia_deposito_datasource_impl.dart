import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constancia_deposito/controller/controller.dart';
import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

class ConstanciaDepositoDatasourceImpl extends ConstanciaDepositoDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  ConstanciaDepositoDatasourceImpl({required this.accessToken});
  
  @override
  Future<List<ConstanciaDeposito>> getListConstanciaDeposito(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta) async
  {
    httpService.setAccessToken(accessToken);

    try {
      String fechaI = FormatUtil.stringToISO(fechaInicio);
      String fechaF = FormatUtil.stringToISO(fechaFin);
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/constancias/$fechaI/$fechaF';

      final response = await httpService.dio.get(url, queryParameters: {'cliente': cliente, 'planta': planta});

      List<ConstanciaDeposito> listConstanciaDeposito = [];

      for(final constancia in response.data?? []) {
        listConstanciaDeposito.add(ConstanciaDepositoMapper.jsonToEntity(constancia));
      }

      return listConstanciaDeposito;
    } catch (e) {
      log.logger.warning(e.toString());
      throw ConstanciaDepositoErrors("Hubo algun problema al obtener la informacion");
    }
  }

}