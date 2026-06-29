import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';
import 'package:gestion_movil/features/constanciaDeposito/presentation/providers/providers.dart';

final salidaPdfResponseProvider = StateNotifierProvider.autoDispose<SalidaResponseNotifier, SalidaResponseState>((ref) 
{
  final repository = ref.watch(entradaPdfProvider);
  
  return SalidaResponseNotifier(repository);
});

class SalidaResponseNotifier extends StateNotifier<SalidaResponseState>
{
  final PdfRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('EntradaResponseNotifier');

  SalidaResponseNotifier(this.repository) : super(SalidaResponseState.initial());

  Future<void> generarReportePDF(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta, int? camara) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final resultados = await repository.getSalidaPDF(fechaInicio, fechaFin, cliente, planta, camara);

    switch(resultados) {
      case Success():
        state = state.copyWith(isLoading: false, fileResponse: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar el pdf de salidas');
    }
  }

}

class SalidaResponseState
{
  final bool isLoading;
  final FileResponse? fileResponse;
  final String? errorMessage;

  SalidaResponseState({
    this.isLoading = false,
    this.fileResponse,
    this.errorMessage,
  });

  factory SalidaResponseState.initial() => SalidaResponseState();

  SalidaResponseState copyWith({
    bool? isLoading,
    FileResponse? fileResponse,
    String? errorMessage,
  }) => SalidaResponseState(
    isLoading: isLoading ?? this.isLoading,
    fileResponse: fileResponse ?? this.fileResponse,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
