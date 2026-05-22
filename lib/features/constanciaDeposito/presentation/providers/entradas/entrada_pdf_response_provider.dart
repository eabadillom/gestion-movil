import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';
import 'package:gestion_movil/features/constanciaDeposito/presentation/providers/providers.dart';

final entradaPdfResponseProvider = StateNotifierProvider.autoDispose<EntradaResponseNotifier, EntradaResponseState>((ref) 
{
  final repository = ref.watch(entradaPdfProvider);
  
  return EntradaResponseNotifier(repository);
});

class EntradaResponseNotifier extends StateNotifier<EntradaResponseState>
{
  final PdfRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('EntradaResponseNotifier');

  EntradaResponseNotifier(this.repository) : super(EntradaResponseState.initial());

  Future<void> generarReportePDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final fileResponse = await repository.getEntradaPDF(fechaInicio, fechaFin, cliente, planta, camara);

      state = state.copyWith(isLoading: false, fileResponse: fileResponse);
    } catch (e) {
      log.logger.warning(e.toString());
      
      state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar el archivo');
    }
  }

}

class EntradaResponseState
{
  final bool isLoading;
  final FileResponse? fileResponse;
  final String? errorMessage;

  EntradaResponseState({
    this.isLoading = false,
    this.fileResponse,
    this.errorMessage,
  });

  factory EntradaResponseState.initial() => EntradaResponseState();

  EntradaResponseState copyWith({
    bool? isLoading,
    FileResponse? fileResponse,
    String? errorMessage,
  }) => EntradaResponseState(
    isLoading: isLoading ?? this.isLoading,
    fileResponse: fileResponse ?? this.fileResponse,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
