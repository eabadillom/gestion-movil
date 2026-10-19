import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CameraService 
{
  final ImagePicker _picker;

  CameraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  Future<File?> tomarFoto(String folio, int incremento) async 
  {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (imagen == null) {
      return null;
    }
    
    final File original = File(imagen.path);
    final String nombre = _generarNombreFoto(folio, incremento);
    final Directory directorio = original.parent;

    final File nuevaFoto = await original.copy('${directorio.path}/$nombre');

    return nuevaFoto;
  }

  Future<File?> seleccionarDeGaleria() async 
  {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (imagen == null) {
      return null;
    }

    return File(imagen.path);
  }

  String _generarNombreFoto(String folio, int incremento) 
  {
    return '${folio}_IMG$incremento.jpg';
  }

}
