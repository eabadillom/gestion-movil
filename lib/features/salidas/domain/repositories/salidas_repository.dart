import 'package:gestion_movil/conf/errors/results.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';

abstract class SalidasRepository 
{
  Future<Results<List<Salidas>>> getSalidas(int? idCliente, DateTime fechaInicio, DateTime fechaFin);
  Future<Results<Salida>> getDetalleSalida(int idSalida);
  Future<Results<void>> candelarSalida(int idSalida);
}
