import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';

abstract class PlantasRepository 
{
  Future<Results<List<Planta>>> obtenerPlantas(String numUsuario);
}