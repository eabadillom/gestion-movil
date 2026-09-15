import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';
import 'package:gestion_movil/features/candadoSalida/presentation/providers/obtenerCandado/candado_salida_repository_provider.dart';

final candadoSalidaProvider = StateNotifierProvider<CandadoSalidaNotifier, CandadoSalidaState>((ref){
  final candadoSalidaRepository = ref.watch(candadoSalidadRepositoryProvider);

  return CandadoSalidaNotifier(candadoSalidaRepository);
});

class CandadoSalidaNotifier extends StateNotifier<CandadoSalidaState>
{
  final CandadoSalidaRepository candadoSalidaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('CandadoSalidaNotifier');

  CandadoSalidaNotifier(this.candadoSalidaRepository) : super(CandadoSalidaState.initial());

  Future<void> cargarCandadoSalida(int idCliente) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final resultados = await candadoSalidaRepository.getCandadoSalida(idCliente);

    switch(resultados) {
      case Success():
        state = state.copyWith(isLoading: false, candadoSalida: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar la lista de candado de salida');
    }
  }

  void toggleHabilitado(bool value) 
  {
    if (state.candadoSalida == null) return;

    state = state.copyWith(
      candadoSalida: state.candadoSalida!.copyWith(habilitado: value),
    );
  }

  void toggleSalidaTotal(bool value) 
  {
    if (state.candadoSalida == null) return;

    state = state.copyWith(
      candadoSalida: state.candadoSalida!.copyWith(salidaTotal: value),
    );
  }

  void incrementarSalidas() 
  {
    if (state.candadoSalida == null) return;

    state = state.copyWith(
      candadoSalida: state.candadoSalida!.copyWith(numSalidas: state.candadoSalida!.numSalidas + 1),
    );
  }

  void decrementarSalidas() 
  {
    if (state.candadoSalida == null) return;

    final actual = state.candadoSalida!.numSalidas;

    if (actual <= 0) return;

    state = state.copyWith(
      candadoSalida: state.candadoSalida!.copyWith(numSalidas: actual - 1),
    );
  }

}

class CandadoSalidaState
{
  final bool isLoading;
  final CandadoSalida? candadoSalida;
  final String? errorMessage;

  CandadoSalidaState({
    this.isLoading = false,
    this.candadoSalida,
    this.errorMessage
  });

  factory CandadoSalidaState.initial() => CandadoSalidaState();

  CandadoSalidaState copyWith({
    final bool? isLoading,
    final CandadoSalida? candadoSalida,
    final String? errorMessage,
  }) => CandadoSalidaState(
    isLoading: isLoading ?? this.isLoading,
    candadoSalida: candadoSalida ?? this.candadoSalida,
    errorMessage: errorMessage ?? this.errorMessage,
  );
  
}
