import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';

import '../../domain/domain.dart';
import 'providers.dart';

final cambiarContraseniaNotifierProvider =
    StateNotifierProvider<CambiarContraseniaNotifier, CambiarContraseniaState>((
      ref,
    ) {
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

  //bool _loaded = false;

  CambiarContraseniaNotifier(this.cambiarContraseniaRepository)
    : super(CambiarContraseniaState.initial());

  Future<ControlMovil?> cambiarPalabra(String palabra) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final resultado = await cambiarContraseniaRepository.cambiarPalabra(
      palabra,
    );

    switch (resultado) {
      case Success():
        state = state.copyWith(isLoading: false, controlMovil: resultado.data);
        return resultado.data;

      case Error():
        log.logger.warning(resultado.customError.message);

        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Hubo un problema al momento de cambiar la contraseña',
        );

        return null;
    }
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
    final bool? isLoading,
    final ControlMovil? controlMovil,
    final String? errorMessage,
  }) => CambiarContraseniaState(
    isLoading: isLoading ?? this.isLoading,
    controlMovil: controlMovil ?? this.controlMovil,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
