import 'package:gestion_movil/features/plantas/domain/domain.dart';

class PlantasRepositoryImpl extends PlantasRepository
{
  final PlantasDatasource datasource;

  PlantasRepositoryImpl(this.datasource);

  @override
  Future<List<Planta>> obtenerPlantas(String numUsuario) async
  {
    return datasource.obtenerPlantas(numUsuario);
  }
}