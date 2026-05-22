import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListaTarjetaGenerica<T> extends StatelessWidget 
{
  final List<T> items; // Lista genérica de elementos
  final String Function(T item) getTitle; // Función para obtener el título
  final String Function(T item)? getSubtitle; // Función para obtener el subtítulo
  final String Function(T item)? getRoute; // Función para obtener la ruta de navegación
  final Object? Function(T item)? getExtra; // Función para mandar un objeto en la ruta
  final Color? Function(T)? getBackgroundColor; // Funcion para obtener el color de la tarjeta (opcional)
  final IconData Function(T item)? getIcon;
  final Future<void> Function(T)? onTap;

  const ListaTarjetaGenerica({
    super.key,
    required this.items,
    required this.getTitle,
    this.getSubtitle,
    this.getRoute,
    this.getExtra,
    this.getBackgroundColor,
    this.getIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) 
  {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      padding: const EdgeInsets.only(bottom: 12),
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
    
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () async {
              if (onTap != null) {
                await onTap!(item);
              } else if (getRoute != null) {
                context.push(getRoute!(item), extra: getExtra?.call(item));
              }
            },
          
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
          
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      getIcon?.call(item) ?? Icons.person,
                      color: colors.primary,
                      size: 28,
                    ),
                  ),
          
                  const SizedBox(width: 16),
          
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTitle(item),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
          
                        if (getSubtitle != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            getSubtitle!(item),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          
                  const SizedBox(width: 12),
          
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
