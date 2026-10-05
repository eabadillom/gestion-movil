import 'dart:io';

class FotoAdjunta 
{
  final File archivo;
  final String nombre;

  FotoAdjunta({
    required this.archivo,
    required this.nombre,
  });

  FotoAdjunta copyWith({
    File? archivo,
    String? nombre,
  }) {
    return FotoAdjunta(
      archivo: archivo ?? this.archivo,
      nombre: nombre ?? this.nombre,
    );
  }
  
}
