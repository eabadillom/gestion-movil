import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';

abstract class CandadoSalidaRepository
{
  Future<Results<CandadoSalida>> getCandadoSalida(int idCliente);
  Future<Results<CandadoSalida>> guardarCandadoSalida(CandadoSalida candadoSalida);
}
