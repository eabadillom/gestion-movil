import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:gestion_movil/features/login/presentation/providers/login_provider.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class SideMenu extends ConsumerStatefulWidget 
{
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> 
{
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) 
  {
    final usuarioDetalleState = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final String fechaHoy = FormatUtil.fechaHoy();

    return NavigationDrawer
    (
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) 
      {
        setState(() { navDrawerIndex = value; });

        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Container(// 1. ENCABEZADO ESTILO APPBAR
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 50 : 40, 20, 30),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor, // Cambia automático con tu AppTheme
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 60, color: Colors.white),
              const SizedBox(height: 10),
              Text('Bienvenido', style: textStyles.titleMedium?.copyWith(color: Colors.white, fontSize: 24)),
              const SizedBox(height: 20),
              Text("Sistema de Inventarios, Facturación y Cobranza", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 18)),
              const SizedBox(height: 20),
              Text(fechaHoy, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Padding(// 2. INFORMACIÓN DEL USUARIO
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                '${usuarioDetalleState?.nombreUsuario} ${usuarioDetalleState?.primerApUsuario} ${usuarioDetalleState?.segundoApUsuario}',
                style: textStyles.titleSmall?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                '${usuarioDetalleState?.puesto}'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  fontSize: 12
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(color: Colors.amber, thickness: 1.5),
        ),

        const SizedBox(height: 20),

        Padding(// 3. SECCIÓN DE ACCIONES (Botón de Cerrar Sesión)
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomFilledButton(
                  onPressed: () async {
                    final mensaje = await ref.read(loginProvider.notifier).deshabilitar();

                    widget.scaffoldKey.currentState?.closeDrawer();

                    if (!context.mounted) return;

                    CustomSnackBarCentrado.mostrar(
                      context,
                      mensaje: mensaje,
                      tipo: mensaje.toLowerCase().contains('fallo')
                          ? SnackbarTipo.error
                          : SnackbarTipo.success,
                    );

                    if (!mensaje.toLowerCase().contains('fallo')) {
                      context.go('/login');
                    }
                  },
                  text: 'Cerrar sesión',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}