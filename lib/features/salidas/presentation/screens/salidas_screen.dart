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
  void dispose() {
    panelController.dispose();
    super.dispose();
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
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Órdenes de Retiro', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          scrolledUnderElevation: 2,
        ),
        body: Stack(
          children: [
            _buildMainContent(salidasState),
            _buildFilterSheet(context, isDark, clienteState),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(dynamic salidasState) 
  {
    if (salidasState.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (salidasState.errorMessage != null && salidasState.errorMessage!.isNotEmpty) {
      return Center(
        child: SinResultadosBusqueda(
          texto: salidasState.errorMessage!,
          icono: Icons.error_outline_rounded,
          titulo: 'Ocurrió un error',
        ),
      );
    }

    if (salidasState.listSalidas.isEmpty) {
      return const Align(
        alignment: Alignment(0, -0.25),
        child: EstadoInicialBusqueda(
          icono: Icons.manage_search_rounded,
          titulo: 'Consulta de Órdenes de Retiro',
          subtitulo: 'Desliza el panel inferior y utiliza los filtros para ver los registros disponibles.',
        ),
      );
    }

    return Positioned.fill(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
        itemCount: salidasState.registrosPaginados.length + 1,
        itemBuilder: (context, index) 
        {
          if (index == salidasState.registrosPaginados.length) 
          {
            return salidasState.totalPaginas > 1 ? 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PaginadoWidget(
                  paginaActual: salidasState.paginaActual,
                  paginaMostrada: salidasState.paginaMostrada,
                  totalPaginas: salidasState.totalPaginas,
                  onAnterior: salidasState.paginaActual > 1
                    ? () => ref.read(salidasListProvider.notifier).cambiarPagina(salidasState.paginaActual - 1) : null,
                  onSiguiente: salidasState.paginaActual < salidasState.totalPaginas
                    ? () => ref.read(salidasListProvider.notifier).cambiarPagina(salidasState.paginaActual + 1) : null,
                ),
              ) : const SizedBox.shrink();
          }

          final item = salidasState.registrosPaginados[index];
          return _SalidaItemCard(item: item);
        },
      ),
    );
  }

  Widget _buildFilterSheet(BuildContext context, bool isDark, dynamic clienteState) 
  {
    return DraggableScrollableSheet(
      controller: panelController,
      initialChildSize: .12,
      minChildSize: .12,
      maxChildSize: .80,
      builder: (context, scrollController) 
      {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              )
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.tune_rounded, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Filtros de búsqueda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                DropdownField<Cliente>(
                  label: 'Cliente',
                  icon: Icons.business_center_rounded,
                  value: clienteSeleccionado,
                  items: [
                    const DropdownMenuItem<Cliente>(
                      value: null,
                      child: Text('Todos los clientes'),
                    ),
                    ...clienteState.clientes.map<DropdownMenuItem<Cliente>>(
                      (e) => DropdownMenuItem<Cliente>(
                        value: e,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => clienteSeleccionado = val),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DateTileWidget(
                        label: 'Desde',
                        date: FormatUtil.dateFormated(fechaInicio),
                        onTap: seleccionarFechaInicio,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DateTileWidget(
                        label: 'Hasta',
                        date: FormatUtil.dateFormated(fechaFin),
                        onTap: seleccionarFechaFin,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: buscar,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Consultar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // Funcion de buscar
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

// Sub-componente para cada Orden de Retiro
class _SalidaItemCard extends StatelessWidget 
{
  final dynamic item;
  const _SalidaItemCard({required this.item});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.folio.isEmpty ? null : () => context.push('/detalleSalida/${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping_rounded,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Folio: ${item.folio}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cliente: ${item.nombre}',
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Salida: ${FormatUtil.stringToStandard(item.fechaSalida)} - ${item.horaSalida.format(context)}',
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Ver Detalle',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  foregroundColor: theme.colorScheme.primary,
                ),
                onPressed: item.folio.isEmpty ? null : () => context.push('/detalleSalida/${item.id}'),
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
