import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

abstract class PosicionesPlantaRepository 
{
  Future<Results<List<PosicionesPlanta>>> obtenerPosicionesPlanta(DateTime fecha, String numUsuario, List<int>? idsSeleccionados);
}