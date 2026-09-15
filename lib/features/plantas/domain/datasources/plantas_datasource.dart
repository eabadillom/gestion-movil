import 'package:gestion_movil/features/plantas/domain/domain.dart';

abstract class PlantasDatasource 
{
  Future<List<Planta>> obtenerPlantas(String numUsuario);
}