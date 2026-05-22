import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constanciaDeposito/controller/controller.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';
import 'package:gestion_movil/features/login/login.dart';

final kardexListProvider = Provider<ConstanciaDepositoRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final constanciaDepositoRepository = ConstanciaDepositoRepositoryImpl(ConstanciaDepositoDatasourceImpl(accessToken: accessToken));
  
  return constanciaDepositoRepository;
});
