import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/features/salidas/domain/domain.dart';
import 'package:gestion_movil/features/salidas/presentation/providers/providers.dart';
import 'package:gestion_movil/features/shared/widgets/widgets.dart';

class SalidaDetalleScreen extends ConsumerStatefulWidget
{
  final int idSalida;

  const SalidaDetalleScreen({super.key, required this.idSalida});

  @override
  ConsumerState<SalidaDetalleScreen> createState() => _SalidaDetalleScreen();
}

class _SalidaDetalleScreen extends ConsumerState<SalidaDetalleScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(salidaDetalleProvider.notifier).getSalidaDetalle(widget.idSalida);
    });
  }
  
  @override
  Widget build(BuildContext context) 
  {
    final salidaDetalleState = ref.watch(salidaDetalleProvider); 

    ref.listen<SalidaCancelarState>(
      salidaCancelarProvider,
      (previous, next) {
        if (previous?.cancelada != true && next.cancelada == true) {
          CustomSnackBarCentrado.mostrar(
            context,
            mensaje: 'La salida fue cancelada correctamente',
            tipo: SnackbarTipo.success,
          );

          ref.read(salidaDetalleProvider.notifier).getSalidaDetalle(widget.idSalida);
        }

        if (previous?.errorMessage != next.errorMessage && next.errorMessage != null) {
          CustomSnackBarCentrado.mostrar(
            context,
            mensaje: next.errorMessage!,
            tipo: SnackbarTipo.error,
          );
        }
      },
    );

    if (salidaDetalleState.isLoading) {
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Detalle de la salida', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (salidaDetalleState.salida == null) {
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Detalle de la salida', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'No se puede cargar la información',
          ),
        ),
      );
    }

    final salida = salidaDetalleState.salida!;
    final puedeCancelar = salida.statusSalida.id == 1;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Detalle de la salida', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, salida),
              const Divider(height: 1),
              const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.info_outline),
                    text: 'Información',
                  ),
                  Tab(
                    icon: Icon(Icons.inventory_2_outlined),
                    text: 'Productos',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildInformacionSalida(context, salida),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildDetallesSalida(context, salida),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (puedeCancelar) {
              _confirmarCancelacion(salida);
            } else {
              CustomSnackBarCentrado.mostrar(
                context,
                mensaje: 'Esta salida no se puede cancelar porque ya fue procesada.',
                tipo: SnackbarTipo.info,
              );
            }
          },
          backgroundColor: puedeCancelar ? Colors.red : Colors.grey,
          child: const Icon(Icons.block),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic salida)
  {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.local_shipping_outlined,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Folio',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 18),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    salida.folio,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Estado
            _buildStatusChip(context, salida.statusSalida),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, StatusSalida status)
  {
    Color color;
    switch (status.id) {
      case 1: // Enviado
        color = Colors.orange;
        break;
      case 2: // Aceptado
        color = Colors.green;
        break;
      case 3: // Cancelado
        color = Colors.red;
        break;
      default:
        color = Theme.of(context).colorScheme.primary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.descripcion,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildInformacionSalida(BuildContext context, dynamic salida)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Información de la salida', Icons.info_outline_rounded),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(context, icon: Icons.calendar_month_rounded, label: 'Fecha', value: _formatFecha(salida.fechaSalida)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(context, icon: Icons.access_time_rounded, label: 'Hora', value: _formatHora(context, salida.horaSalida)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Row(
                  children: [

                    Expanded(
                      child: _buildInfoItem(context, icon: Icons.person_outline_rounded, label: 'Transportista', value: salida.nombreTransportista),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildInfoItem(context, icon: Icons.directions_car_outlined, label: 'Placas', value: salida.placasTransporte),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        _buildObservaciones(context, salida),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context,
  {
    required IconData icon,
    required String label,
    required String value,
  })
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetallesSalida(BuildContext context, dynamic salida)
  {
    final detalles = salida.salidaDetalles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Productos (${detalles.length})', Icons.inventory_2_outlined),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: detalles.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index)
          {
            final detalle = detalles[index];
            return _buildDetalleProducto(context, detalle);
          },
        ),
        const Divider(),
        _buildTotales(context, salida),
      ],
    );
  }

  Widget _buildDetalleProducto(BuildContext context, dynamic detalle)
  {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detalle.descripcion,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildProductoDato(context, icon: Icons.inventory_2_outlined, label: 'Cantidad', value: detalle.cantidad.toString()),
                ),
                Expanded(
                  child: _buildProductoDato(context, icon: Icons.scale_outlined, label: 'Peso', value: '${detalle.peso.toStringAsFixed(3)} kg'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoDato(
    BuildContext context,
    {
      required IconData icon,
      required String label,
      required String value,
    })
  {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotales(BuildContext context, Salida salida)
  {
    final detalles = salida.salidaDetalles;
    final cantidadTotal = detalles.fold<int>(0, (total, detalle) => total + detalle.cantidad);
    final pesoTotal = detalles.fold<double>(0.0, (total, detalle) => total + detalle.peso);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cantidad total',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cantidadTotal.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peso total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pesoTotal.toStringAsFixed(3)} kg',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservaciones(BuildContext context, dynamic salida)
  {
    final observaciones = salida.observaciones;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Observaciones', Icons.notes_rounded),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              observaciones != null && observaciones.toString().trim().isNotEmpty ? observaciones : 'Sin observaciones',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon)
  {
    return Row(
      children: [
        Icon(
          icon,
          size: 21,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  String _formatFecha(dynamic fecha)
  {
    if (fecha == null) {
      return '';
    }

    final fechaString = fecha.toString();

    if (fechaString.length >= 10)
    {
      final partes = fechaString.substring(0, 10).split('-');

      if (partes.length == 3)
      {
        return '${partes[2]}/${partes[1]}/${partes[0]}';
      }
    }

    return fechaString;
  }

  String _formatHora(BuildContext context, TimeOfDay hora)
  {
    return hora.format(context);
  }

  Future<void> _confirmarCancelacion(Salida salida) async 
  {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Cancelar salida?'),
          content: Text('¿Estás seguro de que deseas cancelar el orden de retiro ${salida.folio}?'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await ref.read(salidaCancelarProvider.notifier).cancelarSalida(salida.id);
    }
  }
}
