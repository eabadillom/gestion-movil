import 'dart:io';
import 'foto_adjunta.dart';

class FotoAdjuntaFactory 
{
  static FotoAdjunta crear(File archivo) 
  {
    return FotoAdjunta(
      archivo: archivo,
      nombre: archivo.path.split(Platform.pathSeparator).last,
    );
  }
  
}
