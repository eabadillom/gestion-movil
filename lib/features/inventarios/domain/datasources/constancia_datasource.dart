import 'package:gestion_movil/features/inventarios/domain/domain.dart';

abstract class ConstanciaDatasource 
{
  Future<List<ConstanciaDTO>> listarConstancias(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente);
}
