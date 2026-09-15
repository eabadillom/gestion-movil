import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/camaras/controller/controller.dart';
import 'package:gestion_movil/features/camaras/domain/domain.dart';
import 'package:gestion_movil/features/login/login.dart';

final camaraListProvider = Provider<CamaraRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final camaraRepository = CamaraRepositoryImpl(CamaraDatasourceImpl(accessToken: accessToken));
  
  return camaraRepository;
});
