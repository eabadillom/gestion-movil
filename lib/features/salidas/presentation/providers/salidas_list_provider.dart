import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';
import 'package:gestion_movil/features/salidas/presentation/providers/providers.dart';

final salidasListProvider = StateNotifierProvider.autoDispose<SalidasNotifier, SalidasState>((ref)
{
  final repository = ref.watch(salidasProvider);
  
  return SalidasNotifier(repository);
});
 
class SalidasNotifier extends StateNotifier<SalidasState>
{
  final SalidasRepository salidasRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('SalidasNotifier');

  SalidasNotifier(this.salidasRepository) : super(SalidasState.initial());

  Future<void> obtenerSalidas(int? idCliente, DateTime fechaInicio, DateTime fechaFin) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null, paginaActual: 1);

    final resultados = await salidasRepository.getSalidas(idCliente, fechaInicio, fechaFin);

    switch(resultados) {
      case Success():
        state = state.copyWith(isLoading: false, listSalidas: resultados.data, paginaActual: 1);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: resultados.customError.message, paginaActual: 1);
    }
  }

  void cambiarPagina(int nuevaPagina) 
  {
    if (nuevaPagina >= 1 && nuevaPagina <= state.totalPaginas) 
    {
      state = state.copyWith(paginaActual: nuevaPagina);
    }
  }

  void limpiar(){
    state = SalidasState.initial();
  }

}

class SalidasState
{
  final bool isLoading;
  final List<Salidas> listSalidas;
  final String? errorMessage;
  final int paginaActual;
  final int tamanioPagina;

  SalidasState({
    this.isLoading = false,
    this.listSalidas = const [],
    this.errorMessage,
    this.paginaActual = 1,
    this.tamanioPagina = 5,
  });

  List<Salidas> get registrosPaginados 
  {
    final lista = listSalidas;
    if (lista.isEmpty) return [];

    final pagina = paginaActual.clamp(1, totalPaginas);

    final inicio = ((pagina - 1) * tamanioPagina).clamp(0, lista.length);
    final fin = (inicio + tamanioPagina).clamp(inicio, lista.length);

    return lista.sublist(inicio, fin);
  }

  int get totalPaginas 
  {
    final total = (listSalidas.length / tamanioPagina).ceil();
    return total == 0 ? 0 : total;
  }

  int get paginaMostrada {
    if (totalPaginas == 0) return 0;
    return paginaActual.clamp(1, totalPaginas);
  }

  factory SalidasState.initial() => SalidasState(listSalidas: []);

  SalidasState copyWith({
    bool? isLoading,
    List<Salidas>? listSalidas,
    String? errorMessage,
    int? paginaActual,
    int? tamanioPagina,
  }) => SalidasState(
    isLoading: isLoading ?? this.isLoading,
    listSalidas: listSalidas ?? this.listSalidas,
    errorMessage: errorMessage ?? this.errorMessage,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );

}
