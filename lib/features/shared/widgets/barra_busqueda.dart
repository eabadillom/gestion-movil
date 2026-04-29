import 'package:flutter/material.dart';

class BarraBusqueda extends StatelessWidget 
{
  final void Function(String) onChanged;
  final String hintText;
  final TextEditingController? controller;

  const BarraBusqueda({super.key, required this.onChanged, required this.hintText, this.controller});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : Colors.black45,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colorScheme.primary,
        ),
        suffixIcon: controller != null ? 
          IconButton(
            tooltip: 'Limpiar',
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              controller!.clear();
              onChanged('');
            },
          ): null,
        filled: true,
        fillColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade300,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.7,
          ),
        ),
      ),
    );
  }
}
