import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constanciaDeposito/presentation/providers/providers.dart';
import 'package:gestion_movil/features/pdfService/base_pdf_screen.dart';

class KardexPdfScreen extends BasePdfScreen<KardexResponseState>
{
  final String folioCliente;

  const KardexPdfScreen({super.key, required this.folioCliente}) : super(title: 'Generando PDF');

  @override
  ConsumerState<KardexPdfScreen> createState() => _KardexPdfScreen();
}

class _KardexPdfScreen extends BasePdfScreenState<KardexPdfScreen, KardexResponseState>
{
  @override
  ProviderListenable<KardexResponseState> get provider => kardexPdfResponseProvider;

  @override
  dynamic getFileResponse(KardexResponseState state) 
  {
    return state.fileResponse;
  }

  @override
  String? getErrorMessage(KardexResponseState state) 
  {
    return state.errorMessage;
  }

  @override
  Future<void> generarReporte() async 
  {
    ref.read(kardexPdfResponseProvider.notifier).generarReportePDF(widget.folioCliente);
  }
  
}
