import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/saldos/domain/domain.dart';
import 'package:gestion_movil/features/saldos/presentation/providers/validacion_saldo_repository_provider.dart';

final validacionSaldoProvider = StateNotifierProvider<ValidacionSaldoNotifier, ValidacionSaldoState>((ref){
  final validacionSaldoRepository = ref.watch(validacionSaldoRepositoryProvider);

  return ValidacionSaldoNotifier(validacionSaldoRepository);
});

class ValidacionSaldoNotifier extends StateNotifier<ValidacionSaldoState>
{
  final ValidacionSaldoRepository validacionSaldoRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ValidacionSaldoNotifier');

  ValidacionSaldoNotifier(this.validacionSaldoRepository) : super(ValidacionSaldoState.initial());

  Future<void> cargarValidacionSaldo(int idCliente, DateTime fecha) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final validacionSaldo = await validacionSaldoRepository.getValidacionSaldo(idCliente, fecha);

      state = state.copyWith(isLoading: false, validacionSaldo: validacionSaldo);
    } catch (e) {
      log.logger.warning(e.toString());
      state = state.copyWith(errorMessage: 'Hubo un problema al cargar las posiciones', isLoading: false);
    }
  }

}

class ValidacionSaldoState
{
  final bool isLoading;
  final ValidacionSaldo? validacionSaldo;
  final String? errorMessage;

  ValidacionSaldoState({
    this.isLoading = false,
    this.validacionSaldo,
    this.errorMessage
  });

  factory ValidacionSaldoState.initial() => ValidacionSaldoState();

  ValidacionSaldoState copyWith({
    final bool? isLoading,
    final ValidacionSaldo? validacionSaldo,
    final String? errorMessage,
  }) =>  ValidacionSaldoState(
    isLoading: isLoading ?? this.isLoading,
    validacionSaldo: validacionSaldo ?? this.validacionSaldo,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
