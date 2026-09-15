import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class PosicionesPlantaRepositoryImpl extends PosicionesPlantaRepository 
{
  final PosicionesPlantaDatasource datasource;

  PosicionesPlantaRepositoryImpl(this.datasource);  
  
  @override
  Future<Results<List<PosicionesPlanta>>> obtenerPosicionesPlanta(DateTime fecha,String numUsuario, List<int>? idsSeleccionados) async
  {
    try {
      final resultado = await datasource.obtenerPosicionesPlanta(fecha, numUsuario, idsSeleccionados);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
  
}
