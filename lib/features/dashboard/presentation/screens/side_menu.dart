import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:gestion_movil/features/login/presentation/providers/login_provider.dart';
import 'package:gestion_movil/features/plantas/presentation/providers/providers.dart';
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
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor;
    final String fechaHoy = FormatUtil.fechaHoy();
    final nombreCompleto = '${usuarioDetalleState?.nombreUsuario ?? ''} ${usuarioDetalleState?.primerApUsuario ?? ''} ${usuarioDetalleState?.segundoApUsuario ?? ''}';
    final puesto = (usuarioDetalleState?.puesto ?? '').toUpperCase();

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
            color: appBarColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.person_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              Text('Bienvenido', style: textStyles.titleMedium?.copyWith(color: Colors.white, fontSize: 24)),
              const SizedBox(height: 18),
              Text("Sistema de Inventarios,\nFacturación y Cobranza", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontStyle: FontStyle.italic, fontSize: 15, height: 1.5, letterSpacing: 0.5)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  fechaHoy,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Padding(// 2. INFORMACIÓN DEL USUARIO
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                nombreCompleto.trim(),
                textAlign: TextAlign.center,
                style: textStyles.titleSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  puesto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Divider(color: Colors.amber, thickness: 1.1),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Consumer( 
                  builder: (context, ref, child) 
                  {
                    final isLoading = ref.watch(clienteNotifierProvider).isLoading;
                    return CustomFilledButton(
                      onPressed: isLoading  ? null : 
                      () async {
                        await ref.read(clienteNotifierProvider.notifier).refreshClientes();
                        await Future.delayed(const Duration(seconds: 1));
                        await ref.read(plantaNotifierProvider.notifier).refreshPlantas(usuarioDetalleState!.numeroUsuario);

                        if (context.mounted) {
                          CustomSnackBarCentrado.mostrar(
                            context,
                            mensaje: 'Se ha sincronizando correctamente',
                            tipo: SnackbarTipo.success,
                          );
                        }
                      },
                      text: isLoading ? 'Sincronizando...' : 'Sincronizar Catálogos',
                      icon: isLoading ? Icons.hourglass_empty : Icons.refresh,
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Divider(color: Colors.amber, thickness: 1.1),
        ),

        Padding(// 3. SECCIÓN DE ACCIONES (Botón de Cerrar Sesión)
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                      tipo: mensaje.toLowerCase().contains('fallo') ? SnackbarTipo.error : SnackbarTipo.success,
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
