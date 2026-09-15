import 'package:gestion_movil/features/posiciones/domain/domain.dart';

abstract class FileResponseDatasource 
{
  Future<FileResponse> getPosicionesPlantaPDF(DateTime fechaConsulta, String numUsuario, List<int>? idsSeleccionados);
}
