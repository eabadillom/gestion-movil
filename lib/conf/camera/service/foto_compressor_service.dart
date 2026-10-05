import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gestion_movil/conf/camera/camera.dart';

class FotoCompressor 
{
  const FotoCompressor();

  Future<List<FotoAdjunta>> comprimirTodas({required List<FotoAdjunta> fotos, required FotosConfig config, void Function(int actual, int total)? onProgress}) async 
  {
    final List<FotoAdjunta> resultado = [];

    for (int i = 0; i < fotos.length; i++) 
    {
      final FotoAdjunta foto = fotos[i];

      final FotoAdjunta? comprimida = await comprimir(foto, config);

      if (comprimida != null) {
        resultado.add(comprimida);
      }

      onProgress?.call(i + 1, fotos.length);
    }

    return resultado;
  }

  Future<FotoAdjunta?> comprimir(FotoAdjunta foto, FotosConfig config) async 
  {
    try {
      final String path = foto.archivo.path;

      final List<int>? bytes = await FlutterImageCompress.compressWithFile(
        path,
        minWidth: config.maxWidth,
        minHeight: config.maxHeight,
        quality: config.calidad,
        format: CompressFormat.jpeg,
      );

      if (bytes == null) {
        return null;
      }

      final File archivoComprimido = File('$path.jpg');

      await archivoComprimido.writeAsBytes(bytes);

      return foto.copyWith(
        archivo: archivoComprimido,
        nombre: _nombreComprimido(foto.nombre),
      );
    } catch (e, stackTrace) {
      debugPrint('Error comprimiendo fotografía: $e');

      debugPrintStack(stackTrace: stackTrace);

      return null;
    }
  }

  String _nombreComprimido(String nombre) 
  {
    final int punto = nombre.lastIndexOf('.');

    if (punto == -1) {
      return '${nombre}_compressed.jpg';
    }

    return '${nombre.substring(0, punto)}.jpg';
  }
}
