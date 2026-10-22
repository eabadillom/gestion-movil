import 'package:gestion_movil/conf/camera/camera.dart';

class FotosTamanoService 
{
  const FotosTamanoService();

  static const int limiteCorreoBytes = 25 * 1024 * 1024;

  Future<int> calcularTamanoFotos(List<FotoAdjunta> fotos) async 
  {
    int total = 0;

    for (final foto in fotos) {
      total += await foto.archivo.length();
    }

    return total;
  }

  int estimarTamanoBase64(int bytes) 
  {
    return ((bytes * 4) / 3).ceil();
  }
  
}
