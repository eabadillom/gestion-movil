import '../entities/controlmovil.dart';

abstract class CambiarContraseniaDatasource {
  Future<ControlMovil> cambiarPalabra(String palabra);
}
