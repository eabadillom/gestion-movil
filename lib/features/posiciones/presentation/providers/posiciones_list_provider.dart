import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';
import 'package:gestion_movil/features/posiciones/presentation/providers/posiciones_repository_provider.dart';

final posicionesNotifierProvider = StateNotifierProvider.autoDispose<PosicionesNotifier, PosicionesState>((ref) 
{
  final posicionesProvider = ref.watch(posicionesPlantaRepositoryProvider);

  return PosicionesNotifier(posicionesProvider);
});

class PosicionesNotifier extends StateNotifier<PosicionesState>
{
  final PosicionesPlantaRepository posicionesRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('PosicionesNotifier');

  PosicionesNotifier(this.posicionesRepository) : super(PosicionesState.initial());

  Future<void> cargarPosicionesPlanta(DateTime fecha, String numUsuario, List<int>? idsSeleccionados) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final resultados = await posicionesRepository.obtenerPosicionesPlanta(fecha, numUsuario, idsSeleccionados);

    switch(resultados) {
      case Success():
        Map<String, List<PosicionesPlanta>> posicionesAgrupados = {};

        for (var item in resultados.data) {
          if (!posicionesAgrupados.containsKey(item.planta)) {
            posicionesAgrupados[item.planta] = [];
          }
          posicionesAgrupados[item.planta]!.add(item);
        }

        state = state.copyWith(isLoading: false, posicionesPlanta: posicionesAgrupados);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(errorMessage: resultados.customError.message, isLoading: false);
    }
  }
  
}

class PosicionesState
{
  final bool isLoading;
  final Map<String, List<PosicionesPlanta>> posicionesPlanta;
  final String? errorMessage;
  
  PosicionesState({
    this.isLoading = false,
    this.posicionesPlanta = const {},
    this.errorMessage,
  });

  factory PosicionesState.initial() => PosicionesState();

  PosicionesState copyWith({
    bool? isLoading,
    Map<String, List<PosicionesPlanta>>? posicionesPlanta,
    String? errorMessage
  }) => PosicionesState (
      isLoading: isLoading ?? this.isLoading,
      posicionesPlanta: posicionesPlanta ?? this.posicionesPlanta,
      errorMessage: errorMessage ?? this.errorMessage
  );

}
