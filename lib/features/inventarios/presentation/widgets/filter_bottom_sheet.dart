import 'package:flutter/material.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class FilterBottomSheet<T> extends StatelessWidget 
{
  final DraggableScrollableController? panelController;
  final String title;
  
  final T? selectedItem;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onItemChanged;
  
  final DateTime? startDateText;
  final VoidCallback? onSelectStartDate;
  final DateTime? endDateText;
  final VoidCallback? onSelectEndDate;
  
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;
  
  final VoidCallback onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.panelController,
    this.title = 'Filtros de búsqueda',
    required this.selectedItem,
    required this.items,
    required this.itemLabelBuilder,
    required this.onItemChanged,
    this.startDateText,
    this.onSelectStartDate,
    this.endDateText,
    this.onSelectEndDate,
    this.searchController,
    this.searchFocusNode,
    this.onSearchChanged,
    this.searchHint = 'Buscar por folio...',
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      controller: panelController,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.85,
      builder: (context, scrollController) 
      {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              )
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.tune_rounded, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownField<T>(
                  label: 'Cliente',
                  icon: Icons.business_center_rounded,
                  value: selectedItem,
                  items: [
                    DropdownMenuItem<T>(value: null, child: const Text('Todos')),
                    ...items.map<DropdownMenuItem<T>>(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          itemLabelBuilder(item),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: onItemChanged,
                ),
                const SizedBox(height: 14),
                if (startDateText != null && endDateText != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: DateTileWidget(
                          label: 'Desde',
                          date: startDateText!,
                          onTap: onSelectStartDate!,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DateTileWidget(
                          label: 'Hasta',
                          date: endDateText!,
                          onTap: onSelectEndDate!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
                const Divider(),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Por Folio:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BarraBusqueda(
                        controller: searchController,
                        focusNode: searchFocusNode,
                        onChanged: onSearchChanged!,
                        hintText: searchHint,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: onApplyFilters,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Consultar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
