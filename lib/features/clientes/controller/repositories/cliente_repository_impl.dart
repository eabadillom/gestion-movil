import 'package:gestion_movil/features/clientes/domain/domain.dart';

class ClienteRepositoryImpl implements ClienteRepository 
{
  final ClienteDatasource datasource;

  ClienteRepositoryImpl(this.datasource);

  @override
  Future<List<Cliente>> getListClientes()  
  {
    return datasource.getListClientes();
  }
  
}