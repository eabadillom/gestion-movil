import 'package:flutter/material.dart';
import 'package:gestion_movil/conf/camera/camera.dart';

class FotoCard extends StatelessWidget 
{
  final FotoAdjunta foto;
  final VoidCallback? onTap;
  final VoidCallback? onEliminar;

  const FotoCard({super.key, required this.foto, this.onTap, this.onEliminar});

  @override
  Widget build(BuildContext context) 
  {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(foto.archivo, fit: BoxFit.cover),
            ),
          ),

          if (onEliminar != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: onEliminar,
                icon: const Icon(Icons.delete),
              ),
            ),
        ],
      ),
    );
  }
}
