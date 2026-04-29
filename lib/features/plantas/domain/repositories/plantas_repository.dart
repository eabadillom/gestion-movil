import 'package:gestion_movil/features/plantas/domain/domain.dart';

abstract class PlantasRepository 
{
  Future<List<Planta>> obtenerPlantas(String numUsuario);
}