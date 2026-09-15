import 'package:gestion_movil/features/salidas/domain/domain.dart';

abstract class SalidasDatasource 
{
  Future<List<Salidas>> getSalidas(int? idCliente, DateTime fechaInicio, DateTime fechaFin);
  Future<Salida> getDetalleSalida(int idSalida);
  Future<void> cancelarSalida(int idSalida);
}