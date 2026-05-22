import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/shared/shared.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/posiciones/presentation/providers/providers.dart';

class PosicionesPlantaScreen extends ConsumerStatefulWidget 
{
  final String numUsuario;
  const PosicionesPlantaScreen({super.key, required this.numUsuario});

  @override
  ConsumerState<PosicionesPlantaScreen> createState() => _PosicionesPlantaState();
}

class _PosicionesPlantaState extends ConsumerState<PosicionesPlantaScreen> 
{
  final DraggableScrollableController panelController = DraggableScrollableController();
  List<int> _idsSeleccionados = [];
  List<Cliente> _clientesSeleccionados = [];
  late DateTime fechaConsulta;

  @override
  void initState() 
  {
    super.initState();
    fechaConsulta = FormatUtil.dateFormated(DateTime.now());
    Future.microtask(() {
      _cargarDatos();
    });
  }

  void _cargarDatos() {
    ref.read(posicionesNotifierProvider.notifier).cargarPosicionesPlanta(fechaConsulta, widget.numUsuario, _idsSeleccionados);
  }

  @override
  Widget build(BuildContext context) 
  {
    final posicionesState = ref.watch(posicionesNotifierProvider);
    final clientesState = ref.watch(clienteNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Posiciones por Planta', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: (widget.numUsuario.isEmpty) ? null : () => context.push('/reportePosiciones', extra: {
                'fechaConsulta': fechaConsulta,
                'numUsuario': widget.numUsuario,
                'idsSeleccionados': _idsSeleccionados,
              }),
              icon: const Icon(Icons.picture_as_pdf_rounded),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(child: ResultadosPosiciones(state: posicionesState)),
      
            DraggableScrollableSheet(
              controller: panelController,
              initialChildSize: 0.15,
              minChildSize: 0.12,
              maxChildSize: 0.65,
              builder: (context, scrollController) 
              {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1), 
                        blurRadius: 10, 
                        spreadRadius: 2
                      )
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      Center(
                        child: Container(
                          width: 40, height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.grey.shade300, 
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
      
                      Row(
                        children: [
                          Icon(Icons.search_rounded, color: colorScheme.primary, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            "Filtros de Búsqueda", 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87
                            )
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 16),
                      
                      ClientesMultiSelect(clientes: clientesState.clientes, onConfirm: (seleccionados) 
                      {
                        setState(() {
                          _clientesSeleccionados = seleccionados;
                          _idsSeleccionados = seleccionados.map((e) => e.id).toList();
                        });
                        _cargarDatos();
                      }),
      
                      if (_clientesSeleccionados.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        SelectionHeader(onLimpiar: () 
                          {
                            setState(() {
                              _clientesSeleccionados.clear();
                              _idsSeleccionados.clear();
                            });
                            _cargarDatos();
                          }
                        ),
                        const SizedBox(height: 10),
                        SelectedClients(clientes: _clientesSeleccionados,
                          onEliminar: (cliente) 
                          {
                            setState(() {
                              _clientesSeleccionados.remove(cliente);
                              _idsSeleccionados.remove(cliente.id);
                            });
                            _cargarDatos();
                          }
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
