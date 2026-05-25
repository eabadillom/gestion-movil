import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';
import 'package:gestion_movil/features/plantas/presentation/providers/providers.dart';

final plantaNotifierProvider = StateNotifierProvider<PlantaNotifier, PlantaState>((ref) 
{
  final plantaRepository = ref.watch(plantasRepositoryProvider);
  return PlantaNotifier(plantaRepository);
});

class PlantaNotifier extends StateNotifier<PlantaState> 
{
  final PlantasRepository plantaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('PlantaNotifier');
  bool _loaded = false;

  PlantaNotifier(this.plantaRepository) : super(PlantaState.initial());

  Future<void> loadPlantas(String numeroUsuario) async
  {
    if (_loaded && state.plantas.isNotEmpty) return; 

    await cargarPlantas(numeroUsuario);

    _loaded = true;
  }

  Future<void> refreshPlantas(String numeroUsuario) async
  {
    if (state.isLoading) return;

    _loaded = false;

    await cargarPlantas(numeroUsuario);
    
    _loaded = true;
  }

  Future<void> cargarPlantas(String numUsuario) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final plantas = await plantaRepository.obtenerPlantas(numUsuario);
      
      state = state.copyWith(isLoading: false, plantas: plantas);
    } catch (e) {
      log.logger.warning(e.toString());
      state = state.copyWith(errorMessage: 'Hubo un problema al cargar las plantas', isLoading: false);
    }
  }
}

class PlantaState 
{
  final bool isLoading;
  final List<Planta> plantas;
  final String? errorMessage;

  PlantaState({
    this.isLoading = false,
    this.plantas = const [],
    this.errorMessage,
  });

  factory PlantaState.initial() => PlantaState();

  PlantaState copyWith({
    bool? isLoading,
    List<Planta>? plantas,
    String? errorMessage,
  }) => PlantaState(
    isLoading: isLoading ?? this.isLoading,
    plantas: plantas ?? this.plantas,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}