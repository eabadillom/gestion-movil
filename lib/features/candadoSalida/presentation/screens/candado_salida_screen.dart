import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/clientes/presentation/providers/providers.dart';
import 'package:gestion_movil/features/shared/widgets/widgets.dart';

class CandadoSalidaScreen extends ConsumerStatefulWidget
{
  const CandadoSalidaScreen({super.key});

  @override
  ConsumerState<CandadoSalidaScreen> createState() => _CandadoSalidaState();
}

class _CandadoSalidaState extends ConsumerState<CandadoSalidaScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  List<Cliente> clientesFiltrados = [];
  Cliente? clienteSeleccionado;

  int paginaActual = 0;
  final int elementosPorPagina = 5;
  
  @override
  void initState() {
    super.initState();

    _searchController.addListener(_filtrarClientes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarClientes() {
    final clienteState = ref.read(clienteNotifierProvider);
    final texto = _searchController.text.toLowerCase();

    setState(() {
      paginaActual = 0;
      clientesFiltrados = clienteState.clientes.where((cliente) {
        return cliente.nombre.toLowerCase().contains(texto);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final clienteState = ref.watch(clienteNotifierProvider);
    final listaBase = _searchController.text.isEmpty ? clienteState.clientes : clientesFiltrados;
    
    final inicio = paginaActual * elementosPorPagina;
    final fin = (inicio + elementosPorPagina > listaBase.length) ? listaBase.length : inicio + elementosPorPagina;
    final clientesPagina = listaBase.sublist(inicio, fin);
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Consulta de candado de salida', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _searchController,
                  hint: 'Buscar cliente',
                  prefixIcon: Icons.search,
                ),
          
                const SizedBox(height: 16),
          
                Expanded(
                  child: ListaTarjetaGenerica<Cliente>(
                    items: clientesPagina,
                    getTitle: (c) => c.nombre,
                    getRoute: (c) => '/detalleCandadoSalida',
                    getExtra: (c) => c,
                    getIcon: (c) => Icons.account_circle,
                  ),
                ),
          
                const SizedBox(height: 12),
          
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: paginaActual > 0 ? 
                        () {
                          setState(() {
                            paginaActual--;
                          });
                        } : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                            
                      Text(
                        'Página ${paginaActual + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                            
                      IconButton(
                        onPressed: fin < listaBase.length ? 
                        () {
                          setState(() {
                            paginaActual++;
                          });
                        } : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
