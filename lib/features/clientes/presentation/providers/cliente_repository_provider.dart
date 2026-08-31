import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/clientes/controller/controller.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/login/login.dart';

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final clienteRepository = ClienteRepositoryImpl(ClienteDatasourceImpl(accessToken: accessToken));
  
  return clienteRepository;
});