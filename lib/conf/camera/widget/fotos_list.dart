import 'package:flutter/widgets.dart';
import 'package:gestion_movil/conf/camera/camera.dart';

class FotosList extends StatelessWidget 
{
  final List<FotoAdjunta> fotos;
  final void Function(int index)? onTap;
  final void Function(int index)? onComprimir;
  final void Function(int index)? onEliminar;
  final bool isLoading;

  const FotosList({super.key, required this.fotos, this.onTap, this.onComprimir, this.onEliminar, this.isLoading = false});

  @override
  Widget build(BuildContext context) 
  {
    if (fotos.isEmpty) {
      return const Center(
        child: Text('No hay fotografías'),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fotos.length,
      itemBuilder: (context, index) {
        return FotoListTile(
          foto: fotos[index],
          isLoading: isLoading,
          onTap: onTap == null ? null : () => onTap!(index),
          onComprimir: onComprimir == null ? null : () => onComprimir!(index),
          onEliminar: onEliminar == null ? null : () => onEliminar!(index),
        );
      },
    );
  }
}
