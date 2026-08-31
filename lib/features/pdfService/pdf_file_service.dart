import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_store/flutter_media_store.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gestion_movil/features/shared/widgets/widgets.dart';

class PdfFileService 
{
  
  static Future<SaveResult> guardarArchivo(Uint8List bytes, String fileName) async 
  {
    try {
      final permitido = await solicitarPermisosAlmacenamiento();
      
      if (!permitido) {
        return SaveResult.fail('Permiso denegado');
      }

      final safeName = fileName.replaceAll(RegExp(r'[^\w\s\.-]'), '').trim();
      
      if (safeName.isEmpty) {
        return SaveResult.fail("Nombre del archivo inválido");
      }

      if (Platform.isAndroid) // Android
      {
        final mediaStore = FlutterMediaStore();
        String? savedPath;
        String? errorMessage;

        await mediaStore.saveFile(
          fileData: bytes,
          fileName: safeName,
          mimeType: _getMimeType(safeName),
          rootFolderName: "Download",
          folderName: "GestionMovil",
          onSuccess: (path, uri) {
            savedPath = uri;
            debugPrint('Archivo guardado: $path');
            debugPrint('Uri: $uri');
          },
          onError: (error) {
            errorMessage = error.toString();
            debugPrint('Error MediaStore: $error');
          },
        );

        if (errorMessage != null) {
          return SaveResult.fail(errorMessage!);
        }

        return SaveResult.ok(savedPath ?? 'Archivo guardado correctamente');
      } else // iOS / Desktop
      { 
        final directory = await getDownloadsDirectory();

        if (directory == null) { 
          return SaveResult.fail('No se encontró la carpeta Downloads');
        }

        final file = File('${directory.path}/$safeName');

        await file.writeAsBytes(bytes, flush: true);

        return SaveResult.ok(file.path);
      }
    } catch (e, stack) {
      debugPrint("Error guardando archivo: $e");
      debugPrintStack(stackTrace: stack);
      return SaveResult.fail("Ocurrió un error al guardar el archivo");
    }
  }

  static Future<bool> solicitarPermisosAlmacenamiento() async 
  {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    debugPrint('ANDROID SDK: $sdkInt');

    PermissionStatus status;

    if (sdkInt >= 30) {
      status = await Permission.manageExternalStorage.request();
    } else {
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }

  static String _getMimeType(String fileName) 
  {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  static Future<OpenResult> abrirPdf(String path) async 
  {
    return OpenFilex.open(path);
  }

}