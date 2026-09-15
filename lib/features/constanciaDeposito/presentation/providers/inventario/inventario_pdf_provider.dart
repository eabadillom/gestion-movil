import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constanciaDeposito/controller/controller.dart';
import 'package:gestion_movil/features/login/login.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';

final inventarioPdfProvider = Provider<PdfRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final fileResponseRepository = PdfRepositoryImpl(PdfDatasourceImpl(accessToken: accessToken));
  
  return fileResponseRepository;
});
