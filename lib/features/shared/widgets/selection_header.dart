import 'package:flutter/material.dart';

class SelectionHeader extends StatelessWidget 
{
  final String titulo;
  final VoidCallback onLimpiar;

  const SelectionHeader({super.key, required this.onLimpiar, this.titulo = 'CLIENTES SELECCIONADOS'});

  @override
  Widget build(BuildContext context) 
  {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: 
          [
            Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                color:colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: .8,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onLimpiar,
          child: const Text(
            'Limpiar',
            style: TextStyle(
              fontSize: 12,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
