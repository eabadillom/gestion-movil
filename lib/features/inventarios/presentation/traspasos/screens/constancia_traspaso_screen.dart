import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/traspasos/traspasos.dart';
import 'package:gestion_movil/features/inventarios/presentation/widgets/widgets.dart';
import 'package:gestion_movil/features/shared/widgets/widgets.dart';

class ConstanciaTraspasoScreen extends ConsumerStatefulWidget 
{
  const ConstanciaTraspasoScreen({super.key});

  @override
  ConsumerState<ConstanciaTraspasoScreen> createState() => _ConstanciaTraspasoState();
}

class _ConstanciaTraspasoState extends ConsumerState<ConstanciaTraspasoScreen>
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
      ref.invalidate(traspasoResponseProvider);
    });
  }

  @override
  void dispose() 
  {
    folioController.dispose();
    panelController.dispose();
    folioFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final constanciaTraspasoState = ref.watch(traspasoResponseProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(traspasoResponseProvider, (previous, next) 
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
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Consulta de traspasos', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 2,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: PaginatedListView<Constancia>(
                isLoading: constanciaTraspasoState.isLoading,
                isEmpty: constanciaTraspasoState.listConstancias.isEmpty,
                items: constanciaTraspasoState.registrosPaginados,
                paginaActual: constanciaTraspasoState.paginaActual,
                paginaMostrada: constanciaTraspasoState.paginaMostrada,
                totalPaginas: constanciaTraspasoState.totalPaginas,
                emptyTitle: 'Consulta de traspasos',
                emptySubtitle: 'Desliza el panel inferior y utiliza los filtros para consultar registros.',
                onPageAnterior: () => ref.read(traspasoResponseProvider.notifier).cambiarPagina(constanciaTraspasoState.paginaActual - 1),
                onPageSiguiente: () => ref.read(traspasoResponseProvider.notifier).cambiarPagina(constanciaTraspasoState.paginaActual + 1),
                itemBuilder: (context, item) 
                {
                  final hasFolio = item.folioCliente!.isNotEmpty;

                  return ConstanciaItemCard(
                    folio: item.folioCliente!,
                    cliente: item.nombre!,
                    fecha: FormatUtil.stringToStandard(item.fecha!),
                    onTap: hasFolio ? () => context.push('/detalleConstancia', extra: {'tipo': TipoConstancia.traspaso, 'id': item.id}) : null,
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
          ],
        ),
      ),
    );
  }

  // Funcion de buscar
  Future<void> buscar() async 
  {
    folioFocusNode.unfocus();

    ref.read(traspasoResponseProvider.notifier).limpiar();
    
    await ref.read(traspasoResponseProvider.notifier).obtenerConstanciasTraspaso(TipoConstancia.traspaso, fechaInicio!, fechaFin!, clienteSeleccionado?.id, folio?.trim().isEmpty == true ? null : folio?.trim());
    
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
