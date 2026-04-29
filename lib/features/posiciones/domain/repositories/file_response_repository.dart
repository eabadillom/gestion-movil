import 'package:gestion_movil/features/posiciones/domain/domain.dart';

abstract class FileResponseRepository 
{
  Future<FileResponse> getPosicionesPlantaPDF(DateTime fechaConsulta, String numUsuario, List<int>? idsSeleccionados);
}
