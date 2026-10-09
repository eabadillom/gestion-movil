import 'package:gestion_movil/conf/config.dart';
import '../entities/controlmovil.dart';

abstract class CambiarContraseniaRepository {
  Future<Results<ControlMovil>> cambiarPalabra(String palabra);
}
