import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestion_movil/conf/camera/camera.dart';

class FotoListTile extends StatelessWidget 
{
  final FotoAdjunta foto;
  final VoidCallback? onTap;
  final VoidCallback? onComprimir;
  final VoidCallback? onEliminar;
  final bool isLoading;

  const FotoListTile({super.key, required this.foto, this.onTap, this.onComprimir, this.onEliminar, this.isLoading = false});

  @override
  Widget build(BuildContext context) 
  {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(foto.archivo, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(foto.nombre, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: _TamanoFoto(archivo: foto.archivo),
        trailing: PopupMenuButton<String>(
          enabled: !isLoading,
          onSelected: (value) {
            switch (value) {
              case 'comprimir':
                onComprimir?.call();
                break;
              case 'eliminar':
                onEliminar?.call();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'comprimir',
              child: ListTile(
                leading: Icon(Icons.compress),
                title: Text('Reducir tamaño'),
              ),
            ),
            PopupMenuItem(
              value: 'eliminar',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TamanoFoto extends StatelessWidget 
{
  final File archivo;

  const _TamanoFoto({required this.archivo});

  @override
  Widget build(BuildContext context) 
  {
    return FutureBuilder<int>(
      future: archivo.length(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('Calculando tamaño...');
        }
        final double mb = snapshot.data! / (1024 * 1024);
        return Text('${mb.toStringAsFixed(2)} MB');
      },
    );
  }
}
