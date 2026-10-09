import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';

import '../../domain/domain.dart';
import 'providers.dart';

final cambiarContraseniaNotifierProvider =
    StateNotifierProvider.autoDispose<
      CambiarContraseniaNotifier,
      CambiarContraseniaState
    >((ref) {
      final cambiarContraseniaRepository = ref.watch(
        cambiarContraseniaRepoProvider,
      );

      return CambiarContraseniaNotifier(cambiarContraseniaRepository);
    });

class CambiarContraseniaNotifier
    extends StateNotifier<CambiarContraseniaState> {
  final CambiarContraseniaRepository cambiarContraseniaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'CambiarContraseniaNotifier',
  );

  CambiarContraseniaNotifier(this.cambiarContraseniaRepository)
    : super(CambiarContraseniaState.initial());

  Future<bool> cambiarPalabra(String palabra) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final resultado = await cambiarContraseniaRepository.cambiarPalabra(
      palabra,
    );

    switch (resultado) {
      case Success():
        state = state.copyWith(isLoading: false, controlMovil: resultado.data);

        return true;

      case Error():
        log.logger.warning(resultado.customError.message);

        state = state.copyWith(
          isLoading: false,
          errorMessage: resultado.customError.message,
        );

        return false;
    }
  }

  void limpiar() {
    state = CambiarContraseniaState.initial();
  }
}

class CambiarContraseniaState {
  final bool isLoading;
  final ControlMovil? controlMovil;
  final String? errorMessage;

  CambiarContraseniaState({
    this.isLoading = false,
    this.controlMovil,
    this.errorMessage,
  });

  factory CambiarContraseniaState.initial() => CambiarContraseniaState();

  CambiarContraseniaState copyWith({
    bool? isLoading,
    ControlMovil? controlMovil,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CambiarContraseniaState(
      isLoading: isLoading ?? this.isLoading,
      controlMovil: controlMovil ?? this.controlMovil,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
