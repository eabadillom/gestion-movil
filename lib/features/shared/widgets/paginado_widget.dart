import 'package:flutter/material.dart';

class PaginadoWidget extends StatelessWidget 
{
  final int paginaActual;
  final int paginaMostrada;
  final int totalPaginas;
  final VoidCallback? onAnterior;
  final VoidCallback? onSiguiente;

  const PaginadoWidget({super.key, required this.paginaActual, required this.paginaMostrada, 
    required this.totalPaginas, this.onAnterior, this.onSiguiente});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16,12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: 
        [
          if (!isDark)
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: .04),
            ),
        ],
      ),

      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: 
        [
          ElevatedButton.icon(
            onPressed: onAnterior,
            icon: const Icon(Icons.arrow_back_ios_new, size: 14),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$paginaMostrada / $totalPaginas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed:onSiguiente,
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            label: const Text('Siguiente'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}