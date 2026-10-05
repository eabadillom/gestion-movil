import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/entradas/providers/entrada_provider.dart';

final traspasoResponseProvider = StateNotifierProvider.autoDispose<TraspasoResponseNotifier, TraspasoResponseState>((ref) 
{
  final repository = ref.watch(entradaProvider);
  
  return TraspasoResponseNotifier(repository);
});

class TraspasoResponseNotifier extends StateNotifier<TraspasoResponseState>
{
  final ConstanciaRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('TraspasoResponseNotifier');

  TraspasoResponseNotifier(this.repository) : super(TraspasoResponseState.initial());

  Future<void> obtenerConstanciasTraspaso(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final resultados = await repository.listarConstancias(tipo, inicio, fin, idCliente, folioCliente);

    switch(resultados) 
    {
      case Success():
        state = state.copyWith(isLoading: false, listConstancias: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar los traspasos');
    }
  }

}

class TraspasoResponseState
{
  final bool isLoading;
  final List<ConstanciaDTO>? listConstancias;
  final String? errorMessage;

  TraspasoResponseState({
    this.isLoading = false,
    this.listConstancias,
    this.errorMessage,
  });

  factory TraspasoResponseState.initial() => TraspasoResponseState();

  TraspasoResponseState copyWith({
    bool? isLoading,
    List<ConstanciaDTO>? listConstancias,
    String? errorMessage,
  }) => TraspasoResponseState(
    isLoading: isLoading ?? this.isLoading,
    listConstancias: listConstancias ?? this.listConstancias,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
