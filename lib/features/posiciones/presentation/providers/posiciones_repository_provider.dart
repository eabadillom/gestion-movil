import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/login/login.dart';
import 'package:gestion_movil/features/posiciones/controller/controller.dart';
import 'package:gestion_movil/features/posiciones/domain/domain.dart';

final posicionesPlantaRepositoryProvider = Provider<PosicionesPlantaRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final posicionesRepository = PosicionesPlantaRepositoryImpl(PosicionesPlantaDatasourceImpl(accessToken: accessToken));
  return posicionesRepository;
});
