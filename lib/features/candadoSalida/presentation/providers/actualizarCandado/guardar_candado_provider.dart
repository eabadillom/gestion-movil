import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';
import 'package:gestion_movil/features/candadoSalida/presentation/providers/providers.dart';

final guardarCandadoProvider = StateNotifierProvider<CandadoSalidaGuardarNotifier, CandadoSalidaGuardarState>((ref) 
{
  final repository = ref.watch(guardarCandadoRepositoryProvider);

  return CandadoSalidaGuardarNotifier(repository);
});

class CandadoSalidaGuardarNotifier extends StateNotifier<CandadoSalidaGuardarState>
{
  final CandadoSalidaRepository candadoSalidaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('CandadoSalidaNotifier');

  CandadoSalidaGuardarNotifier(this.candadoSalidaRepository) : super(CandadoSalidaGuardarState.initial());

  Future<bool> guardarCandadoSalida() async 
  {
    if (state.candadoSalida == null) {
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    final resultados = await candadoSalidaRepository.guardarCandadoSalida(state.candadoSalida!);

    switch(resultados) {
      case Success():
        state = state.copyWith(isSaving: false, candadoSalida: resultados.data);
        return true;
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isSaving: false, errorMessage: 'Error al guardar información');
        return false;
    }
  }

  void agregarCandado(CandadoSalida candado) 
  {
    state = state.copyWith(
      candadoSalida: candado,
    );
  }

}

class CandadoSalidaGuardarState 
{
  final bool isLoading;
  final bool isSaving;
  final CandadoSalida? candadoSalida;
  final String? errorMessage;

  const CandadoSalidaGuardarState({
    this.isLoading = false,
    this.isSaving = false,
    this.candadoSalida,
    this.errorMessage,
  });

  factory CandadoSalidaGuardarState.initial() => const CandadoSalidaGuardarState();

  CandadoSalidaGuardarState copyWith({
    bool? isLoading,
    bool? isSaving,
    CandadoSalida? candadoSalida,
    String? errorMessage,
  }) {
    return CandadoSalidaGuardarState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      candadoSalida: candadoSalida ?? this.candadoSalida,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
