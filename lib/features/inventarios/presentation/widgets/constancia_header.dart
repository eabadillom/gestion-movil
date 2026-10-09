import 'package:flutter/material.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaHeader extends StatelessWidget
{
  final ConstanciaDetalle constancia;
  final TipoConstancia tipo;

  const ConstanciaHeader({super.key, required this.constancia, required this.tipo});

  @override
  Widget build(BuildContext context)
  {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _icono(),
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Folio',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    constancia.folioCliente ?? 'Sin folio',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Cliente',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    constancia.nombre ?? 'Sin nombre',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _icono()
  {
    switch (tipo)
    {
      case TipoConstancia.deposito:
        return Icons.login_rounded;
      case TipoConstancia.salida:
        return Icons.local_shipping_outlined;
      case TipoConstancia.servicio:
        return Icons.miscellaneous_services_outlined;
      case TipoConstancia.traspaso:
        return Icons.swap_horiz_rounded;
    }
  }

}
