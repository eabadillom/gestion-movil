import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/plantas/controller/controller.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';
import 'package:gestion_movil/features/login/login.dart';

final plantasRepositoryProvider = Provider<PlantasRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final plantasRepository = PlantasRepositoryImpl(PlantasDatasourceImpl(accessToken: accessToken));
  
  return plantasRepository;
});