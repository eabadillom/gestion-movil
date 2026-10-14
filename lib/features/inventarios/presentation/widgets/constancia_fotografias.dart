import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/evidencias/providers/evidencias_notifier.dart';
import 'package:gestion_movil/features/inventarios/presentation/widgets/widgets.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class ConstanciaFotografias extends ConsumerStatefulWidget
{
  final TipoConstancia tipo;
  final int id;

  const ConstanciaFotografias({super.key, required this.tipo, required this.id});

  @override
  ConsumerState<ConstanciaFotografias> createState() => _ConstanciaFotografiasState();
}

class _ConstanciaFotografiasState extends ConsumerState<ConstanciaFotografias> 
{
  @override
  Widget build(BuildContext context) 
  {
    final params = (tipo: widget.tipo, id: widget.id);
    final provider = evidenciasProvider(params);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    ref.listen(evidenciasProvider(params), (previous, next) 
    {
      final respuestaAnterior = previous?.respuestaResponse.respuesta;
      final respuestaNueva = next.respuestaResponse.respuesta;

      if (respuestaNueva.isNotEmpty && respuestaNueva != respuestaAnterior) 
      {
        CustomSnackBarCentrado.mostrar(
          context,
          mensaje: respuestaNueva,
          tipo: state.respuestaResponse.exito ? SnackbarTipo.error : SnackbarTipo.success,
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: 
        [
          _BotonesFotos(isLoading: state.isLoading, onTomarFoto: notifier.tomarFoto, onGaleria: notifier.seleccionarDeGaleria),
          const SizedBox(height: 16),
          _InformacionFotos(cantidad: state.fotos.length, tamanoTotalBytes: state.tamanoTotalBytes, tamanoEnvioEstimadoBytes: state.tamanoEnvioEstimadoBytes, limiteEnvioBytes: state.limiteEnvioBytes, excedeLimite: state.excedeLimite),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: FotosList(
                fotos: state.fotos,
                isLoading: state.isLoading,
                onTap: (index) 
                {
                  _mostrarFoto(context, state.fotos[index]);
                },
                onRenombrar: (index) 
                {
                  _mostrarDialogoRenombrar(context, state.fotos[index], index, notifier);
                },
                onComprimir: (index) 
                {
                  notifier.comprimirFoto(index);
                },
                onEliminar: (index) 
                {
                  _confirmarEliminar(
                    context,
                    state.fotos[index], () 
                    {
                      notifier.eliminarFoto(index);
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (state.errorMessage != null) 
          ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                state.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (state.fotos.isNotEmpty) 
          ...[
            BarraAccionesFlotante(
              isLoading: state.isLoading,
              excedeLimite: state.excedeLimite,
              enviado: state.respuestaResponse.exito,
              onComprimir: notifier.comprimirFotos,
              onLimpiar: () 
              {
                _confirmarLimpiarFotos(context, notifier.limpiarFotos);
              },
              onEnviar: notifier.enviarFotos,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmarLimpiarFotos(BuildContext context, VoidCallback onConfirmar) async 
  {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) 
      {
        return AlertDialog(
          title: const Text('Eliminar fotografías'),
          content: const Text('¿Deseas eliminar todas las fotografías de esta constancia?'),
          actions: 
          [
            TextButton(
              onPressed: () 
              {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () 
              {
                Navigator.pop(context, true);
              },
              child: const Text('Eliminar todas'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      onConfirmar();
    }
  }

  void _mostrarFoto(BuildContext context, FotoAdjunta foto) 
  {
    showDialog(context: context, builder: (_) => FotoViewer(foto: foto));
  }

  Future<void> _confirmarEliminar(BuildContext context, FotoAdjunta foto, VoidCallback onConfirmar) async 
  {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) 
      {
        return AlertDialog(
          title: const Text('Eliminar fotografía'),
          content: Text('¿Deseas eliminar la fotografía "${foto.nombre}"?'),
          actions: 
          [
            TextButton(
              onPressed: () 
              {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () 
              {
                Navigator.pop(context, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      onConfirmar();
    }
  }

  Future<void> _mostrarDialogoRenombrar(BuildContext context, FotoAdjunta foto, int index, EvidenciasNotifier notifier) async 
  {
    final nuevoNombre = await showDialog<String>(
      context: context, 
      builder: (dialogContext) 
      {
        return RenombrarFotoDialog(
          nombreActual: foto.nombre, 
          existeNombre: (nombre) 
          {
            return notifier.existeNombreFoto(nombre, excluirIndex: index);
          },
        );
      }
    );

    if (!context.mounted || nuevoNombre == null) {
      return;
    }

    final nombreLimpio = nuevoNombre.trim();

    if (nombreLimpio.isEmpty) {
      return;
    }

    await notifier.renombrarFoto(index, nombreLimpio);
  }

}

class _BotonesFotos extends StatelessWidget 
{
  final bool isLoading;
  final VoidCallback onTomarFoto;
  final VoidCallback onGaleria;

  const _BotonesFotos({required this.isLoading, required this.onTomarFoto, required this.onGaleria});

  @override
  Widget build(BuildContext context) 
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: 
      [
        Row(
          children: 
          [
            Expanded(
              child: FilledButton.icon(
                onPressed: isLoading ? null : onTomarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar foto'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : onGaleria,
                icon: const Icon(Icons.photo_library),
                label: const Text('Galería'),
              ),
            ),
          ],
        ),
        if (isLoading) 
        ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          const Text(
            'Procesando fotografía, espera un momento...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class _InformacionFotos extends StatelessWidget 
{
  final int cantidad;
  final int tamanoTotalBytes;
  final int tamanoEnvioEstimadoBytes;
  final int limiteEnvioBytes;
  final bool excedeLimite;

  const _InformacionFotos({ required this.cantidad, required this.tamanoTotalBytes, required this.tamanoEnvioEstimadoBytes, required this.limiteEnvioBytes, required this.excedeLimite});

  @override
  Widget build(BuildContext context) 
  {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double progreso = limiteEnvioBytes == 0 ? 0 : tamanoEnvioEstimadoBytes / limiteEnvioBytes;
    final double progresoVisual = progreso.clamp(0.0, 1.0);
    final Color color = excedeLimite ? colorScheme.error : colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: 
          [
            const Text('Fotografías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('$cantidad foto(s)'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: 
          [
            const Text('Tamaño de fotografías'),
            Text(_formatearTamano(tamanoTotalBytes)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: 
          [
            const Text('Envío estimado'),
            Text(
              '${_formatearTamano(tamanoEnvioEstimadoBytes)} / ${_formatearTamano(limiteEnvioBytes)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progresoVisual,
          color: color,
          backgroundColor: colorScheme.surfaceContainerHighest,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(progreso * 100).toStringAsFixed(1)} %',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (excedeLimite) 
        ...[
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Icon(
                Icons.warning_amber,
                size: 18,
                color: colorScheme.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'El tamaño estimado del envío excede el límite permitido.',
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatearTamano(int bytes) 
  {
    final double mb = bytes / (1024 * 1024);

    if (mb >= 1) {
      return '${mb.toStringAsFixed(2)} MB';
    }

    final double kb = bytes / 1024;

    return '${kb.toStringAsFixed(2)} KB';
  }

}
