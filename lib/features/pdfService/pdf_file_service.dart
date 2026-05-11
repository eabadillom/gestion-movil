import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gestion_movil/features/pdfService/pdf_service.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PdfFileService 
{
  
  static Future<SaveResult> guardarPdf(Uint8List bytes, String fileName) async 
  {
    try {
      final Directory? downloadsDir = Platform.isAndroid ? Directory('/storage/emulated/0/Download') : await getDownloadsDirectory();

      if (downloadsDir == null) {
        return SaveResult.fail("No se encontró la carpeta Downloads");
      }

      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final safeName = fileName.replaceAll(RegExp(r'[<>:"/\\\\|?*]'), '');
      final file = File('${downloadsDir.path}/$safeName');
      debugPrint("Ruta del archivo: ${file.path}");

      if (await file.exists()) {
        await file.delete();
      }

      await file.writeAsBytes(bytes, flush: true);

      return SaveResult.ok(file.path);
    } catch (e, stack) 
    {
      debugPrint("Error guardando archivo: $e");
      debugPrintStack(stackTrace: stack);
      return SaveResult.fail("Ocurrió un error al guardar el archivo");
    }
  }

  static Future<OpenResult> abrirPdf(String path) async 
  {
    return OpenFilex.open(path);
  }

}