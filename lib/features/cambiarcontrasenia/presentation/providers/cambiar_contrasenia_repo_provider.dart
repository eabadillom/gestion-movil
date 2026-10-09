import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../login/presentation/providers/login_provider.dart';
import '../../controller/datasources/cambiar_contrasenia_datasource_impl.dart';
import '../../controller/repositories/cambiar_contrasenia_repository_impl.dart';
import '../../domain/repositories/cambiar_contrasenia_repository.dart';

final cambiarContraseniaRepoProvider = Provider<CambiarContraseniaRepository>((
  ref,
) {
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final cambiarContraseniaRepository = CambiarContraseniaRepositoryImpl(
    CambiarContraseniaDatasourceImpl(accessToken: accessToken),
  );
  return cambiarContraseniaRepository;
});
