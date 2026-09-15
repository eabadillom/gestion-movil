import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class FileResponseRepositoryImpl extends FileResponseRepository
{
  final FileResponseDatasource datasource;

  FileResponseRepositoryImpl(this.datasource);

  @override
  Future<Results<FileResponse>> getPosicionesPlantaPDF(DateTime fechaConsulta, String numUsuario, List<int>? idsSeleccionados) async
  {
    try {
      final resultado = await datasource.getPosicionesPlantaPDF(fechaConsulta, numUsuario, idsSeleccionados);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
}