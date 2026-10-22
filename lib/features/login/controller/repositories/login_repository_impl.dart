import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/login/controller/controller.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

class LoginRepositoryImpl
{
  LoginDatasourceImpl loginDatasourceImpl;

  LoginRepositoryImpl({LoginDatasourceImpl? loginDatasourceImpl}) : loginDatasourceImpl = loginDatasourceImpl ?? LoginDatasourceImpl();

  Future<Results<int>> checkTokenStatus(String token) async
  {
    try {
      final resultado = await loginDatasourceImpl.checkTokenStatus(token);

      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

  Future<Results<LoginUsuario>> login(String numeroEmpleado, String nombre, String password) async
  {
    try {
      final resultado = await loginDatasourceImpl.login(numeroEmpleado, nombre, password);
    
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

  Future<Results<String>> deshabilitar(String token) async
  {
    try {
      final resultado = await loginDatasourceImpl.deshabilitar(token);
      
      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

  Future<Results<UsuarioDetalle>> obtenerUsuario(String accessToken, String numeroUsuario) async 
  {
    try {
      final resultado = await loginDatasourceImpl.obtenerUsuario(accessToken, numeroUsuario);

      return Success(resultado);
    } on CustomException catch (e) {
      return Error(ErrorMapper.mapException(e));
    } catch (_) {
      return const Error(UnknownError());
    }
  }

}