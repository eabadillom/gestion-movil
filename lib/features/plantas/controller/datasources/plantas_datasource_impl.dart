import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';
import '../mappers/planta_mappers.dart';

class PlantasDatasourceImpl implements PlantasDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('PosicionesPlantaDatasourceImpl');
  final String accessToken;

  PlantasDatasourceImpl({required this.accessToken});

  @override
  Future<List<Planta>> obtenerPlantas(String numUsuario) async 
  {
    String contexto = Environment.obtenerUrlPorNombre('Movil');
    String url = '$contexto/plantas/$numUsuario';
    
    final response = await httpService.dio.get(url);
    
    List<Planta> listPlantas = [];
    for (var planta in response.data) {
      listPlantas.add(PlantaMappers.jsonToEntity(planta));
    }
    return listPlantas;
  }

}