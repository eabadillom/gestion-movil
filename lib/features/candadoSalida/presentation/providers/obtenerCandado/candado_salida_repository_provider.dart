import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/candadoSalida/controller/datasources/candado_salida_datasource_impl.dart';
import 'package:gestion_movil/features/candadoSalida/controller/repositories/candado_salida_repository_impl.dart';
import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';
import 'package:gestion_movil/features/login/login.dart';

final candadoSalidadRepositoryProvider = Provider<CandadoSalidaRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final candadoSalidaRepository = CandadoSalidaRepositoryImpl(CandadoSalidaDatasourceImpl(accessToken: accessToken));

  return candadoSalidaRepository;
});
