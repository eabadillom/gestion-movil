import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/login/login.dart';
import 'package:gestion_movil/features/saldos/controller/controller.dart';
import 'package:gestion_movil/features/saldos/domain/domain.dart';

final validacionSaldoRepositoryProvider = Provider<ValidacionSaldoRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final validacionSaldoRepository = ValidacionSaldoRepositoryImpl(ValidacionSaldoDatasourceImpl(accessToken: accessToken));

  return validacionSaldoRepository;
});
