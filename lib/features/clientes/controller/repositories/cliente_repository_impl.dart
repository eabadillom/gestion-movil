import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';

class ClienteRepositoryImpl implements ClienteRepository 
{
  final ClienteDatasource datasource;

  ClienteRepositoryImpl(this.datasource);

  @override
  Future<Results<List<Cliente>>> getListClientes() async 
  {
    try {
      final resultado = await datasource.getListClientes();
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
  
}