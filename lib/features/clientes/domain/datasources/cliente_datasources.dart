import '../entities/cliente.dart';

abstract class ClienteDatasource 
{
  Future<List<Cliente>> getListClientes();
}