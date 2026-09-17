import 'package:gestion_movil/conf/errors/results.dart';
import 'package:gestion_movil/features/cambiarcontrasenia/domain/datasources/cambiar_contrasenia_datasource.dart';
import 'package:gestion_movil/features/cambiarcontrasenia/domain/entities/controlmovil.dart';
import 'package:gestion_movil/features/cambiarcontrasenia/domain/repositories/cambiar_contrasenia_repository.dart';

import '../../../../conf/errors/custom_error.dart';
import '../../../../conf/errors/custom_exception.dart';
import '../../../../conf/errors/error_mapper.dart';

class CambiarContraseniaRepositoryImpl extends CambiarContraseniaRepository {
  final CambiarContraseniaDatasource datasource;

  CambiarContraseniaRepositoryImpl(this.datasource);

  @override
  Future<Results<ControlMovil>> cambiarPalabra(String palabra) async {
    try {
      final resultado = await datasource.cambiarPalabra(palabra);
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }
}
