import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class FileResponseRepositoryImpl extends FileResponseRepository
{
  final FileResponseDatasource datasource;

  FileResponseRepositoryImpl(this.datasource);

  @override
  Future<FileResponse> getPosicionesPlantaPDF(DateTime fechaConsulta, String numUsuario, List<int>? idsSeleccionados) 
  {
    return datasource.getPosicionesPlantaPDF(fechaConsulta, numUsuario, idsSeleccionados);
  }
}