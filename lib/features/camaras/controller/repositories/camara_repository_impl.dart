import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/camaras/domain/domain.dart';

class CamaraRepositoryImpl extends CamaraRepository
{
  final CamaraDatasource datasource;

  CamaraRepositoryImpl(this.datasource);
  
  @override
  Future<Results<List<Camara>>> getListCamaras(int? idPlanta) async
  {
    try {
      final resultado = await datasource.getListCamaras(idPlanta);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
  
}
