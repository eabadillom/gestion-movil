import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

abstract class ConstanciaDatasource 
{
  Future<List<Constancia>> listarConstancias(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente);
  Future<ConstanciaDetalle> obtenerConstanciaDetalle(TipoConstancia tipo, int id);
  Future<RespuestaResponse> enviarEvidencia(TipoConstancia tipo, int idConstancia, List<FotoEnvio> fotos);
}
