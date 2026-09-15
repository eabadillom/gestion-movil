import 'package:gestion_movil/features/posiciones/domain/domain.dart';

abstract class PosicionesPlantaDatasource 
{
  Future<List<PosicionesPlanta>> obtenerPosicionesPlanta(DateTime fecha, String numUsuario, List<int>? idsSeleccionados);
}