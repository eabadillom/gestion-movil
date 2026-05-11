import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/pdfService/pdf_service.dart';
import 'package:gestion_movil/features/posiciones/presentation/providers/reporte_pdf_provider.dart';

class PosicionesPdfScreen extends BasePdfScreen<ReportePdfState> 
{
  final DateTime fechaConsulta;
  final String numUsuario;
  final List<int>? idsSeleccionados;

  const PosicionesPdfScreen({super.key, required this.fechaConsulta, required this.numUsuario, this.idsSeleccionados}) : super(title: 'Generando PDF');

  @override
  ConsumerState<PosicionesPdfScreen> createState() => _PosicionesPdfScreen();
}

class _PosicionesPdfScreen extends BasePdfScreenState<PosicionesPdfScreen, ReportePdfState> 
{
  @override
  ProviderListenable<ReportePdfState> get provider => reportePdfProvider;

  @override
  dynamic getFileResponse(ReportePdfState state) 
  {
    return state.fileResponse;
  }

  @override
  String? getErrorMessage(ReportePdfState state) 
  {
    return state.errorMessage;
  }

  @override
  Future<void> generarReporte() async 
  {
    ref.read(reportePdfProvider.notifier).generarReportePDF(widget.fechaConsulta, widget.numUsuario, widget.idsSeleccionados);
  }

}
