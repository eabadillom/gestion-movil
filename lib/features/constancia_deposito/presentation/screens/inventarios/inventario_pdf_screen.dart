import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constancia_deposito/presentation/providers/providers.dart';
import 'package:gestion_movil/features/pdfService/base_pdf_screen.dart';

class InventarioPdfScreen extends BasePdfScreen<InventarioResponseState>
{
  final DateTime fecha;
  final int? idCliente;
  final int? idPlanta;

  const InventarioPdfScreen({super.key, required this.fecha, this.idCliente, this.idPlanta}) : super(title: 'Generando PDF');
  
  @override
  ConsumerState<InventarioPdfScreen> createState() => _InventarioPdfScreenState();
}

class _InventarioPdfScreenState extends BasePdfScreenState<InventarioPdfScreen, InventarioResponseState>  
{
  @override
  ProviderListenable<InventarioResponseState> get provider => inventarioPdfResponseProvider;

  @override
  dynamic getFileResponse(InventarioResponseState state) 
  {
    return state.fileResponse;
  }

  @override
  String? getErrorMessage(InventarioResponseState state) 
  {
    return state.errorMessage;
  }

  @override
  Future<void> generarReporte() async 
  {
    ref.read(inventarioPdfResponseProvider.notifier).generarReportePDF(widget.fecha, widget.idCliente, widget.idPlanta);
  }

}
