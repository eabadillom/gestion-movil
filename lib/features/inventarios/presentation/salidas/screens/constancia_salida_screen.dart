import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/salidas/salidas.dart';
import 'package:gestion_movil/features/inventarios/presentation/widgets/widgets.dart';
import 'package:gestion_movil/features/shared/shared.dart';
import 'package:go_router/go_router.dart';

class ConstanciaSalidaScreen extends ConsumerStatefulWidget
{
  const ConstanciaSalidaScreen({super.key});

  @override
  ConsumerState<ConstanciaSalidaScreen> createState() => _ConstanciaSalidaScreenState();
}

class _ConstanciaSalidaScreenState extends ConsumerState<ConstanciaSalidaScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController folioController = TextEditingController();
  final panelController = DraggableScrollableController();
  final FocusNode folioFocusNode = FocusNode();

  Cliente? clienteSeleccionado;

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

    Future.microtask(() 
    {
      ref.invalidate(salidaResponseProvider);
    });
  }

  @override
  void dispose() 
  {
    panelController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final constanciaSalidassState = ref.watch(salidaResponseProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Consulta de salidas', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 2,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: PaginatedListView<ConstanciaDTO>(
                isLoading: constanciaSalidassState.isLoading,
                isEmpty: constanciaSalidassState.listConstancias.isEmpty,
                items: constanciaSalidassState.registrosPaginados,
                paginaActual: constanciaSalidassState.paginaActual,
                paginaMostrada: constanciaSalidassState.paginaMostrada,
                totalPaginas: constanciaSalidassState.totalPaginas,
                emptyTitle: 'Consulta de salidas',
                emptySubtitle: 'Desliza el panel inferior y utiliza los filtros para consultar registros.',
                onPageAnterior: () => ref.read(salidaResponseProvider.notifier).cambiarPagina(constanciaSalidassState.paginaActual - 1),
                onPageSiguiente: () => ref.read(salidaResponseProvider.notifier).cambiarPagina(constanciaSalidassState.paginaActual + 1),
                itemBuilder: (context, item) 
                {
                  final hasFolio = item.folioCliente.isNotEmpty;

                  return ConstanciaItemCard(
                    folio: item.folioCliente,
                    cliente: item.nombre,
                    fecha: FormatUtil.stringToStandard(item.fecha),
                    onTap: hasFolio ? () => context.push('/detalleConstanciaSalida', extra: {'folioCliente': item.folioCliente}) : null,
                  );
                },
              ),
            ),
            FilterBottomSheet<Cliente>(
              panelController: panelController,
              selectedItem: clienteSeleccionado,
              items: clienteState.clientes,
              itemLabelBuilder: (cliente) => cliente.nombre,
              onItemChanged: (val) => setState(() => clienteSeleccionado = val),
              startDateText: FormatUtil.dateFormated(fechaInicio!),
              onSelectStartDate: seleccionarFechaInicio,
              endDateText: FormatUtil.dateFormated(fechaFin!),
              onSelectEndDate: seleccionarFechaFin,
              searchController: folioController,
              searchFocusNode: folioFocusNode,
              onSearchChanged: (texto) => setState(() => folio = texto),
              onApplyFilters: buscar,
            )
          ]
        ),
      ),
    );
  }

  // Funcion de buscar
  Future<void> buscar() async 
  {
    folioFocusNode.unfocus();

    ref.read(salidaResponseProvider.notifier).limpiar();
    
    await ref.read(salidaResponseProvider.notifier).obtenerConstanciasSalidas(TipoConstancia.salida, fechaInicio!, fechaFin!, clienteSeleccionado?.id, folio?.trim().isEmpty == true ? null : folio?.trim());
    
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

}
