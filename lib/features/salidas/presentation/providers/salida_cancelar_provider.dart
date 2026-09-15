import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';
import 'package:gestion_movil/features/salidas/presentation/providers/providers.dart';

final salidaCancelarProvider = StateNotifierProvider<SalidaCancelarNotifier, SalidaCancelarState>((ref){
  final salidaDetalleRepository = ref.watch(salidaProvider);

  return SalidaCancelarNotifier(salidaDetalleRepository);
});

class SalidaCancelarNotifier extends StateNotifier<SalidaCancelarState>
{
  final SalidasRepository salidasRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('SalidaCancelarNotifier');
  
  SalidaCancelarNotifier(this.salidasRepository) : super(SalidaCancelarState.initial());

  Future<void> cancelarSalida(int idSalida) async
  {
    state = state.copyWith(isLoading: true, cancelada: false, errorMessage: null);
    
    final resultado = await salidasRepository.candelarSalida(idSalida);
    
    switch(resultado) {
      case Success():
        state = state.copyWith(isLoading: false, cancelada: true, errorMessage: null);
      case Error():
        log.logger.warning(resultado.customError.message);
        state = state.copyWith(isLoading: false, cancelada: false, errorMessage: 'No fue posible cancelar la orden de retiro');
    }
  }
}

class SalidaCancelarState 
{
  final bool isLoading;
  final bool? cancelada;
  final String? errorMessage;

  SalidaCancelarState({
    this.isLoading = false,
    this.cancelada = false,
    this.errorMessage,
  });

  factory SalidaCancelarState.initial() => SalidaCancelarState();

  SalidaCancelarState copyWith({
    bool? isLoading,
    bool? cancelada,
    String? errorMessage,
  }) => SalidaCancelarState(
    isLoading: isLoading ?? this.isLoading,
    cancelada: cancelada ?? this.cancelada,
    errorMessage: errorMessage,
  );

}
