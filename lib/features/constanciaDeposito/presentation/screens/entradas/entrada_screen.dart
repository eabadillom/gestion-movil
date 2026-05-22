import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/camaras/domain/domain.dart';
import 'package:gestion_movil/features/camaras/presentation/providers/camara_list_repository_provider.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';
import 'package:gestion_movil/features/plantas/presentation/providers/providers.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class EntradaScreen extends ConsumerStatefulWidget 
{
  final String numUsuario;

  const EntradaScreen({super.key, required this.numUsuario});

  @override
  ConsumerState<EntradaScreen> createState() => _EntradaScreenState();
}

class _EntradaScreenState extends ConsumerState<EntradaScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Cliente? clienteSeleccionado;
  Planta? plantaSeleccionada;
  Camara? camaraSeleccionada;

  DateTime fechaInicio = FormatUtil.dateFormated(DateTime.now().subtract(const Duration(days: 7)));
  DateTime fechaFin = DateTime.now();

  @override
  void initState() 
  {
    super.initState();

    Future.microtask(() 
    {
      ref.read(plantaNotifierProvider.notifier).cargarPlantas(widget.numUsuario);
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final camaraState = ref.watch(camaraNotifierProvider);
    final plantaState = ref.watch(plantaNotifierProvider);
    final usuario = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    List<DropdownMenuItem<Planta?>> plantasItems = _buildPlantasItems(usuario, plantaState);
    final bool valorExiste = plantaState.plantas.any((p) => p.id == plantaSeleccionada?.id);
    final isCamaraEnabled = plantaSeleccionada != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if ((usuario?.perfil == 1 || usuario?.perfil == 4) && plantaSeleccionada == null && plantaState.plantas.isNotEmpty) 
    {
      Future.microtask(() 
      {
        setState(() {
          plantaSeleccionada = plantaState.plantas.first;
        });

        ref.read(camaraNotifierProvider.notifier).obtenerRegistros(plantaSeleccionada?.id);
      });
    } 

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Consulta de entradas', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      onChanged: (usuario?.perfil != 1 || usuario?.perfil != 4) ? null : _onPlantaChanged,
                    ),

                    const SizedBox(height: 16),

                    Opacity(
                      opacity: isCamaraEnabled ? 1.0 : 0.5,
                      child: DropdownField<Camara?>( /// CAMARAS
                        label: 'Camaras',
                        icon: isCamaraEnabled ? Icons.ac_unit : Icons.lock_outline,
                        value: camaraSeleccionada,
                        items: [
                          const DropdownMenuItem<Camara>(value: null, child: Text('Todas las camaras')),
                          ...camaraState.listCamaras.map((e) => DropdownMenuItem(value: e, child: Text(e.descripcion, overflow: TextOverflow.ellipsis))),
                        ],
                        onChanged: isCamaraEnabled ? (val) => setState(() => camaraSeleccionada = val) : null,
                      ),
                    ),
  
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
  
                    Row( /// FECHAS EN FILA
                      children: [
                        Expanded(
                          child: DateTileWidget(
                            label: 'Desde',
                            date: FormatUtil.dateFormated(fechaInicio),
                            onTap: seleccionarFechaInicio,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DateTileWidget(
                            label: 'Hasta',
                            date: FormatUtil.dateFormated(fechaFin),
                            onTap: seleccionarFechaFin,
                          ),
                        ),
                      ],
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
                        context.push('/entradaPdf', extra: {'fechaInicio': fechaInicio, 'fechaFin': fechaFin, 'idCliente': clienteSeleccionado?.id, 'idPlanta': plantaSeleccionada?.id, 'idCamara': camaraSeleccionada?.id});
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

  Future<void> seleccionarFechaInicio() async 
  {
    final hoy = DateTime.now();

    final fecha = await customDatePicker(
      context: context,
      initialDate: fechaInicio.isAfter(hoy) ? hoy : fechaInicio,
      firstDate: DateTime(2020),
      lastDate: hoy,
    );

    if (fecha != null) {
      setState(() {
        fechaInicio = fecha;

        if (fechaFin.isBefore(fechaInicio)) {
          fechaFin = fechaInicio;
        }
      });
    }
  }

  Future<void> seleccionarFechaFin() async 
  {
    final hoy = DateTime.now();

    final fecha = await customDatePicker(
      context: context,
      initialDate: fechaFin.isAfter(hoy) ? hoy : fechaFin,
      firstDate: fechaInicio,
      lastDate: hoy,
    );

    if (fecha != null) {
      setState(() => fechaFin = fecha);
    }
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
      camaraSeleccionada = null;
    });

    if (val?.id != null) {
      ref.read(camaraNotifierProvider.notifier).obtenerRegistros(val!.id);
    }
  }

}
