import 'package:flutter/material.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';

class SelectedClients extends StatelessWidget 
{
  final List<Cliente> clientes;
  final ValueChanged<Cliente> onEliminar;

  const SelectedClients({super.key, required this.clientes, required this.onEliminar});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (clientes.isEmpty) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: clientes.map(
          (cliente) 
          {
            return InputChip(
              label: Text(
                cliente.nombre,
                style:const TextStyle(fontSize: 12),
              ),
              backgroundColor:isDark ? Colors.blue.withValues(alpha:.10) : Colors.white,
              labelStyle: TextStyle(
                color: isDark ? Colors.blue.shade200: Colors.black87,
              ),
              deleteIconColor: isDark ? Colors.blue.shade200: Colors.blue.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isDark ? Colors.blue.withValues(alpha:.30) : Colors.blue.shade100,
                ),
              ),
              onDeleted: () {
                onEliminar(
                  cliente,
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }
}