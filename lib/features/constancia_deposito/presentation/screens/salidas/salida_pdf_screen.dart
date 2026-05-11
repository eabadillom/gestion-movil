import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constancia_deposito/presentation/providers/providers.dart';
import 'package:gestion_movil/features/pdfService/pdf_service.dart';

class SalidaPdfScreen extends BasePdfScreen<SalidaResponseState> 
{
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int? idCliente;
  final int? idPlanta;
  final int? idCamara;

  const SalidaPdfScreen({super.key, required this.fechaInicio, required this.fechaFin, this.idCliente, this.idPlanta, this.idCamara}) : super(title: 'Generando PDF');

  @override
  ConsumerState<SalidaPdfScreen> createState() => _SalidaPdfScreenState();
}

class _SalidaPdfScreenState extends BasePdfScreenState<SalidaPdfScreen, SalidaResponseState>
{
  @override
  ProviderListenable<SalidaResponseState> get provider => salidaPdfResponseProvider;

  @override
  dynamic getFileResponse(SalidaResponseState state) {
    return state.fileResponse;
  }

  @override
  String? getErrorMessage(SalidaResponseState state) {
    return state.errorMessage;
  }

  @override
  Future<void> generarReporte() async {
    ref.read(salidaPdfResponseProvider.notifier).generarReportePDF(widget.fechaInicio, widget.fechaFin, widget.idCliente, widget.idPlanta, widget.idCamara);
  }
  
}
