import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/camaras/domain/domain.dart';
import 'package:gestion_movil/features/camaras/presentation/providers/camara_list_provider.dart';

final camaraNotifierProvider = StateNotifierProvider.autoDispose<CamaraNotifier, CamaraState>((ref)
{
  final repository = ref.watch(camaraListProvider);
  
  return CamaraNotifier(repository);
});

class CamaraNotifier extends StateNotifier<CamaraState>
{
  final CamaraRepository camaraRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('CamaraNotifier');

  CamaraNotifier(this.camaraRepository) : super(CamaraState.initial());

  Future<void> obtenerRegistros(int? idPlanta) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final resultados = await camaraRepository.getListCamaras(idPlanta);

    switch(resultados) {
      case Success():
        state = state.copyWith(isLoading: false, listCamaras: resultados.data);
      case Error():
        log.logger.warning(resultados.customError.message);
        state = state.copyWith(isLoading: false, errorMessage: resultados.customError.message);
    }
  }
}

class CamaraState
{
  final bool isLoading;
  final List<Camara> listCamaras;
  final String? errorMessage;

  CamaraState({
    this.isLoading = false,
    this.listCamaras = const [],
    this.errorMessage,
  });

  factory CamaraState.initial() => CamaraState(listCamaras: []);

  CamaraState copyWith({
    bool? isLoading,
    List<Camara>? listCamaras,
    String? errorMessage,
  }) => CamaraState(
    isLoading: isLoading ?? this.isLoading,
    listCamaras: listCamaras ?? this.listCamaras,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
