import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/candadoSalida/presentation/providers/providers.dart';
import 'package:gestion_movil/features/candadoSalida/presentation/widgets/decimal_formatter.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:gestion_movil/features/saldos/presentation/providers/providers.dart';
import 'package:gestion_movil/features/shared/widgets/widgets.dart';

class CandadoSalidaDetalleScreen extends ConsumerStatefulWidget
{
  final Cliente cliente;

  const CandadoSalidaDetalleScreen({super.key, required this.cliente});

  @override
  ConsumerState<CandadoSalidaDetalleScreen> createState() => _CandadoSalidaDetalleState();
}

class _CandadoSalidaDetalleState extends ConsumerState<CandadoSalidaDetalleScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Cliente cliente;
  DateTime fecha = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    cliente = widget.cliente;

    Future.microtask(() {
      ref.read(validacionSaldoProvider.notifier).cargarValidacionSaldo(widget.cliente.id, fecha);
      ref.read(candadoSalidaProvider.notifier).cargarCandadoSalida(widget.cliente.id);
    });
  }
  
  @override
  Widget build(BuildContext context) 
  {
    final validacionSaldoState = ref.watch(validacionSaldoProvider);
    final candadoState = ref.watch(candadoSalidaProvider);
    final guardarCandadoState = ref.watch(guardarCandadoProvider);
    final validacionSaldo = validacionSaldoState.validacionSaldo;
    final candado = candadoState.candadoSalida;

    final isLoading = validacionSaldoState.isLoading || candadoState.isLoading;
    final isSmall = MediaQuery.of(context).size.width < 360;

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (validacionSaldo == null || candado == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No se puede cargar la información',
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Detalle candado salida', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxWidth: 600,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.person),
                                Text(
                                  cliente.nombre, 
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, 
                                  style: TextStyle(fontSize: isSmall ? 16 : 18)
                                ),
                              ],
                            ),
                          ),
                        ),
                                  
                        const SizedBox(height: 16),
                                  
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Saldo vencido',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                  
                                const SizedBox(height: 8),
                                  
                                Text(
                                  DecimalFormatter.currency(validacionSaldo.saldoVencido),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmall ? 22 : 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                                  
                        const SizedBox(height: 16),
                                  
                        Card(
                          color: (validacionSaldo.saldoVencido > Decimal.zero) ? Colors.orange.shade200 : Colors.green.shade200,
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text(
                                  'Observaciones',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                  
                                const SizedBox(height: 12),
                                  
                                Text(
                                  validacionSaldo.descripcion,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmall ? 14 : 16,
                                    color: Colors.orange.shade900,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ),
                                  
                        const SizedBox(height: 16),
                                  
                        Card(
                          child: SwitchListTile(
                            value: candado.habilitado,
                            title: const Text(
                              'Habilitar salida',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            secondary: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return RotationTransition(
                                  turns: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                candado.habilitado? Icons.lock_open : Icons.lock,
                                key: ValueKey(candado.habilitado),
                                size: 32,
                                color: candado.habilitado ? Colors.green : Colors.red,
                              ),
                            ),
                            onChanged: (value) {
                              ref.read(candadoSalidaProvider.notifier).toggleHabilitado(value);
                            },
                          ),
                        ),
                                  
                        const SizedBox(height: 16),
                                  
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'Número de salidas',
                                  style: TextStyle(
                                    fontSize: isSmall ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                  
                                const SizedBox(height: 16),
                                  
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ref.read(candadoSalidaProvider.notifier).decrementarSalidas();
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                  
                                    Text(
                                      '${candado.numSalidas}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  
                                    IconButton(
                                      onPressed: () {
                                        ref.read(candadoSalidaProvider.notifier).incrementarSalidas();
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                                  
                        const SizedBox(height: 16),
                                  
                        Card(
                          child: SwitchListTile(
                            value: candado.salidaTotal,
                            title: const Text('Salidas'),
                            secondary: const Icon(Icons.inventory_2_outlined),
                            onChanged: (value) {
                              ref.read(candadoSalidaProvider.notifier).toggleSalidaTotal(value);
                            },
                          ),
                        ),
                                  
                        const SizedBox(height: 24),
                                  
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: guardarCandadoState.isSaving ? null : () async 
                            {
                              final confirmado = await showDialog<bool>(
                                context: context,
                                builder: (_) 
                                {
                                  return AlertDialog(
                                    title: const Text('Confirmar'),
                                    content: const Text('¿Desea guardar los cambios?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('Cancelar'),
                                      ),

                                      FilledButton(
                                        onPressed: () {
                                          ref.read(guardarCandadoProvider.notifier).agregarCandado(candadoState.candadoSalida!);
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('Guardar'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmado != true) {
                                return;
                              }

                              final ok = await ref.read(guardarCandadoProvider.notifier).guardarCandadoSalida();

                              if (!context.mounted) return;

                              if (ok) {
                                await CustomSnackBarCentrado.mostrar(
                                  context,
                                  mensaje: 'Información guardada correctamente',
                                  tipo: SnackbarTipo.success,
                                );
                              } else {
                                await CustomSnackBarCentrado.mostrar(
                                  context,
                                  mensaje: candadoState.errorMessage ?? 'Error al guardar',
                                  tipo: SnackbarTipo.error,
                                );
                              }
                            },

                            icon: guardarCandadoState.isSaving ? 
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ): const Icon(Icons.save),
                            
                            label: Text(guardarCandadoState.isSaving ? 'Guardando...' : 'Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
