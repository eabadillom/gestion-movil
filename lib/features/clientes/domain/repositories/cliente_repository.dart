import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';

abstract class ClienteRepository 
{
  Future<Results<List<Cliente>>> getListClientes();
}