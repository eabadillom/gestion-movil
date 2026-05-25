import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/dashboard/presentation/providers/providers.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';
import 'package:gestion_movil/features/shared/widgets/paginado_widget.dart';
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
  final panelController = DraggableScrollableController();

  Cliente? clienteSeleccionado;
  Planta? plantaSeleccionada;
  
  DateTime fechaInicio = FormatUtil.dateFormated(DateTime.now().subtract(const Duration(days: 7)));
  DateTime fechaFin = DateTime.now();

  @override
  void initState() 
  {
    super.initState();

    Future.microtask(() {
      ref.invalidate(kardexListRepositoryProvider);
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final plantaState = ref.watch(plantaNotifierProvider);
    final constanciaState = ref.watch(kardexListRepositoryProvider);
    final usuario = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<DropdownMenuItem<Planta?>> plantasItems = _buildPlantasItems(usuario, plantaState);
    final bool valorExiste = plantaState.plantas.any((p) => p.id == plantaSeleccionada?.id);
    
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
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Kardex', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: constanciaState.isLoading
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: BarraBusqueda(
                              onChanged: (texto) => ref.read(kardexListRepositoryProvider.notifier).setBusqueda(texto),
                              hintText: 'Buscar por folio o fecha'
                            ),
                          ),
                          if (constanciaState.constancias.isEmpty)
                            EstadoInicialBusqueda(icono: Icons.manage_search_rounded, titulo: 'Consulta de Kardex', subtitulo: 'Desliza el panel inferior y utiliza los filtros para ver los registros disponibles.')
                          else if (constanciaState.registrosFiltrados.isEmpty)
                            SinResultadosBusqueda(texto: constanciaState.busqueda, icono:  Icons.search_off_rounded, titulo:  'Sin coincidencias')
                          else ...[
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                              itemCount: constanciaState.registrosPaginados.length,
                              itemBuilder: (_, i) 
                              {
                                final item = constanciaState.registrosPaginados[i];
                                final theme = Theme.of(context);
                                final isDark = theme.brightness == Brightness.dark;
                                final colorScheme = theme.colorScheme;
                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 14,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(22),
                                      onTap: item.folioCliente.isEmpty ? null : () => 
                                        context.push('/kardexPdf', extra: {'folioCliente': item.folioCliente}),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                                color: Colors.black.withValues(alpha: .05),
                                              ),
                                          ],
                                        ),

                                        child: Row(
                                          children: 
                                          [
                                            Container(
                                              width: 52,
                                              height: 52,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: colorScheme.primary.withValues(alpha: .12),
                                              ),

                                              child: Icon(
                                                Icons.description_outlined,
                                                color: colorScheme.primary,
                                                size: 24,
                                              ),
                                            ),

                                            const SizedBox(width: 14),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: 
                                                [
                                                  Text(
                                                    'Folio: ${item.folioCliente}',
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
                                                    'Ingreso: ${FormatUtil.stringToStandard(item.fechaIngreso)}',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      color: isDark ? Colors.white70 : Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:BorderRadius.circular(14),
                                                color: Colors.red.withValues(alpha: .10),
                                              ),

                                              child: IconButton(
                                                tooltip:'Ver PDF',
                                                onPressed: item.folioCliente.isEmpty ? null : () => 
                                                  context.push('/kardexPdf', extra: {'folioCliente': item.folioCliente}),
                                                icon: const Icon(
                                                  Icons.picture_as_pdf_rounded,
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
                                );
                              },
                            ),
                            if (constanciaState.totalPaginas > 1)
                              PaginadoWidget(paginaActual: constanciaState.paginaActual, paginaMostrada: constanciaState.paginaMostrada, totalPaginas: constanciaState.totalPaginas, 
                                onAnterior: constanciaState.paginaActual > 1 ? () 
                                {
                                  ref.read(kardexListRepositoryProvider.notifier).cambiarPagina(constanciaState.paginaActual - 1);
                                } : null,
                                onSiguiente: constanciaState.paginaActual < constanciaState.totalPaginas? () 
                                {
                                  ref.read(kardexListRepositoryProvider.notifier).cambiarPagina(constanciaState.paginaActual + 1);
                                } : null
                              ),
                          ],
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
      
                        const SizedBox(height: 16),
      
                        DropdownField<Planta?>( /// PLANTAS
                          label: 'Planta',
                          icon: Icons.factory_rounded,
                          value: valorExiste ? plantaSeleccionada : null,
                          items: plantasItems,
                          onChanged: (usuario?.perfil == 1 || usuario?.perfil == 4) ? null : (val) => setState(() => plantaSeleccionada = val),
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
    await ref.read(kardexListRepositoryProvider.notifier).obtenerKardex(fechaInicio, fechaFin, clienteSeleccionado?.id, plantaSeleccionada?.id);
    panelController.animateTo(.12, duration: const Duration(milliseconds: 400), curve: Curves.ease);
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
  
}
