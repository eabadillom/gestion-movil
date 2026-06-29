import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

abstract class FileResponseRepository 
{
  Future<Results<FileResponse>> getPosicionesPlantaPDF(DateTime fechaConsulta, String numUsuario, List<int>? idsSeleccionados);
}
