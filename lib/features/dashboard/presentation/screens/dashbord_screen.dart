import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/dashboard/presentation/screens/side_menu.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

class DashbordScreen extends ConsumerStatefulWidget 
{
  static const name = 'dashboard_screen';
  const DashbordScreen({super.key});

  @override
  ConsumerState<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends ConsumerState<DashbordScreen> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('DashbordScreen');
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UsuarioDetalle? usuario;

  @override
  void initState()
  {
    super.initState();
    
    Future.microtask(() {
      ref.read(clienteNotifierProvider.notifier).loadClientes();
    });
  }

  Future<bool> _confirmarSalida() async 
  {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estas seguro que quieres salir de la app?', style: TextStyle(fontSize: 16.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) 
  {
    usuario = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final isDarkmode = ref.watch(themeNotifierProvider).isDarkmode;
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async 
      {
        final salir = await _confirmarSalida();
        if (salir) {
          if(!context.mounted) return;

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            // Estamos en la última pantalla, cerramos la app
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey, 
        appBar: AppBar(
          title: const Text('Dashboard', textAlign: TextAlign.center,),
          actions: [
            IconButton(
              icon: Icon(
                isDarkmode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              onPressed: () {
                ref.read(themeNotifierProvider.notifier).toggleDarkmode();
              },
            ),
          ],
        ),
        body: _DashboardView(usuarioDetalle: usuario),
        drawer: SideMenu(scaffoldKey: scaffoldKey),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget 
{
  final UsuarioDetalle? usuarioDetalle;
  
  const _DashboardView({required this.usuarioDetalle});

  @override
  Widget build(BuildContext context) 
  {
    final menuItems = obtenerMenuItems(usuarioDetalle);

    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220, // Mejor para que escale en tablets
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.2, // relación ancho/alto para ListTile
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = menuItems[index];
        return Card(elevation: 2, child: CustomListTile(menuItem: menuItem));
      },
    );
  }
}

class CustomListTile extends StatelessWidget 
{
  const CustomListTile({super.key, required this.menuItem});

  final MenuItems menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push(menuItem.link),
      splashColor: colors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              menuItem.icon, 
              color: colors.primary,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              menuItem.title, 
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w500
              ), 
              textAlign: TextAlign.center
            ),
          ],
        ),
      ),
    );
  }
}
