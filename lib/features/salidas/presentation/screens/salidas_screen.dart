import 'package:gestion_movil/features/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/salidas/presentation/providers/providers.dart';

class SalidasScreen extends ConsumerStatefulWidget
{
  const SalidasScreen({super.key});

  @override
  ConsumerState<SalidasScreen> createState() => _SalidasState();
}

class _SalidasState extends ConsumerState<SalidasScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final panelController = DraggableScrollableController();

  Cliente? clienteSeleccionado;

  DateTime fechaInicio = DateTime.now();
  DateTime fechaFin = DateTime.now();

  @override
  void initState() 
  {
    super.initState();

    Future.microtask(() {
      ref.invalidate(salidasListProvider);
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final salidasState = ref.watch(salidasListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold( 
        key: _scaffoldKey,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Ordenes de Retiros', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: salidasState.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (salidasState.errorMessage != null && salidasState.errorMessage!.isNotEmpty)
                          SinResultadosBusqueda(texto: salidasState.errorMessage!, icono: Icons.error_outline_rounded, titulo: 'Ocurrió un error')
                        else if (salidasState.listSalidas.isEmpty)
                          EstadoInicialBusqueda(icono: Icons.manage_search_rounded, titulo: 'Consulta de Ordenes de Retiro', subtitulo: 'Desliza el panel inferior y utiliza los filtros para ver los registros disponibles.')
                        else ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
                            itemCount: salidasState.registrosPaginados.length,
                            itemBuilder: (_, i) {
                              final item = salidasState.registrosPaginados[i];
                              final theme = Theme.of(context);
                              final isDark = theme.brightness == Brightness.dark;
                              final colorScheme = theme.colorScheme;
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(22),
                                        onTap: item.folio.isEmpty ? null : () =>  context.push('/detalleSalida/${item.id}'),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(22),
                                            color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
                                            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                                            boxShadow: 
                                            [
                                              if (!isDark)
                                                BoxShadow(
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                  color: Colors.black.withValues(alpha: 0.05),
                                                ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: colorScheme.primary.withValues(alpha: 0.12),
                                                ),
                                                child: Icon(
                                                  Icons.local_shipping_outlined,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Folio: ${item.folio}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 15.5,
                                                        fontWeight: FontWeight.w700,
                                                        color: isDark ? Colors.white : Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      'Fecha salida: ${FormatUtil.stringToStandard(item.fechaSalida)} - ${item.horaSalida.format(context)}',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                        color: isDark ? Colors.white70 : Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:BorderRadius.circular(14),
                                                  color: Colors.red.withValues(alpha: .10),
                                                ),
                                                child: IconButton(
                                                  tooltip:'Detalle',
                                                  onPressed: item.folio.isEmpty ? null : () => context.push('/detalleSalida/${item.id}'),
                                                  icon: const Icon(
                                                    Icons.description_outlined,
                                                    color: Colors.redAccent,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                        
                        if (salidasState.totalPaginas > 1) 
                          PaginadoWidget(paginaActual: salidasState.paginaActual, paginaMostrada: salidasState.paginaMostrada, totalPaginas: salidasState.totalPaginas, 
                            onAnterior: salidasState.paginaActual > 1 ? () 
                            {
                              ref.read(salidasListProvider.notifier).cambiarPagina(salidasState.paginaActual - 1);
                            } : null,
                            onSiguiente: salidasState.paginaActual < salidasState.totalPaginas? () 
                            {
                              ref.read(salidasListProvider.notifier).cambiarPagina(salidasState.paginaActual + 1);
                            } : null
                          ),
                      ],
                    ),
                  ),
            ),
            DraggableScrollableSheet( /// PANEL DE FILTROS
              controller: panelController,
              initialChildSize: .45,
              minChildSize: .12,
              maxChildSize: .90,
              builder: (context, scrollController) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1), blurRadius: 10, spreadRadius: 1)
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white24 : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Filtros de búsqueda',
                              style: TextStyle(
                                fontSize: 20,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DropdownField<Cliente>( /// CLIENTES
                          label: 'Cliente',
                          icon: Icons.business_center_rounded,
                          value: clienteSeleccionado,
                          items: [
                            const DropdownMenuItem<Cliente>(value: null, child: Text('Todos los clientes')),
                            ...clienteState.clientes.map((e) => DropdownMenuItem(value: e, child: Text(e.nombre, overflow: TextOverflow.ellipsis))),
                          ],
                          onChanged: (val) => setState(() => clienteSeleccionado = val),
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
                        const SizedBox(height: 30),
                        ElevatedButton( /// BOTÓN BUSCAR
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: buscar,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_rounded),
                              SizedBox(width: 10),
                              Text('Consultar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Funciones de buscar
  Future<void> buscar() async 
  {
    await ref.read(salidasListProvider.notifier).obtenerSalidas(clienteSeleccionado?.id, fechaInicio, fechaFin);
    panelController.animateTo(.12, duration: const Duration(milliseconds: 400), curve: Curves.ease);
  }

  Future<void> seleccionarFechaInicio() async 
  {
    final hoy = DateTime.now();
    final fechaInicial = fechaInicio;

    final fecha = await customDatePicker(
      context: context,
      initialDate: fechaInicial.isAfter(hoy) ? hoy : fechaInicial,
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
    final fechaInicial = fechaInicio;
    final fechaActual = fechaFin;

    final fecha = await customDatePicker(
      context: context,
      initialDate: fechaActual.isAfter(hoy) ? hoy : fechaActual,
      firstDate: fechaInicial,
    );

    if (fecha != null) {
      setState(() => fechaFin = fecha);
    }
  }
  
}
