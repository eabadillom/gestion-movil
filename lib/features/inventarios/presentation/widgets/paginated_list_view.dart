import 'package:flutter/material.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class PaginatedListView<T> extends StatelessWidget 
{
  final bool isLoading;
  final bool isEmpty;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;

  final int paginaActual;
  final int paginaMostrada;
  final int totalPaginas;
  final VoidCallback? onPageAnterior;
  final VoidCallback? onPageSiguiente;

  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;

  final EdgeInsetsGeometry padding;

  const PaginatedListView({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.items,
    required this.itemBuilder,
    required this.paginaActual,
    required this.paginaMostrada,
    required this.totalPaginas,
    this.onPageAnterior,
    this.onPageSiguiente,
    this.emptyIcon = Icons.manage_search_rounded,
    this.emptyTitle = 'Sin resultados',
    this.emptySubtitle = 'Utiliza los filtros para realizar una búsqueda.',
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 140),
  });

  @override
  Widget build(BuildContext context) 
  {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (isEmpty) {
      return Align(
        alignment: const Alignment(0, -0.25),
        child: EstadoInicialBusqueda(icono: emptyIcon, titulo: emptyTitle, subtitulo: emptySubtitle),
      );
    }

    return ListView.builder(
      padding: padding,
      itemCount: items.length + 1,
      itemBuilder: (context, index) 
      {
        if (index == items.length) 
        {
          if (totalPaginas <= 1) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PaginadoWidget(
              paginaActual: paginaActual,
              paginaMostrada: paginaMostrada,
              totalPaginas: totalPaginas,
              onAnterior: paginaActual > 1 ? onPageAnterior : null,
              onSiguiente: paginaActual < totalPaginas ? onPageSiguiente : null,
            ),
          );
        }

        final item = items[index];
        return itemBuilder(context, item);
      },
    );
  }
}
