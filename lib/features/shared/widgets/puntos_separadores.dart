import 'package:flutter/material.dart';

class PuntosSeparadores extends StatelessWidget 
{
  const PuntosSeparadores({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculamos cuántos puntos caben en el espacio disponible
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0; // Ancho de cada punto
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey), // Color de los puntos
              ),
            );
          }),
        );
      },
    );
  }
}