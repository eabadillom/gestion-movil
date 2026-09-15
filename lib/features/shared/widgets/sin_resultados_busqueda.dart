import 'package:flutter/material.dart';

class SinResultadosBusqueda extends StatelessWidget 
{
  final String texto;
  final IconData icono;
  final String titulo;

  const SinResultadosBusqueda({super.key, required this.texto, required this.icono, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final titleColor = isDark? Colors.white70 : Colors.black54;
    final subtitleColor = isDark? Colors.white38 : Colors.grey;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 70,
              color: iconColor,
            ),

            const SizedBox(height: 18),

            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'No se encontró "$texto"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}