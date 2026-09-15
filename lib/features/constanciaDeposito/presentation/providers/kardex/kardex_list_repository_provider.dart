import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';
import 'package:gestion_movil/features/constanciaDeposito/presentation/providers/providers.dart';

final kardexListRepositoryProvider = StateNotifierProvider.autoDispose<KardexNotifier, KardexState>((ref)
{
  final repository = ref.watch(kardexListProvider);
  return KardexNotifier(repository);
});

class KardexNotifier extends StateNotifier<KardexState>
{
  final ConstanciaDepositoRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('KardexNotifier');

  KardexNotifier(this.repository) : super(KardexState.initial());

  Future<void> obtenerKardex(DateTime? fechaInicio, DateTime? fechaFin, int? cliente, int? planta, String? folioCliente) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null, paginaActual: 1);

    final resultados = await repository.getListKardex(fechaInicio, fechaFin, cliente, planta, folioCliente);

    switch(resultados) {
      case Success():
        state = state.copyWith(isLoading: false, constancias: resultados.data);  
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
    state = KardexState.initial();
  }

}

class KardexState
{
  final bool isLoading;
  final List<ConstanciaDeposito> constancias;
  final String? errorMessage;
  final int paginaActual;
  final int tamanioPagina;

  KardexState({
    this.isLoading = false,
    this.constancias = const [],
    this.errorMessage,
    this.paginaActual = 1,
    this.tamanioPagina = 6,
  });

  List<ConstanciaDeposito> get registrosPaginados 
  {
    final lista = constancias;
    if (lista.isEmpty) return [];

    final inicio = ((paginaActual - 1) * tamanioPagina).clamp(0, lista.length);
    final fin = (inicio + tamanioPagina).clamp(inicio, lista.length);

    return lista.sublist(inicio, fin);
  }

  int get totalPaginas 
  {
    final total = (constancias.length / tamanioPagina).ceil();
    return total == 0 ? 0 : total;
  }

  int get paginaMostrada => totalPaginas == 0 ? 0 : paginaActual;

  factory KardexState.initial() => KardexState(constancias: []);
  
  KardexState copyWith({
    bool? isLoading,
    List<ConstanciaDeposito>? constancias,
    String? errorMessage,
    int? paginaActual,
    int? tamanioPagina,
  }) => KardexState(
    isLoading: isLoading ?? this.isLoading,
    constancias: constancias ?? this.constancias,
    errorMessage: errorMessage ?? this.errorMessage,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );

}
