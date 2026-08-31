import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';
import 'package:gestion_movil/features/login/controller/controller.dart';
import 'package:gestion_movil/features/shared/shared.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) 
{
  final loginRepository = LoginRepositoryImpl();

  return LoginNotifier(loginRepository: loginRepository, ref: ref);
});

class LoginNotifier extends StateNotifier<LoginState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('LoginProvider'); 
  final storage = SecureStorageService();
  final LoginRepository loginRepository;
  final Ref ref;

  LoginNotifier({required this.loginRepository, required this.ref}): super(
    LoginState()){checkLoginStatus();
  } 

  Future<void> loginUser(String numeroEmpleado, String nombre, String contrasenia) async 
  {
    await Future.delayed(const Duration(milliseconds: 500));
    log.setupLoggin();

    log.logger.info('Inicio Sesion');
    final Usuario usuario = Usuario(numeroEmpleado: numeroEmpleado, nombre: nombre, contrasenia: contrasenia);
    
    final resultado = await loginRepository.login(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
    
    switch (resultado) {
      case Success():
        final LoginUsuario loginUsuario = resultado.data;
        final Token token = Token(accessToken: loginUsuario.accessToken, refreshToken: loginUsuario.refreshToken);
        final UsuarioDetalle usuarioDetalle = UsuarioDetalle(numeroUsuario: loginUsuario.numeroUsuario, nombreUsuario: loginUsuario.nombreUsuario, primerApUsuario: loginUsuario.primerApUsuario, segundoApUsuario: loginUsuario.segundoApUsuario, puesto: loginUsuario.puesto, perfil: loginUsuario.perfil);
        ref.read(usuarioDetalleProvider.notifier).setUsuarioDetalle(usuarioDetalle);
        _setLoggedUser(token, usuario);

      case Error():
        log.logger.warning('Error: ${resultado.customError.message}');
        state = state.copyWith(
          loginStatus: LoginStatus.notAuthenticated,
          usuario: null,
          token: null,
          errorMessage: resultado.customError.message,
        );
    }
    
  }

  void checkLoginStatus() async 
  {
    log.setupLoggin();
    log.logger.info('Validando estatus');
    final data = await obtenerDatosUsuario();

    if (data.faltaInfo) {
      log.logger.info('No hay información del usuario');
      return logout();
    }

    final Usuario usuario = Usuario(numeroEmpleado: data.numeroEmpleado!, nombre: data.nombre!, contrasenia: data.contrasenia!);
    final resultado = await loginRepository.login(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
    
    switch (resultado) {
      case Success():
        if (data.hayTokens && !data.faltaInfo) {
          final statusToken = await loginRepository.checkTokenStatus(data.accessToken!);
          switch(statusToken){
            case Success():
              log.logger.info('Tokens válidos, re-autenticando usuario.');
              await _nuevaSesion(data, usuario, resultado.data);
            case Error():
              /*return logout();*/
              log.logger.info('No hacer nada.');
          }  
        }
      
        if(!data.hayTokens && !data.faltaInfo) {
          log.logger.info('Tokens inválidos o no existen, realizando nuevo login.');
          await _nuevaSesion(data, usuario, resultado.data);
        }

        if(!data.hayTokens && data.faltaInfo){
          log.logger.info('No hay tokens ni usuario');
          return logout();
        }
      case Error():
        log.logger.warning('Error en la autenticación: ${resultado.customError.message}');

        final msg = resultado.customError.message.toLowerCase();

        final esErrorDeRed = msg.contains('socketexception') || 
                             msg.contains('Connection refused') || 
                             msg.contains('network') ||
                             msg.contains('no disponible');

        if (esErrorDeRed && data.hayTokens) {
          log.logger.info('Sin acceso a internet, pero hay información del usuario.');
          final Token tokenExistente = Token(accessToken: data.accessToken!, refreshToken: data.refreshToken!);

          state = state.copyWith(
            usuario: usuario,
            token: tokenExistente,
            loginStatus: LoginStatus.notAuthenticated,
            errorMessage: 'No hay conexión a internet, vuelva a intentar mas tarde'
          );

          return;
        }

        log.logger.severe('Error: el usuario/contraseña o el token han cambiado. Cerrando sesión.');
        logout(resultado.customError.message);
    }
    
  }

  Future<void> _nuevaSesion(UserLogData data, Usuario usuario, LoginUsuario loginUsuario) async 
  {
    final Token token = Token(accessToken: loginUsuario.accessToken, refreshToken: loginUsuario.refreshToken);

    await _configurarDetalleUsuario(loginUsuario);
    _setLoggedUser(token, usuario);
  }

  Future<void> _configurarDetalleUsuario(LoginUsuario loginUsuario) async 
  {
    final usuarioDetalle = UsuarioDetalle(
      numeroUsuario: loginUsuario.numeroUsuario,
      nombreUsuario: loginUsuario.nombreUsuario,
      primerApUsuario: loginUsuario.primerApUsuario,
      segundoApUsuario: loginUsuario.segundoApUsuario,
      puesto: loginUsuario.puesto,
      perfil: loginUsuario.perfil
    );
    ref.read(usuarioDetalleProvider.notifier).setUsuarioDetalle(usuarioDetalle);
  }

  void _setLoggedUser(Token token, Usuario usuario) async
  {
    log.setupLoggin();
    await storage.write(key: 'token', value: token.accessToken);
    await storage.write(key: 'tokenRe', value: token.refreshToken);
    await storage.write(key: 'numeroEmpleado', value: usuario.numeroEmpleado);
    await storage.write(key: 'nombre', value: usuario.nombre);
    await storage.write(key: 'contrasenia', value: usuario.contrasenia);

    log.logger.info('Usuario ingresado correctamente');
    state = state.copyWith(
      usuario: usuario,
      token: token,
      loginStatus: LoginStatus.authenticated,
      errorMessage: ''
    );
  }

  Future<void> logout([String? errorMessage]) async 
  {
    await storage.delete(key: 'token');
    await storage.delete(key: 'tokenRe');
    await storage.delete(key: 'numeroEmpleado');
    await storage.delete(key: 'nombre');
    await storage.delete(key: 'contrasenia');

    state = state.copyWith(
      loginStatus: LoginStatus.notAuthenticated,
      usuario: null,
      token: null,
      errorMessage: errorMessage
    );
  }

  Future<String> deshabilitar() async 
  {
    String mensaje = 'Sesión cerrada';
    final UserLogData data = await obtenerDatosUsuario();

    if(data.faltaInfo || !data.hayTokens)
    {
      log.logger.warning('Error al obtener datos de la sesión');
      return "Fallo al cerrar sesión";
    }

    final resultado = await loginRepository.deshabilitar(data.accessToken!);

    switch (resultado) {
      case Success():
        mensaje = resultado.data;
        final Usuario usuario = Usuario(numeroEmpleado: data.numeroEmpleado!, nombre: data.nombre!, contrasenia: data.contrasenia!);
        final Token token = Token(accessToken: data.accessToken!, refreshToken: data.refreshToken!);
          
        if (mensaje.contains('Problema de red')) {
          log.logger.info('Red: $mensaje');
          state = state.copyWith(
            loginStatus: LoginStatus.authenticated,
            token: token,
            usuario: usuario,
            errorMessage: mensaje,
          );
          return mensaje;
        }

        logout();
        return mensaje;
      case Error():
        final String accessToken = await storage.read(key: 'token') ?? '';
        final String refreshToken = await storage.read(key: 'tokenRe') ?? '';
        final String numeroEmpleado = await storage.read(key: 'numeroEmpleado') ?? '';
        final String nombre = await storage.read(key: 'nombre') ?? '';
        final String contrasenia = await storage.read(key: 'contrasenia') ?? '';

        final Token token = Token(accessToken: accessToken, refreshToken: refreshToken);
        final Usuario usuario = Usuario(numeroEmpleado: numeroEmpleado, nombre: nombre, contrasenia: contrasenia);
        state = state.copyWith(
          loginStatus: LoginStatus.authenticated,
          token: token,
          usuario: usuario,
          errorMessage: 'Fallo al cerrar sesión',
        );

        return "Fallo al cerrar sesión";
    }

  }

}

enum LoginStatus {checking, authenticated, notAuthenticated}

class LoginState 
{
  final LoginStatus loginStatus;
  final Usuario? usuario;
  final Token? token;
  final String errorMessage;

  LoginState({
    this.loginStatus = LoginStatus.checking, 
    this.usuario,
    this.token,
    this.errorMessage = ''
  });

  LoginState copyWith({
    LoginStatus? loginStatus,
    Usuario? usuario,
    Token? token,
    String? errorMessage,
  }) => LoginState(
    loginStatus: loginStatus ?? this.loginStatus,
    usuario: usuario ?? this.usuario,
    token: token ?? this.token,
    errorMessage: errorMessage ?? this.errorMessage
  );

}
