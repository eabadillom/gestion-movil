import 'package:flutter/material.dart';
import 'package:gestion_movil/features/posiciones/presentation/providers/providers.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class ResultadosPosiciones extends StatelessWidget 
{
  final PosicionesState state;

  const ResultadosPosiciones({super.key, required this.state});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (state.posicionesPlanta.isEmpty) 
    {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 60,
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),

              const SizedBox(height: 16),

              Text(
                'Sin registros disponibles',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// RESULTADOS
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
      itemCount: state.posicionesPlanta.entries.length,
      itemBuilder: (context, index) 
      {
        final entry = state.posicionesPlanta.entries.elementAt(index);
        final total = entry.value.fold<int>(0, (p, e) => p + e.tarima);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: isDark ? 0 : 2,
          color: isDark ? const Color(0xFF252525) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ExpansionTile(
            shape: const Border(),
            collapsedShape: const Border(),
            iconColor: colorScheme.primary,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.factory_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              entry.key,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: Text(
              'Total: $total posiciones',
              style:const TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),
            children: [
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              ...entry.value.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        item.camara,
                        style:TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 4,
                          ),
                          child: PuntosSeparadores(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.blue.withValues(alpha:.10) : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.tarima} pos.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
