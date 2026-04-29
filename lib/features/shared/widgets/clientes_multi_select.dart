import 'package:flutter/material.dart';
import 'package:gestion_movil/features/clientes/domain/domain.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ClientesMultiSelect extends StatelessWidget 
{
  final List<Cliente> clientes;
  final ValueChanged<List<Cliente>> onConfirm;
  final String titulo;
  final String textoBoton;

  const ClientesMultiSelect({super.key, required this.clientes, required this.onConfirm, this.titulo = 'Seleccionar Clientes', this.textoBoton = 'Agregar clientes...'});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return MultiSelectDialogField<Cliente>(
      items: clientes.map((c) => MultiSelectItem<Cliente>(c, c.nombre)).toList(),
      title: Text(titulo),
      searchable: true,
      chipDisplay: MultiSelectChipDisplay.none(),
      buttonIcon: Icon(
        Icons.person_add_alt_1_rounded,
        color: colorScheme.primary,
      ),
      buttonText: Text(
        textoBoton,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white70 : Colors.black54),
      ),
      decoration: BoxDecoration(
        color: isDark? Colors.white.withValues(alpha: .05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      selectedColor: colorScheme.primary,
      searchHint: 'Buscar cliente',
      confirmText: Text(
        'Aceptar',
        style: TextStyle(
          color:colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      cancelText: Text(
        'Cancelar',
        style: TextStyle(
          color: isDark ? Colors.white70: Colors.black54,
        ),
      ),
      onConfirm: (values) {
        onConfirm(values);
      },
    );
  }
}