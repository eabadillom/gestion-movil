import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'cliente_repository_provider.dart';

final clienteNotifierProvider = StateNotifierProvider.autoDispose<ClienteNotifier, ClienteState>((ref) 
{
  final clienteRepository = ref.watch(clienteRepositoryProvider);
  return ClienteNotifier(clienteRepository);
});

class ClienteNotifier extends StateNotifier<ClienteState> 
{
  final ClienteRepository clienteRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ClienteNotifier');

  ClienteNotifier(this.clienteRepository) : super(ClienteState.initial());

  Future<void> cargarClientes() async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final clientes = await clienteRepository.getListClientes();
      
      state = state.copyWith(isLoading: false, clientes: clientes);

    } catch (e) {
      log.logger.warning(e.toString());
      state = state.copyWith(errorMessage: 'Hubo un problema al cargar los clientes', isLoading: false);
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
  }) => ClienteState(
    isLoading: isLoading ?? this.isLoading,
    clientes: clientes ?? this.clientes,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}