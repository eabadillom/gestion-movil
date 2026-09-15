import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/candadoSalida/controller/controller.dart';
import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';
import 'package:gestion_movil/features/login/login.dart';

final guardarCandadoRepositoryProvider = Provider<CandadoSalidaRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final candadoSalidaRepository = CandadoSalidaRepositoryImpl(CandadoSalidaDatasourceImpl(accessToken: accessToken));

  return candadoSalidaRepository;
});
