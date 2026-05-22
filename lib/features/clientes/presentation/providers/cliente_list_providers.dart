import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'cliente_repository_provider.dart';

final clienteNotifierProvider = StateNotifierProvider<ClienteNotifier, ClienteState>((ref) 
{
  final clienteRepository = ref.watch(clienteRepositoryProvider);
  return ClienteNotifier(clienteRepository);
});

class ClienteNotifier extends StateNotifier<ClienteState> 
{
  final ClienteRepository clienteRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ClienteNotifier');
  bool _loaded = false;

  ClienteNotifier(this.clienteRepository) : super(ClienteState.initial());

  Future<void> loadClientes() async
  {
    if (_loaded && state.clientes.isNotEmpty) return; 

    await obtenerClientes();

    _loaded = true;
  }

  Future<void> refreshClientes() async
  {
    if (state.isLoading) return;

    _loaded = false;

    await obtenerClientes();
    
    _loaded = true;
  }

  Future<void> obtenerClientes() async 
  {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final clientes = await clienteRepository.getListClientes();
      
      state = state.copyWith(isLoading: false, clientes: clientes);

    } catch (e) {
      log.logger.warning(e.toString());
      state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar los clientes');
    }
  }
  
}

class ClienteState
{
  final bool isLoading;
  final List<Cliente> clientes;
  final String? errorMessage;
  
  ClienteState({
    this.isLoading = false,
    this.clientes = const [],
    this.errorMessage,
  });

  factory ClienteState.initial() => ClienteState();

  ClienteState copyWith({
    bool? isLoading,
    List<Cliente>? clientes,
    String? errorMessage,
    bool clearError = false,
  }) => ClienteState(
    isLoading: isLoading ?? this.isLoading,
    clientes: clientes ?? this.clientes,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
