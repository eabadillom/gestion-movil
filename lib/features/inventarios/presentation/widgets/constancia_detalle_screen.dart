import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/provider/constancia_detalle_response_provider.dart';
import 'package:gestion_movil/features/inventarios/presentation/widgets/widgets.dart';

class ConstanciaDetalleScreen extends ConsumerStatefulWidget
{
  final TipoConstancia tipo;
  final int id;

  const ConstanciaDetalleScreen({super.key, required this.tipo, required this.id});

  @override
  ConsumerState<ConstanciaDetalleScreen> createState() => _ConstanciaDetalleScreenState();
}

class _ConstanciaDetalleScreenState extends ConsumerState<ConstanciaDetalleScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    super.initState();

    Future.microtask(() 
    {
      ref.read(constanciaDetalleResponseProvider.notifier).obtenerConstanciaDetalle(widget.tipo, widget.id);
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final state = ref.watch(constanciaDetalleResponseProvider);

    if (state.isLoading)
    {
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            _tituloConstancia(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null)
    {
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            _tituloConstancia(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: _buildError(state.errorMessage!),
      );
    }

    if (state.constancia == null)
    {
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            _tituloConstancia(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No se puede cargar la información'),
        ),
      );
    }

    final constancia = state.constancia!;
    final tieneProductos = constancia.productos.isNotEmpty;
    final tieneServicios = constancia.servicios.isNotEmpty;
    final cantidadTabs = 1 + (constancia.productos.isNotEmpty ? 1 : 0) + (constancia.servicios.isNotEmpty ? 1 : 0);

    final anchoPantalla = MediaQuery.of(context).size.width;
    final anchoTab = anchoPantalla / cantidadTabs;
    final tamanoTexto = _tamanoTextoTab(anchoTab);

    final tabs = <Tab>[
      Tab(
        icon: Icon(Icons.info_rounded),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Información',
            style: TextStyle(fontSize: tamanoTexto),
          ),
        ),
      ),
    ];

    final tabViews = <Widget>[
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstanciaInfoCard(constancia: constancia, tipo: widget.tipo),
      ),
    ];

    if (tieneProductos)
    {
      tabs.add(
        Tab(
          icon: Icon(Icons.inventory_2_outlined),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Productos',
              style: TextStyle(fontSize: tamanoTexto),
            ),
          ),
        ),
      );
      tabViews.add(
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstanciaProductos(productos: constancia.productos, tipo: widget.tipo),
        ),
      );
    }

    if (tieneServicios)
    {
      tabs.add(
        Tab(
          icon: Icon(Icons.miscellaneous_services_outlined),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Servicios',
              style: TextStyle(fontSize: tamanoTexto),
            ),
          ),
        ),
      );
      tabViews.add(
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstanciaServicios(servicios: constancia.servicios),
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            _tituloConstancia(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              ConstanciaHeader(constancia: constancia, tipo: widget.tipo),
              const Divider(height: 1),
              TabBar(tabs: tabs),
              Expanded(child: TabBarView(children: tabViews)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(String mensaje)
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () 
              {
                ref.read(constanciaDetalleResponseProvider.notifier).obtenerConstanciaDetalle(widget.tipo, widget.id);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  String _tituloConstancia()
  {
    switch (widget.tipo)
    {
      case TipoConstancia.deposito:
        return 'Constancia de entrada';
      case TipoConstancia.salida:
        return 'Constancia de salida';
      case TipoConstancia.servicio:
        return 'Constancia de servicio';
      case TipoConstancia.traspaso:
        return 'Constancia de traspaso';
    }
  }

  double _tamanoTextoTab(double anchoTab) 
  {
    if (anchoTab < 100) {
      return 11;
    }

    if (anchoTab < 120) {
      return 12;
    }

    if (anchoTab < 150) {
      return 14;
    }

    return 16;
  }

}
