import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/login/login.dart';
import 'package:gestion_movil/features/salidas/controller/controller.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';

final salidaProvider = Provider<SalidasRepository> ((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final salidaDetalleRepository = SalidasRepositoryImpl(SalidasDatasourceImpl(accessToken: accessToken));

  return salidaDetalleRepository;
});