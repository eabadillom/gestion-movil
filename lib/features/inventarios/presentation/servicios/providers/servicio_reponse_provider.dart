import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/entradas/providers/entrada_provider.dart';

final servicioResponseProvider = StateNotifierProvider.autoDispose<ServicioResponseNotifier, ServicioResponseState>((ref) 
{
  final repository = ref.watch(entradaProvider);
  
  return ServicioResponseNotifier(repository);
});

class ServicioResponseNotifier extends StateNotifier<ServicioResponseState>
{
  final ConstanciaRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ServicioResponseNotifier');

  ServicioResponseNotifier(this.repository) : super(ServicioResponseState.initial());

  Future<void> obtenerConstanciasServicios(TipoConstancia tipo, DateTime inicio, DateTime fin, int? idCliente, String? folioCliente) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final resultados = await repository.listarConstancias(tipo, inicio, fin, idCliente, folioCliente);

    switch(resultados) 
    {
      case Success():
        state = state.copyWith(isLoading: false, listConstancias: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar los servicios');
    }
  }

}

class ServicioResponseState
{
  final bool isLoading;
  final List<ConstanciaDTO>? listConstancias;
  final String? errorMessage;

  ServicioResponseState({
    this.isLoading = false,
    this.listConstancias,
    this.errorMessage,
  });

  factory ServicioResponseState.initial() => ServicioResponseState();

  ServicioResponseState copyWith({
    bool? isLoading,
    List<ConstanciaDTO>? listConstancias,
    String? errorMessage,
  }) => ServicioResponseState(
    isLoading: isLoading ?? this.isLoading,
    listConstancias: listConstancias ?? this.listConstancias,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
