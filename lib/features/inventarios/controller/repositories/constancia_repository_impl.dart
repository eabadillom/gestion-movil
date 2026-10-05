import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaRepositoryImpl extends ConstanciaRepository
{
  final ConstanciaDatasource datasource;

  ConstanciaRepositoryImpl(this.datasource);

  @override
  Future<Results<List<ConstanciaDTO>>> listarConstancias(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente) async
  {
    try {
      final resultado = await datasource.listarConstancias(tipo, inicio, fin, idCliente, folioCliente);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

}
