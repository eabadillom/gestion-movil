import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';
import 'package:gestion_movil/features/salidas/presentation/providers/providers.dart';

final salidaDetalleProvider = StateNotifierProvider<SalidaDetalleNotifier, SalidaDetalleState>((ref){
  final salidaDetalleRepository = ref.watch(salidaProvider);

  return SalidaDetalleNotifier(salidaDetalleRepository);
});

class SalidaDetalleNotifier extends StateNotifier<SalidaDetalleState>
{
  final SalidasRepository salidasRepository; 
  final LoggerSingleton log = LoggerSingleton.getInstance('SalidaDetalleNotifier');

  SalidaDetalleNotifier(this.salidasRepository) : super(SalidaDetalleState.initial());

  Future<void> getSalidaDetalle(int idSalida) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final resultados = await salidasRepository.getDetalleSalida(idSalida);

    switch(resultados) {
      case Success():
        state = state.copyWith(isLoading: false, salida: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar el detalle de la salida');
    }
  }
}

class SalidaDetalleState 
{
  final bool isLoading;
  final Salida? salida;
  final String? errorMessage;

  SalidaDetalleState({
    this.isLoading = false,
    this.salida,
    this.errorMessage,
  });

  factory SalidaDetalleState.initial() => SalidaDetalleState();

  SalidaDetalleState copyWith({
    bool? isLoading,
    Salida? salida,
    String? errorMessage,
  }) => SalidaDetalleState(
    isLoading: isLoading ?? this.isLoading,
    salida: salida ?? this.salida,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}