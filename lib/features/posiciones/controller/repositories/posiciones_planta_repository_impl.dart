import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class PosicionesPlantaRepositoryImpl extends PosicionesPlantaRepository 
{
  final PosicionesPlantaDatasource datasource;

  PosicionesPlantaRepositoryImpl(this.datasource);  
  
  @override
  Future<List<PosicionesPlanta>> obtenerPosicionesPlanta(DateTime fecha,String numUsuario, List<int>? idsSeleccionados) 
  {
    return datasource.obtenerPosicionesPlanta(fecha, numUsuario, idsSeleccionados);
  }
  
}
