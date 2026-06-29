import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';
import 'package:gestion_movil/features/posiciones/presentation/providers/file_response_respository_provider.dart';

final reportePdfProvider = StateNotifierProvider.autoDispose<ReportePdfNotifier, ReportePdfState>((ref) 
{
  final repository = ref.watch(fileResponseRepositoryProvider);
  
  return ReportePdfNotifier(repository);
});

class ReportePdfNotifier extends StateNotifier<ReportePdfState>
{
  final FileResponseRepository fileResponseRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ReportePdfNotifier');

  ReportePdfNotifier(this.fileResponseRepository) : super(ReportePdfState.initial());

  Future<void> generarReportePDF(DateTime fechaConsulta, String numUsuario, List<int>? idsSeleccionados) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final resultados = await fileResponseRepository.getPosicionesPlantaPDF(fechaConsulta, numUsuario, idsSeleccionados);

    switch(resultados) {
      case Success():
        state = state.copyWith(isLoading: false, fileResponse: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: resultados.customError.message);
    }
  }
}

class ReportePdfState
{
  final bool isLoading;
  final FileResponse? fileResponse;
  final String? errorMessage;

  ReportePdfState({
    this.isLoading = false,
    this.fileResponse,
    this.errorMessage,
  });

  factory ReportePdfState.initial() => ReportePdfState();

  ReportePdfState copyWith({
    bool? isLoading,
    FileResponse? fileResponse,
    String? errorMessage,
  }) => ReportePdfState(
    isLoading: isLoading ?? this.isLoading,
    fileResponse: fileResponse ?? this.fileResponse,
    errorMessage: errorMessage ?? this.errorMessage,
  );
  
}
