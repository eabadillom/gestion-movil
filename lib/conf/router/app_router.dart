import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/posiciones/presentation/screens/posiciones_pdf_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/posiciones/presentation/screens/screens.dart';
import 'package:gestion_movil/features/dashboard/presentation/screens/dashbord_screen.dart';
import 'package:gestion_movil/features/login/login.dart';

import '../../features/constancia_deposito/presentation/screens/screens.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider((ref) 
{
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  final usuarioDetalleState = ref.watch(usuarioDetalleProvider).usuarioDetalle;
  final LoggerSingleton log = LoggerSingleton.getInstance('GoRouterProvider');
  log.setupLoggin();
  
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/dashboard',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla de validación de datos
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckLoginStatusScreen(),
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

      ///* Constancia de depósito
      GoRoute(
        path: '/kardex',
        builder: (context, state) {
          final numUsuario = usuarioDetalleState!.numeroUsuario;
          return KardexScreen(numUsuario: numUsuario);
        },
      ),

      ///* Reporte Kardex PDF
      GoRoute(
        path: '/kardexPdf',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return KardexPdfScreen(folioCliente: data['folioCliente']);
        },
      ),
    ],

    redirect: (context, state) 
    {
      final isGoingTo = state.matchedLocation;
      final loginStatus = goRouterNotifier.loginStatus;

      //Pantalla de inicio de aplicacion dashboard
      if (isGoingTo == '/splash') {
        if (loginStatus == LoginStatus.authenticated) {
          return '/dashboard';
        }

        if (loginStatus == LoginStatus.notAuthenticated) {
          return '/login';
        }
      }

      //Pantalla de login y cuando el usuario no esta autenticado
      if (loginStatus == LoginStatus.notAuthenticated) {
        return isGoingTo == '/login' ? null : '/login';
      }

      if (loginStatus == LoginStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/splash') {
          return '/dashboard';
        }
      }
      return null;
    },
  );
});
