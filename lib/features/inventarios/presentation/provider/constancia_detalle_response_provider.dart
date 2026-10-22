import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/provider/constancia_detalle_provider.dart';

final constanciaDetalleResponseProvider = StateNotifierProvider.autoDispose<ConstanciaDetalleResponseNotifier, ConstanciaDetalleResponseState>((ref)
{
  final repository = ref.watch(constanciaDetalleProvider);

  return ConstanciaDetalleResponseNotifier(repository);
});

class ConstanciaDetalleResponseNotifier extends StateNotifier<ConstanciaDetalleResponseState>
{
  final ConstanciaRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ConstanciaDetalleResponseNotifier');

  ConstanciaDetalleResponseNotifier(this.repository) : super(ConstanciaDetalleResponseState.initial());

  Future<void> obtenerConstanciaDetalle(TipoConstancia tipo, int id) async
  {
    state = state.copyWith(
      isLoading: true,
      tipo: tipo,
      id: id,
      limpiarConstancia: true,
      limpiarError: true,
    );

    final resultado = await repository.obtenerConstanciaDetalle(tipo, id);

    switch (resultado)
    {
      case Success():
        state = state.copyWith(
          isLoading: false,
          constancia: resultado.data,
        );
      case Error():
        log.logger.warning(resultado.customError.message);
        state = state.copyWith(
          isLoading: false,
          errorMessage: resultado.customError.message,
        );
    }
  }

  void limpiar()
  {
    state = ConstanciaDetalleResponseState.initial();
  }

}

class ConstanciaDetalleResponseState
{
  final bool isLoading;
  final TipoConstancia? tipo;
  final int? id;
  final ConstanciaDetalle? constancia;
  final String? errorMessage;

  const ConstanciaDetalleResponseState({
    this.isLoading = false,
    this.tipo,
    this.id,
    this.constancia,
    this.errorMessage,
  });

  factory ConstanciaDetalleResponseState.initial()
  {
    return const ConstanciaDetalleResponseState();
  }

  ConstanciaDetalleResponseState copyWith({
    bool? isLoading,
    TipoConstancia? tipo,
    int? id,
    ConstanciaDetalle? constancia,
    String? errorMessage,
    bool limpiarConstancia = false,
    bool limpiarError = false,
  })
  {
    return ConstanciaDetalleResponseState(
      isLoading: isLoading ?? this.isLoading,
      tipo: tipo ?? this.tipo,
      id: id ?? this.id,
      constancia: limpiarConstancia ? null : constancia ?? this.constancia,
      errorMessage: limpiarError ? null : errorMessage ?? this.errorMessage,
    );
  }

}
