import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/salidas/providers/salida_provider.dart';

final salidaResponseProvider = StateNotifierProvider.autoDispose<SalidaResponseNotifier, SalidaResponseState>((ref) 
{
  final repository = ref.watch(salidaProvider);
  
  return SalidaResponseNotifier(repository);
});

class SalidaResponseNotifier extends StateNotifier<SalidaResponseState>
{
  final ConstanciaRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('SalidaResponseNotifier');

  SalidaResponseNotifier(this.repository) : super(SalidaResponseState.initial());

  Future<void> obtenerConstanciasSalidas(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final resultados = await repository.listarConstancias(tipo, inicio, fin, idCliente, folioCliente);

    switch(resultados) 
    {
      case Success():
        state = state.copyWith(isLoading: false, listConstancias: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar las salidas');
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
    state = SalidaResponseState.initial();
  }

}

class SalidaResponseState
{
  final bool isLoading;
  final List<ConstanciaDTO> listConstancias;
  final String? errorMessage;
  final int paginaActual;
  final int tamanioPagina;

  SalidaResponseState({
    this.isLoading = false,
    this.listConstancias = const [],
    this.errorMessage,
    this.paginaActual = 1,
    this.tamanioPagina = 5,
  });

  List<ConstanciaDTO> get registrosPaginados 
  {
    final lista = listConstancias;
    if (lista.isEmpty) return [];

    final pagina = paginaActual.clamp(1, totalPaginas);

    final inicio = ((pagina - 1) * tamanioPagina).clamp(0, lista.length);
    final fin = (inicio + tamanioPagina).clamp(inicio, lista.length);

    return lista.sublist(inicio, fin);
  }

  int get totalPaginas 
  {
    final total = (listConstancias.length / tamanioPagina).ceil();
    return total == 0 ? 0 : total;
  }

  int get paginaMostrada => totalPaginas == 0 ? 0 : paginaActual;

  factory SalidaResponseState.initial() => SalidaResponseState(listConstancias: []);

  SalidaResponseState copyWith({
    bool? isLoading,
    List<ConstanciaDTO>? listConstancias,
    String? errorMessage,
    int? paginaActual,
    int? tamanioPagina,
  }) => SalidaResponseState(
    isLoading: isLoading ?? this.isLoading,
    listConstancias: listConstancias ?? this.listConstancias,
    errorMessage: errorMessage ?? this.errorMessage,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );

}
