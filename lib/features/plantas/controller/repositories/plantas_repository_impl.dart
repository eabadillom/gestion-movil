import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';

class PlantasRepositoryImpl extends PlantasRepository
{
  final PlantasDatasource datasource;

  PlantasRepositoryImpl(this.datasource);

  @override
  Future<Results<List<Planta>>> obtenerPlantas(String numUsuario) async
  {
    try {
      final resultado = await datasource.obtenerPlantas(numUsuario);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
}