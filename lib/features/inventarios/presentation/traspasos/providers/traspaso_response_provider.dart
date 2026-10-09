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
        state = state.copyWith(isLoading: false, errorMessage: resultados.customError.message);
    }
  }

  void cambiarPagina(int nuevaPagina) 
  {
    if (nuevaPagina >= 1 && nuevaPagina <= state.totalPaginas) 
    {
      state = state.copyWith(paginaActual: nuevaPagina);
    }
  }

  void limpiar() 
  {
    state = TraspasoResponseState.initial();
  }

}

class TraspasoResponseState
{
  final bool isLoading;
  final List<Constancia> listConstancias;
  final String? errorMessage;
  final int paginaActual;
  final int tamanioPagina;

  TraspasoResponseState({
    this.isLoading = false,
    this.listConstancias = const [],
    this.errorMessage,
    this.paginaActual = 1,
    this.tamanioPagina = 5,
  });

  List<Constancia> get registrosPaginados 
  {
    final lista = listConstancias;
    if (lista.isEmpty) return [];

    final inicio = ((paginaActual - 1) * tamanioPagina).clamp(0, lista.length);
    final fin = (inicio + tamanioPagina).clamp(inicio, lista.length);

    return lista.sublist(inicio, fin);
  }

  int get totalPaginas 
  {
    final total = (listConstancias.length / tamanioPagina).ceil();
    return total == 0 ? 0 : total;
  }

  int get paginaMostrada => totalPaginas == 0 ? 0 : paginaActual;

  factory TraspasoResponseState.initial() => TraspasoResponseState(listConstancias: []);

  TraspasoResponseState copyWith({
    bool? isLoading,
    List<Constancia>? listConstancias,
    String? errorMessage,
    int? paginaActual,
    int? tamanioPagina,
  }) => TraspasoResponseState(
    isLoading: isLoading ?? this.isLoading,
    listConstancias: listConstancias ?? this.listConstancias,
    errorMessage: errorMessage ?? this.errorMessage,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );

}
