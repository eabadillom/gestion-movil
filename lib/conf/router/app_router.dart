import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/login/login.dart';
import 'package:gestion_movil/features/posiciones/presentation/screens/screens.dart';
import 'package:gestion_movil/features/candadoSalida/presentation/screens/screens.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/constanciaDeposito/presentation/screens/screens.dart';
import 'package:gestion_movil/features/dashboard/presentation/screens/dashbord_screen.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/dashboard/presentation/screens/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider((ref) 
{
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  final usuarioDetalleState = ref.watch(usuarioDetalleProvider).usuarioDetalle;
  final LoggerSingleton log = LoggerSingleton.getInstance('GoRouterProvider');
  log.setupLoggin();
  
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla de validación de datos
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login', 
        builder: (context, state) => const LoginScreen()
      ),

      ///* Dashboard
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashbordScreen(),
      ),

      ///* Posiciones por planta
      GoRoute(
        path: '/posiciones',
        builder: (context, state) { 
          final numUsuario = usuarioDetalleState!.numeroUsuario;
          return PosicionesPlantaScreen(numUsuario: numUsuario);
        },
      ),

      ///* Reporte Posiciones PDF
      GoRoute(
        path: '/reportePosiciones',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return PosicionesPdfScreen(
            fechaConsulta: data['fechaConsulta'],
            numUsuario: data['numUsuario'],
            idsSeleccionados: data['idsSeleccionados'],
          );
        },
      ),

      ///* Kardex
      GoRoute(
        path: '/kardex',
        builder: (context, state) {
          final numUsuario = usuarioDetalleState!.numeroUsuario;
          return KardexScreen(numUsuario: numUsuario);
        },
      ),

      ///* Reporte del Kardex PDF
      GoRoute(
        path: '/kardexPdf',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return KardexPdfScreen(folioCliente: data['folioCliente']);
        },
      ),

      ///* Consulta de Entradas
      GoRoute(
        path: '/entradas',
        builder: (context, state) {
          final numUsuario = usuarioDetalleState!.numeroUsuario;
          return EntradaScreen(numUsuario: numUsuario);
        },
      ),

      ///* Reporte de Entrada PDF
      GoRoute(
        path: '/entradaPdf',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return EntradaPdfScreen(fechaInicio: data['fechaInicio'], fechaFin: data['fechaFin'], idCliente: data['idCliente'], idPlanta: data['idPlanta'], idCamara: data['idCamara']);
        },
      ),

      ///* Consulta de Salidas
      GoRoute(
        path: '/salidas',
        builder: (context, state) {
          final numUsuario = usuarioDetalleState!.numeroUsuario;
          return SalidaScreen(numUsuario: numUsuario);
        },
      ),

      ///* Reporte de Salida PDF
      GoRoute(
        path: '/salidaPdf',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return SalidaPdfScreen(fechaInicio: data['fechaInicio'], fechaFin: data['fechaFin'], idCliente: data['idCliente'], idPlanta: data['idPlanta'], idCamara: data['idCamara']);
        },
      ),
      
      ///* Consulta de Inventarios
      GoRoute(
        path: '/inventarios',
        builder: (context, state) {
          final numUsuario = usuarioDetalleState!.numeroUsuario;
          return InventarioScreen(numUsuario: numUsuario);
        },
      ),

      ///* Reporte de Inventario PDF
      GoRoute(
        path: '/inventarioPdf',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return InventarioPdfScreen(fecha: data['fecha'], idCliente: data['idCliente'], idPlanta: data['idPlanta']);
        },
      ),

      ///* Consulta de Candado de Salida
      GoRoute(
        path: '/candadoSalida',
        builder: (context, state) {
          return CandadoSalidaScreen();
        },
      ),

      ///* Detalle de Candado de Salida
      GoRoute(
        path: '/detalleCandadoSalida',
        builder: (context, state) {
          Cliente cliente = state.extra as Cliente;
          return CandadoSalidaDetalleScreen(cliente: cliente);
        },
      ),
      
    ],

    redirect: (context, state) 
    {
      final location = state.matchedLocation;
      final loginStatus = goRouterNotifier.loginStatus;

      final isGoingToLogin = location == '/login';
      final isGoingToSplash = location == '/splash';

      if (loginStatus == LoginStatus.notAuthenticated) // Usuario NO autenticado
      {
        return isGoingToLogin ? null : '/login';
      }

      if (loginStatus == LoginStatus.authenticated) // Usuario autenticado
      {
        if (isGoingToLogin || isGoingToSplash)
        {
          return '/dashboard';
        }
      }

      return null;
    },
  );
});
