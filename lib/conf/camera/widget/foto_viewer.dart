import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestion_movil/conf/camera/camera.dart';

class FotoViewer extends StatelessWidget 
{
  final FotoAdjunta foto;

  const FotoViewer({super.key, required this.foto});

  @override
  Widget build(BuildContext context) 
  {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Encabezado(nombre: foto.nombre),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4,
                  child: Image.file(
                    foto.archivo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            _Pie(archivo: foto.archivo),
          ],
        ),
      ),
    );
  }
}

class _Encabezado extends StatelessWidget 
{
  final String nombre;

  const _Encabezado({required this.nombre});

  @override
  Widget build(BuildContext context) 
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          const Icon(Icons.photo),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pie extends StatelessWidget 
{
  final File archivo;

  const _Pie({required this.archivo});

  @override
  Widget build(BuildContext context) 
  {
    return FutureBuilder<int>(
      future: archivo.length(),
      builder: (context, snapshot) {
        final String tamano = snapshot.hasData ? _formatearTamano(snapshot.data!) : 'Calculando...';
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.photo_size_select_small,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(tamano),
              const Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
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
