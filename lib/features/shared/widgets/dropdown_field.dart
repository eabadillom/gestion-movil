import 'package:flutter/material.dart';

class DropdownField <T> extends StatelessWidget
{
  final String label;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry margin;

  const DropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.margin =const EdgeInsets.only(bottom: 16),
  });

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final isEnabled = onChanged != null;

    return Container(
      margin: margin,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        elevation: 8,
        icon: Icon(
          Icons.arrow_drop_down_circle_rounded,
          color: colorScheme.primary,
          size: 22,
        ),
        dropdownColor: isDark ? const Color(0xFF252525) : Colors.white,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isEnabled ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
        decoration:InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400,
            fontSize: 14,
          ),
          floatingLabelStyle: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              right: 8,
              left: 12,
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF2C2C2C): Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 24,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3), width: 1),
          ),
        ),

        items: items.map((item) 
        {
          return DropdownMenuItem<T>(
            value: item.value,
            child: Container(
              constraints:const BoxConstraints(minHeight: 48,),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(
                  bottom:BorderSide(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: 
                [
                  Icon(
                    Icons.label_important_outline_rounded,
                    size: 18,
                    color: colorScheme.primary.withValues(alpha: .60),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.2,
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),

                      child: item.child,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
