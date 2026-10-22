import 'package:flutter/material.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/widgets/widgets.dart';

class ConstanciaProductos extends StatefulWidget 
{
  final List<Producto> productos;
  final TipoConstancia tipo;

  const ConstanciaProductos({super.key, required this.productos, required this.tipo});

  @override
  State<ConstanciaProductos> createState() => _ConstanciaProductosState();
}

class _ConstanciaProductosState extends State<ConstanciaProductos> 
{
  bool _expandido = true;

  @override
  Widget build(BuildContext context) 
  {
    final productos = widget.productos;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                InkWell(
                  onTap: () 
                  {
                    setState(() 
                    {
                      _expandido = !_expandido;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Productos (${productos.length})',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Icon(_expandido ? Icons.expand_less : Icons.expand_more),
                      ],
                    ),
                  ),
                ),
                if (_expandido) 
                ...[
                  const Divider(height: 1),
                  ...productos.asMap().entries.map((entry) 
                  {
                    final indice = entry.key;
                    final producto = entry.value;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  'Producto ',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  child: Text(
                                    '${indice + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ConstanciaProductoCard(producto: producto, tipo: widget.tipo),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          ConstanciaTotales(productos: productos),
        ],
      ),
    );
  }

}
