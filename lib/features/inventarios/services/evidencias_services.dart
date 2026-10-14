import 'dart:convert';
import 'dart:io';
import 'package:gestion_movil/conf/config.dart';
import 'package:mime/mime.dart';

class EvidenciasServices 
{
  final CameraService _cameraService;
  final FotoCompressor _fotoCompressor;

  const EvidenciasServices({required CameraService cameraService, required FotoCompressor fotoCompressor})  : _cameraService = cameraService, _fotoCompressor = fotoCompressor;

  static const FotosConfig config = FotosConfig(maxWidth: 1920, maxHeight: 1080, calidad: 80);

  Future<FotoAdjunta?> tomarFoto() async 
  {
    final File? archivo = await _cameraService.tomarFoto();

    if (archivo == null) {
      return null;
    }

    return FotoAdjuntaFactory.crear(archivo);
  }

  Future<FotoAdjunta?> seleccionarDeGaleria() async 
  {
    final File? archivo = await _cameraService.seleccionarDeGaleria();

    if (archivo == null) {
      return null;
    }

    return FotoAdjuntaFactory.crear(archivo);
  }

  Future<FotoAdjunta?> comprimirFotos(FotoAdjunta foto) async 
  {
    return _fotoCompressor.comprimir(foto, config);
  }

  Future<List<FotoEnvio>> prepararFotosParaCorreo(List<FotoAdjunta> fotos) async 
  {
    final List<FotoEnvio> resultado = [];

    for (final FotoAdjunta foto in fotos) 
    {
      final bytes = await foto.archivo.readAsBytes();

      resultado.add(
        FotoEnvio(
          nombre: foto.nombre,
          mimeType: lookupMimeType(foto.archivo.path) ?? 'application/octet-stream',
          base64: base64Encode(bytes),
        )
      );
    }

    return resultado;
  }

  Future<List<FotoEnvio>> prepararFotosParaCorreoComprimidas(List<FotoAdjunta> fotos) async 
  {
    List<FotoAdjunta> resultados = [];

    for(final foto in fotos) {
      FotoAdjunta? fotoComprimida = await comprimirFotos(foto);
      resultados.add(fotoComprimida!);
    }

    return prepararFotosParaCorreo(resultados);
  }

}
