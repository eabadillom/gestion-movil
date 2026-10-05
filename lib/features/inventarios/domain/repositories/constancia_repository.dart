import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

abstract class ConstanciaRepository 
{
  Future<Results<List<ConstanciaDTO>>> listarConstancias(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente);
}
