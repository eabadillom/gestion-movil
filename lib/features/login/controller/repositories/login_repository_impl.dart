import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/login/controller/controller.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

class LoginRepositoryImpl extends LoginRepository
{
  final LoginDatasource dataSource;

  LoginRepositoryImpl({
    LoginDatasource? dataSource
  }) : dataSource = dataSource ?? LoginDatasourceImpl();

  @override
  Future<Results<int>> checkTokenStatus(String token) async
  {
    try {
      final resultado = await dataSource.checkTokenStatus(token);

      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

  @override
  Future<Results<LoginUsuario>> login(String numeroEmpleado, String nombre, String password) async
  {
    try {
      final resultado = await dataSource.login(numeroEmpleado, nombre, password);
    
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

  @override
  Future<Results<String>> deshabilitar(String token) async
  {
    try {
      final resultado = await dataSource.deshabilitar(token);
      
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

}