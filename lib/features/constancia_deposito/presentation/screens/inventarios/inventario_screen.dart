import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';
import 'package:gestion_movil/features/plantas/presentation/providers/providers.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class InventarioScreen extends ConsumerStatefulWidget
{
  final String numUsuario;

  const InventarioScreen({super.key, required this.numUsuario});

  @override
  ConsumerState<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends ConsumerState<InventarioScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Cliente? clienteSeleccionado;
  Planta? plantaSeleccionada;

  DateTime fecha = DateTime.now();

  @override
  void initState() 
  {
    super.initState();

    Future.microtask(() 
    {
      ref.read(clienteNotifierProvider.notifier).cargarClientes();
      ref.read(plantaNotifierProvider.notifier).cargarPlantas(widget.numUsuario);
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final plantaState = ref.watch(plantaNotifierProvider);
    final usuario = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    List<DropdownMenuItem<Planta?>> plantasItems = _buildPlantasItems(usuario, plantaState);
    final bool valorExiste = plantaState.plantas.any((p) => p.id == plantaSeleccionada?.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if ((usuario?.perfil == 1 || usuario?.perfil == 4) && plantaSeleccionada == null && plantaState.plantas.isNotEmpty) 
    {
      Future.microtask(() 
      {
        setState(() {
          plantaSeleccionada = plantaState.plantas.first;
        });
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Consulta de inventario', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownField<Cliente>( /// CLIENTES
                      label: 'Clientes',
                      icon: Icons.business_center_rounded,
                      value: clienteSeleccionado,
                      items: [
                        const DropdownMenuItem<Cliente>(value: null, child: Text('Todos los clientes')),
                        ...clienteState.clientes.map((e) => DropdownMenuItem(value: e, child: Text(e.nombre, overflow: TextOverflow.ellipsis))),
                      ],
                      onChanged: (val) => setState(() => clienteSeleccionado = val),
                    ),
  
                    const SizedBox(height: 16),
  
                    DropdownField<Planta?>( /// PLANTAS
                      label: 'Plantas',
                      icon: Icons.factory_rounded,
                      value: valorExiste ? plantaSeleccionada : null,
                      items: plantasItems,
                      onChanged: (usuario?.perfil == 1 && usuario?.perfil == 4) ? null : _onPlantaChanged,
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    ElevatedButton( /// BOTÓN CONSULTAR PDF
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.push('/inventarioPdf', extra: {'fecha': fecha, 'idCliente': clienteSeleccionado?.id, 'idPlanta': plantaSeleccionada?.id});
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_rounded),
                          SizedBox(width: 10),
                          Text('Consultar PDF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Planta?>> _buildPlantasItems(UsuarioDetalle? usuario, PlantaState plantaState) 
  {
    final items = plantaState.plantas.map(
      (e) => DropdownMenuItem<Planta?>(
        value: e,
        child: Text(
          e.descripcion,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ).toList();

    if (usuario?.perfil != 1 || usuario?.perfil != 4) {
      items.insert(
        0,
        const DropdownMenuItem<Planta?>(
          value: null,
          child: Text('Todas las plantas'),
        ),
      );
    }

    return items;
  }

  void _onPlantaChanged(Planta? val) 
  {
    setState(() { 
      plantaSeleccionada = val;
    });
  }

}
