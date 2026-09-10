import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/login/presentation/providers/login_provider.dart';
import 'package:gestion_movil/features/plantas/presentation/providers/providers.dart';

final goRouterNotifierProvider = ChangeNotifierProvider((ref) 
{
  final loginNotifier = ref.read(loginProvider.notifier);

  final notifier = GoRouterNotifier(ref, loginNotifier);

  ref.onDispose(notifier.dispose);

  return notifier;
});

class GoRouterNotifier extends ChangeNotifier with WidgetsBindingObserver
{
  final LoginNotifier _loginNotifier;
  final Ref _ref;

  LoginStatus _loginStatus = LoginStatus.checking;
  
  bool _appFuePausada = false;
  bool _debeIrAlDashboard = false;
  bool _validandoSesion = false;

  GoRouterNotifier(this._ref, this._loginNotifier) 
  {
    WidgetsBinding.instance.addObserver(this);

    _loginNotifier.addListener((state) 
    {
      loginStatus = state.loginStatus;
    });
  }

  LoginStatus get loginStatus => _loginStatus;

  set loginStatus(LoginStatus value) 
  {
    if (_loginStatus != value) {
      _loginStatus = value;
      notifyListeners();
    }
  }

  bool get debeIrAlDashboard => _debeIrAlDashboard;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) 
  {
    if (state == AppLifecycleState.paused) {
      _appFuePausada = true;
      return;
    }

    if (state == AppLifecycleState.resumed && _appFuePausada) {
      _appFuePausada = false;

      _validarSesionAlRegresar();
    }
  }

  Future<void> _validarSesionAlRegresar() async 
  {
    if (_validandoSesion) {
      return;
    }

    if (_loginStatus != LoginStatus.authenticated) {
      return;
    }

    _validandoSesion = true;

    try {
      await _loginNotifier.checkLoginStatus();
      final usuarioDetalleState = _ref.watch(usuarioDetalleProvider).usuarioDetalle;
      await _ref.read(clienteNotifierProvider.notifier).refreshClientes();
      await _ref.read(plantaNotifierProvider.notifier).refreshPlantas(usuarioDetalleState!.numeroUsuario);
    } finally {
      _validandoSesion = false;
    }
  }

  void consumirRedireccionDashboard() {
    _debeIrAlDashboard = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

}