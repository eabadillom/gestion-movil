import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:gestion_movil/features/pdfService/pdf_service.dart';
import 'package:gestion_movil/features/shared/widgets/widgets.dart';

abstract class BasePdfScreen<TState> extends ConsumerStatefulWidget 
{
  final String title;

  const BasePdfScreen({super.key, required this.title});
}

abstract class BasePdfScreenState<T extends BasePdfScreen<TState>, TState> extends ConsumerState<T> 
{
  double progress = 0.0;
  bool isDownloading = true;
  String? filePath;

  ProviderListenable<TState> get provider; /// Provider a escuchar
  dynamic getFileResponse(TState state); /// Obtener fileResponse
  String? getErrorMessage(TState state); /// Obtener errorMessage
  Future<void> generarReporte(); /// Método que dispara la generación

  @override
  void initState() 
  {
    super.initState();

    iniciarProceso();
  }

  void iniciarProceso() 
  {
    progresoFalso();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      generarReporte();
    });
  }

  Future<void> progresoFalso() async 
  {
    progress = 0;

    while (progress < 0.9 && isDownloading) 
    {
      await Future.delayed(
        const Duration(milliseconds: 200),
      );

      if (!mounted) return;

      setState(() {
        progress = (progress + 0.04).clamp(0.0, 1.0);
      });
    }
  }

  Future<void> procesarArchivo(TState state) async 
  {
    final fileResponse = getFileResponse(state);

    if (fileResponse == null) return;

    setState(() {
      isDownloading = false;
    });

    final Uint8List pdfBytes = base64Decode(fileResponse.base64Content);

    final result = await PdfFileService.guardarArchivo(pdfBytes, fileResponse.fileName);

    if (!mounted) return;

    if (!result.success) {
      CustomSnackBarCentrado.mostrar(
        context,
        mensaje: result.error ?? 'Error al guardar archivo',
        tipo: SnackbarTipo.error,
      );
      return;
    }

    setState(() {
      progress = 1.0;
      filePath = result.path;
    });

    CustomSnackBarCentrado.mostrar(
      context,
      mensaje: 'Archivo listo',
      tipo: SnackbarTipo.success,
    );
  }

  Future<void> abrirArchivo() async 
  {
    if (filePath == null) return;

    final OpenResult result = await PdfFileService.abrirPdf(filePath!);

    if (!mounted) return;

    if (result.type != ResultType.done) {
      CustomSnackBarCentrado.mostrar(
        context,
        mensaje: 'No se pudo abrir el archivo',
        tipo: SnackbarTipo.error,
      );
    }
  }

  void reintentar() 
  {
    setState(() {
      progress = 0;
      isDownloading = true;
      filePath = null;
    });

    iniciarProceso();
  }

  @override
  Widget build(BuildContext context) 
  {
    ref.listen<TState>(provider, (prev, next) 
      {
        final prevFile = prev != null ? getFileResponse(prev) : null;
        final nextFile = getFileResponse(next);

        if (nextFile != null && prevFile == null) {
          procesarArchivo(next);
        }

        if (getErrorMessage(next) != null) {
          setState(() {
            isDownloading = false;
          });
        }
      },
    );

    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          if (getErrorMessage(state) != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: reintentar,
            ),
        ],
      ),
      body: buildBody(state),
    );
  }

  Widget buildBody(TState state) 
  {
    final error = getErrorMessage(state);
    if (error != null) {
      return ErrorView(
        mensaje: error,
        onRetry: reintentar,
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PdfProgressWidget(
            progress: progress,
            isReady: filePath != null,
          ),

          if (!isDownloading && filePath != null)
            ...[
              const SizedBox(height: 24),
              PdfOpenButton(onPressed: abrirArchivo),
            ],
        ],
      ),
    );
  }
}
