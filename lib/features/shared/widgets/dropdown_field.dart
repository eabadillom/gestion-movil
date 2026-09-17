import 'package:flutter/material.dart';

class DropdownField <T> extends StatelessWidget
{
  final String label;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry margin;
  final String searchHint;

  const DropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.margin =const EdgeInsets.only(bottom: 16),
    this.searchHint = 'Buscar...',
  });

  String _getItemText(DropdownMenuItem<T> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? '';
    }

    return item.child.toString();
  }

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final isEnabled = onChanged != null;

    final selectedItem = items.cast<DropdownMenuItem<T>?>().firstWhere((item) => item?.value == value, orElse: () => null);
    final selectedText = selectedItem != null ? _getItemText(selectedItem) : '';

    return Container(
      margin: margin,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isEnabled ? () => _showSearchDialog(context) : null,
        child: InputDecorator(
          decoration: InputDecoration(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const SizedBox(width: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: isEnabled ? () => _showSearchDialog(context) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.search_rounded,
                      size: 19,
                      color: isEnabled ? colorScheme.primary : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
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
            suffixIcon: Icon(
              Icons.arrow_drop_down_circle_rounded,
              color: isEnabled ? colorScheme.primary : Colors.grey,
              size: 22,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          child: Text(
            selectedText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isEnabled ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final searchController = TextEditingController();

    final screenHeight = MediaQuery.of(context).size.height;

    final dialogHeight = (screenHeight * 0.60).clamp(300.0, 600.0);

    showDialog(
      context: context,
      builder: (dialogContext) {
        List<DropdownMenuItem<T>> filteredItems = List.from(items);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(label),
              content: SizedBox(
                width: double.maxFinite,
                height: dialogHeight,
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: searchHint,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colorScheme.primary,
                        ),
                        suffixIcon:
                          searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon( Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    filteredItems = List.from(items);
                                  });
                                },
                              ): null,
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        final search = text.toLowerCase().trim();
                        setState(() {
                          filteredItems = items.where((item) {
                            final itemText = _getItemText(item).toLowerCase();
                            return itemText.contains(search);
                          }).toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filteredItems.isEmpty
                        ? const Center(
                            child: Text( 'No se encontraron resultados'),
                          )
                        : ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final isSelected = item.value == value;

                              return ListTile(
                                leading: Icon(
                                  Icons .label_important_outline_rounded,
                                  size: 20,
                                  color: colorScheme.primary.withValues(alpha: .60),
                                ),
                                title: DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  child: item.child,
                                ),
                                trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: colorScheme.primary,
                                    ) : null,
                                onTap: () {
                                  onChanged?.call(item.value);
                                  Navigator.of(dialogContext).pop();
                                },
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
