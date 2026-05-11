import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/constancia_deposito/controller/controller.dart';
import 'package:gestion_movil/features/login/login.dart';
import 'package:gestion_movil/features/constancia_deposito/domain/domain.dart';

final salidaPdfProvider = Provider<PdfRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final fileResponseRepository = PdfRepositoryImpl(PdfDatasourceImpl(accessToken: accessToken));
  
  return fileResponseRepository;
});