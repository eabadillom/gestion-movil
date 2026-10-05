import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/inventarios/controller/controller.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/login/presentation/providers/provider.dart';

final salidaProvider = Provider<ConstanciaRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final salidaRepository = ConstanciaRepositoryImpl(ConstanciaDatasourceImpl(accessToken: accessToken));
  
  return salidaRepository;
});
