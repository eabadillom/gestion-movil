import '../entities/cliente.dart';

abstract class ClienteRepository 
{
  Future<List<Cliente>> getListClientes();
}