import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constancia_deposito/presentation/providers/providers.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class KardexPdfScreen extends ConsumerStatefulWidget
{
  final String folioCliente;

  const KardexPdfScreen({super.key, required this.folioCliente});

  @override
  ConsumerState<KardexPdfScreen> createState() => _KardexPdfScreen();
}

class _KardexPdfScreen extends ConsumerState<KardexPdfScreen>
{
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(kardexResponseProvider.notifier).generarReportePDF(widget.folioCliente));
  }

  @override
  Widget build(BuildContext context) 
  {
    final kardexResponseState = ref.watch(kardexResponseProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Reporte del Kardex',
            maxLines: 1,
          ),
        ),
        actions: [
          if (kardexResponseState.errorMessage != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(kardexResponseProvider.notifier).generarReportePDF(widget.folioCliente),
            )
        ],
      ),
      body: _buildBody(kardexResponseState),
    );
  }

  Widget _buildBody(KardexResponseState state) 
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
