import 'package:gestion_movil/conf/config.dart';
import '../../domain/domain.dart';
import '../mappers/cliente_mapper.dart';

class ClienteDatasourceImpl implements ClienteDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  ClienteDatasourceImpl({required this.accessToken});
  
  @override
  Future<List<Cliente>> getListClientes() async
  {
    httpService.setAccessToken(accessToken);
    
    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/clientes';

      final response = await httpService.dio.get<List>(url);

      final List<Cliente> clientes = [];
      
      for (final cliente in response.data!) {
        clientes.add(ClienteMapper.jsonToEntity(cliente));
      }

      return clientes;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

}