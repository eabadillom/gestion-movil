import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/posiciones/presentation/providers/reporte_pdf_provider.dart';

class PosicionesPdfScreen extends ConsumerStatefulWidget 
{
  final DateTime fechaConsulta;
  final String numUsuario;
  final List<int>? idsSeleccionados;

  const PosicionesPdfScreen({super.key, required this.fechaConsulta, required this.numUsuario, this.idsSeleccionados});

  @override
  ConsumerState<PosicionesPdfScreen> createState() => _PosicionesPdfScreen();
}

class _PosicionesPdfScreen extends ConsumerState<PosicionesPdfScreen> 
{
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      ref.read(reportePdfProvider.notifier).generarReportePDF(widget.fechaConsulta, widget.numUsuario, widget.idsSeleccionados)
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    final pdfState = ref.watch(reportePdfProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Reporte de Posiciones por Camara',
            maxLines: 1,
          ),
        ),
        actions: [
          if (pdfState.errorMessage != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(reportePdfProvider.notifier).generarReportePDF(widget.fechaConsulta, widget.numUsuario, widget.idsSeleccionados),
            )
        ],
      ),
      body: _buildBody(pdfState),
    );
  }

  Widget _buildBody(ReportePdfState state) 
  {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(state.errorMessage!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (state.fileResponse != null) {
      final Uint8List pdfBytes = base64Decode(state.fileResponse!.base64Content);
      
      return PdfPreview(
        build: (format) => pdfBytes,
        pdfFileName: state.fileResponse!.fileName,
        initialPageFormat: PdfPageFormat.letter,
        maxPageWidth: double.infinity, 
        canChangePageFormat: false,      // Evita que el usuario cambie el tamaño de hoja
        canDebug: false,                 // Quita banners de depuración
        shouldRepaint: false,            // Evita recargas innecesarias al hacer zoom
        useActions: true,                // Muestra botones de imprimir y compartir
        allowPrinting: true,             // Habilita el icono de impresora
        allowSharing: true,              // Habilita el icono de compartir (WhatsApp, Correo, etc.)
        loadingWidget: const Center(child: CircularProgressIndicator()), // Mensaje mientras carga el visor nativo
      );
    }

    return const Center(child: Text('Preparando documento...'));
  }

}
