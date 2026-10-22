import 'package:flutter/material.dart';
import 'package:gestion_movil/conf/camera/camera.dart';

class FotosGrid extends StatelessWidget 
{
  final List<FotoAdjunta> fotos;
  final void Function(int index)? onTap;
  final void Function(int index)? onEliminar;

  const FotosGrid({super.key, required this.fotos, this.onTap, this.onEliminar});

  @override
  Widget build(BuildContext context) 
  {
    if (fotos.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fotos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) 
      {
        final foto = fotos[index];
        return FotoCard(
          foto: foto,
          onTap: onTap == null ? null : () => onTap!(index),
          onEliminar: onEliminar == null ? null : () => onEliminar!(index),
        );
      },
    );
  }
}
