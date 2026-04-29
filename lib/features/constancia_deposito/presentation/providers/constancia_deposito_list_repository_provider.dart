import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';
import 'package:gestion_movil/features/constancia_deposito/presentation/providers/providers.dart';

final constanciaDepositoProvider = StateNotifierProvider.autoDispose<ConstanciaDepositoNotifier, ConstanciaDepositoState>((ref)
{
  final repository = ref.watch(constanciaDepositoRepositoryProvider);
  return ConstanciaDepositoNotifier(repository);
});

class ConstanciaDepositoNotifier extends StateNotifier<ConstanciaDepositoState>
{
  final ConstanciaDepositoRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ConstanciaDepositoNotifier');

  ConstanciaDepositoNotifier(this.repository) : super(ConstanciaDepositoState.initial());

  Future<void> obtenerConstancias(DateTime fechaInicio, DateTime fechaFin, int? cliente, int? planta) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null, paginaActual: 1);

    try {
      final constancias = await repository.getConstanciaDeposito(fechaInicio, fechaFin, cliente, planta);

      state = state.copyWith(isLoading: false, constancias: constancias);

    } catch (e) {
      log.logger.warning(e.toString());
      
      state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar las constancias de depósito');
    }
  }

  void setBusqueda(String value) 
  {
    state = state.copyWith(busqueda: value, paginaActual: 1);
  }

  void cambiarPagina(int nuevaPagina) 
  {
    if (nuevaPagina >= 1 && nuevaPagina <= state.totalPaginas) 
    {
      state = state.copyWith(paginaActual: nuevaPagina);
    }
  }

}

class ConstanciaDepositoState
{
  final bool isLoading;
  final List<ConstanciaDeposito> constancias;
  final String? errorMessage;
  final String busqueda;
  final int paginaActual;
  final int tamanioPagina;

  ConstanciaDepositoState({
    this.isLoading = false,
    this.constancias = const [],
    this.errorMessage,
    required this.busqueda,
    this.paginaActual = 1,
    this.tamanioPagina = 6,
  });

  List<ConstanciaDeposito> get registrosFiltrados 
  {
    if(busqueda.trim().isEmpty) return constancias;

    final query = busqueda.toLowerCase();

    return constancias.where((r) {
      final folioCliente = r.folioCliente.toLowerCase();

      final fecha1 = FormatUtil.stringToStandard(r.fechaIngreso).toLowerCase();
      final fecha2 = FormatUtil.stringToISO(r.fechaIngreso).toLowerCase();

      return folioCliente.contains(query) || fecha1.contains(query) || fecha2.contains(query);
    }).toList();
  }

  List<ConstanciaDeposito> get registrosPaginados 
  {
    final lista = registrosFiltrados;
    if (lista.isEmpty) return [];

    final inicio = ((paginaActual - 1) * tamanioPagina).clamp(0, lista.length);
    final fin = (inicio + tamanioPagina).clamp(inicio, lista.length);

    return lista.sublist(inicio, fin);
  }

  int get totalPaginas {
    final total = (registrosFiltrados.length / tamanioPagina).ceil();
    return total == 0 ? 0 : total;
  }

  int get paginaMostrada => totalPaginas == 0 ? 0 : paginaActual;

  factory ConstanciaDepositoState.initial() => ConstanciaDepositoState(constancias: [], busqueda: '');
  
  ConstanciaDepositoState copyWith({
    bool? isLoading,
    List<ConstanciaDeposito>? constancias,
    String? errorMessage,
    String? busqueda,
    int? paginaActual,
    int? tamanioPagina,
  }) => ConstanciaDepositoState(
    isLoading: isLoading ?? this.isLoading,
    constancias: constancias ?? this.constancias,
    errorMessage: errorMessage ?? this.errorMessage,
    busqueda: busqueda ?? this.busqueda,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );

}
