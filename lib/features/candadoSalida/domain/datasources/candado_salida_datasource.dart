import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';

abstract class CandadoSalidaDatasource 
{
  Future<CandadoSalida> getCandadoSalida(int idCliente);
  Future<CandadoSalida> guardarCandadoSalida(CandadoSalida candadoSalida);
}
