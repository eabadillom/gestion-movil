import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';
import 'package:gestion_movil/features/constancia_deposito/presentation/providers/providers.dart';

final inventarioPdfResponseProvider = StateNotifierProvider.autoDispose<InventarioResponseNotifier, InventarioResponseState>((ref) 
{
  final repository = ref.watch(inventarioPdfProvider);
  
  return InventarioResponseNotifier(repository);
});

class InventarioResponseNotifier extends StateNotifier<InventarioResponseState>
{
  final PdfRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('InventarioResponseNotifier');

  InventarioResponseNotifier(this.repository) : super(InventarioResponseState.initial());

  Future<void> generarReportePDF(DateTime fecha, int? cliente, int? planta) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final fileResponse = await repository.getInventarioPDF(fecha, cliente, planta);

      state = state.copyWith(isLoading: false, fileResponse: fileResponse);
    } catch (e) {
      log.logger.warning(e.toString());
      
      state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar el archivo');
    }
  }

}

class InventarioResponseState
{
  final bool isLoading;
  final FileResponse? fileResponse;
  final String? errorMessage;

  InventarioResponseState({
    this.isLoading = false,
    this.fileResponse,
    this.errorMessage,
  });

  factory InventarioResponseState.initial() => InventarioResponseState();

  InventarioResponseState copyWith({
    bool? isLoading,
    FileResponse? fileResponse,
    String? errorMessage,
  }) => InventarioResponseState(
    isLoading: isLoading ?? this.isLoading,
    fileResponse: fileResponse ?? this.fileResponse,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
