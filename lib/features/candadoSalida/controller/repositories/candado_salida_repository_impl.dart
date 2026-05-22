import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';

class CandadoSalidaRepositoryImpl extends CandadoSalidaRepository
{
  final CandadoSalidaDatasource datasource;

  CandadoSalidaRepositoryImpl(this.datasource);
  
  @override
  Future<CandadoSalida> getCandadoSalida(int idCliente) {
    return datasource.getCandadoSalida(idCliente);
  }
  
  @override
  Future<CandadoSalida> guardarCandadoSalida(CandadoSalida candadoSalida) {
    return datasource.guardarCandadoSalida(candadoSalida);
  }

}
