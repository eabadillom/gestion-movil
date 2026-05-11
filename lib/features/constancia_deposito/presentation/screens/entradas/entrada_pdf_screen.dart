import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constancia_deposito/presentation/providers/providers.dart';
import 'package:gestion_movil/features/pdfService/pdf_service.dart';

class EntradaPdfScreen extends BasePdfScreen<EntradaResponseState> 
{
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int? idCliente;
  final int? idPlanta;
  final int? idCamara;

  const EntradaPdfScreen({super.key, required this.fechaInicio, required this.fechaFin, this.idCliente, this.idPlanta, this.idCamara}) : super(title: 'Generando PDF');

  @override
  ConsumerState<EntradaPdfScreen> createState() => _EntradaPdfScreenState();
}

class _EntradaPdfScreenState extends BasePdfScreenState<EntradaPdfScreen, EntradaResponseState>  
{
  @override
  ProviderListenable<EntradaResponseState> get provider => entradaPdfResponseProvider;

  @override
  dynamic getFileResponse(EntradaResponseState state) 
  {
    return state.fileResponse;
  }

  @override
  String? getErrorMessage(EntradaResponseState state) 
  {
    return state.errorMessage;
  }

  @override
  Future<void> generarReporte() async 
  {
    ref.read(entradaPdfResponseProvider.notifier).generarReportePDF(widget.fechaInicio, widget.fechaFin, widget.idCliente, widget.idPlanta, widget.idCamara);
  }
  
}
