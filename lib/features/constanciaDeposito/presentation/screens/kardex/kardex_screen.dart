import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/constanciaDeposito/presentation/providers/providers.dart';
import 'package:gestion_movil/features/plantas/domain/domain.dart';
import 'package:gestion_movil/features/plantas/presentation/providers/providers.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class KardexScreen extends ConsumerStatefulWidget 
{
  final String numUsuario;
  const KardexScreen({super.key, required this.numUsuario});

  @override
  ConsumerState<KardexScreen> createState() => _KardexScreenState();
}

class _KardexScreenState extends ConsumerState<KardexScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController folioController = TextEditingController();
  final panelController = DraggableScrollableController();
  final FocusNode folioFocusNode = FocusNode();

  Cliente? clienteSeleccionado;
  Planta? plantaSeleccionada;
  
  DateTime? fechaInicio;
  DateTime? fechaFin;

  String? folio;

  @override
  void initState() 
  {
    super.initState();
    final hoy = DateTime.now();
    fechaFin = DateTime(hoy.year, hoy.month, hoy.day);
    fechaInicio = fechaFin?.subtract(Duration(days: fechaFin!.weekday - DateTime.monday));

    Future.microtask(() {
      ref.invalidate(kardexListRepositoryProvider);
    });
  }

  @override
  void dispose() {
    folioController.dispose();
    panelController.dispose();
    folioFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final plantaState = ref.watch(plantaNotifierProvider);
    final constanciaState = ref.watch(kardexListRepositoryProvider);
    final usuario = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ref.listen(kardexListRepositoryProvider, (previous, next) 
    {
      if (previous?.errorMessage != next.errorMessage && next.errorMessage != null) 
      {
        CustomSnackBarCentrado.mostrar(
          context,
          mensaje: next.errorMessage!,
          tipo: SnackbarTipo.error,
        );
      }
    });

    if ((usuario?.perfil == 1 || usuario?.perfil == 4) && plantaSeleccionada == null && plantaState.plantas.isNotEmpty) 
    {
      Future.microtask(() {
        setState(() {
          plantaSeleccionada = plantaState.plantas.first;
        });
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Kardex', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          scrolledUnderElevation: 2,
        ),
        body: Stack(
          children: [
            _buildMainContent(constanciaState),
            _buildFilterSheet(context, isDark, clienteState, plantaState, usuario),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(dynamic constanciaState) 
  {
    if (constanciaState.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (constanciaState.constancias.isEmpty) {
      return Align(
        alignment: Alignment(0, -0.25),
        child: EstadoInicialBusqueda(
          icono: Icons.manage_search_rounded,
          titulo: 'Consulta de Kardex',
          subtitulo: 'Desliza el panel inferior y utiliza los filtros para consultar registros.',
        ),
      );
    }

    return Positioned.fill(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
        itemCount: constanciaState.registrosPaginados.length + 1,
        itemBuilder: (context, index) 
        {
          if (index == constanciaState.registrosPaginados.length) 
          {
            return constanciaState.totalPaginas > 1 ? 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PaginadoWidget(
                  paginaActual: constanciaState.paginaActual,
                  paginaMostrada: constanciaState.paginaMostrada,
                  totalPaginas: constanciaState.totalPaginas,
                  onAnterior: constanciaState.paginaActual > 1
                    ? () => ref.read(kardexListRepositoryProvider.notifier).cambiarPagina(constanciaState.paginaActual - 1) : null,
                  onSiguiente: constanciaState.paginaActual < constanciaState.totalPaginas
                    ? () => ref.read(kardexListRepositoryProvider.notifier).cambiarPagina(constanciaState.paginaActual + 1) : null,
                ),
              ) : const SizedBox.shrink();
          }

          final item = constanciaState.registrosPaginados[index];
          return _KardexItemCard(item: item);
        },
      ),
    );
  }

  Widget _buildFilterSheet(BuildContext context, bool isDark, ClienteState clienteState, PlantaState plantaState, UsuarioDetalle? usuario) 
  {
    final bool valorExiste = plantaState.plantas.any((p) => p.id == plantaSeleccionada?.id);
    List<DropdownMenuItem<Planta?>> plantasItems = _buildPlantasItems(usuario, plantaState);

    return DraggableScrollableSheet(
      controller: panelController,
      initialChildSize: .12,
      minChildSize: .12,
      maxChildSize: .85,
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
                    const DropdownMenuItem<Cliente>(value: null, child: Text('Todos los clientes')),
                    ...clienteState.clientes.map<DropdownMenuItem<Cliente>>((e) => DropdownMenuItem<Cliente>(value: e,  child: Text(e.nombre, overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                  onChanged: (val) => setState(() => clienteSeleccionado = val),
                ),
                const SizedBox(height: 14),
                DropdownField<Planta?>(
                  label: 'Planta',
                  icon: Icons.factory_rounded,
                  value: valorExiste ? plantaSeleccionada : null,
                  items: plantasItems,
                  onChanged: (usuario?.perfil == 1 || usuario?.perfil == 4) ? null : (val) => setState(() => plantaSeleccionada = val),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DateTileWidget(
                        label: 'Desde',
                        date: FormatUtil.dateFormated(fechaInicio!),
                        onTap: seleccionarFechaInicio,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DateTileWidget(
                        label: 'Hasta',
                        date: FormatUtil.dateFormated(fechaFin!),
                        onTap: seleccionarFechaFin,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Por Folio:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BarraBusqueda(
                        controller: folioController,
                        focusNode: folioFocusNode,
                        onChanged: (texto) => setState(() {
                          folio = texto;
                        }),
                        hintText: 'Buscar por folio...',
                      ),
                    ],
                  ),
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

  // Funciones de buscar
  Future<void> buscar() async 
  {
    folioFocusNode.unfocus();

    ref.read(kardexListRepositoryProvider.notifier).limpiar();

    await ref.read(kardexListRepositoryProvider.notifier).obtenerKardex(fechaInicio!, fechaFin!, clienteSeleccionado?.id, plantaSeleccionada?.id, folio?.trim().isEmpty == true ? null : folio?.trim());
    
    setState(() {
      folio = null;
      folioController.clear();
    });
    
    panelController.animateTo(.12, duration: const Duration(milliseconds: 400), curve: Curves.ease);
  }

  Future<void> seleccionarFechaInicio() async 
  {
    final hoy = DateTime.now();

    final fecha = await customDatePicker(
      context: context,
      initialDate: fechaInicio!.isAfter(hoy) ? hoy : fechaInicio!,
      firstDate: DateTime(2020),
      lastDate: hoy,
    );

    if (fecha != null) {
      setState(() {
        fechaInicio = fecha;

        if (fechaFin!.isBefore(fechaInicio!)) {
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
      initialDate: fechaFin!.isAfter(hoy) ? hoy : fechaFin!,
      firstDate: fechaInicio!,
      lastDate: hoy,
    );

    if (fecha != null) {
      setState(() => fechaFin = fecha);
    }
  }

  List<DropdownMenuItem<Planta?>> _buildPlantasItems(UsuarioDetalle? usuario, PlantaState plantaState) 
  {
    final items = plantaState.plantas.map<DropdownMenuItem<Planta?>>(
      (e) => DropdownMenuItem<Planta?>(value: e, child: Text(e.descripcion, overflow: TextOverflow.ellipsis)),
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
  
}

// Sub-componente para los elementos del Kardex
class _KardexItemCard extends StatelessWidget 
{
  final dynamic item;
  const _KardexItemCard({required this.item});

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
        onTap: item.folioCliente.isEmpty ? null : () => context.push('/kardexPdf', extra: {'folioCliente': item.folioCliente}),
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
                child: Icon(Icons.receipt_long_rounded, color: theme.colorScheme.onPrimaryContainer, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Folio: ${item.folioCliente}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingreso: ${FormatUtil.stringToStandard(item.fechaIngreso)}',
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Ver PDF',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.redAccent,
                ),
                onPressed: item.folioCliente.isEmpty ? null : () => context.push('/kardexPdf', extra: {'folioCliente': item.folioCliente}),
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
