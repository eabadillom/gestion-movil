import 'package:flutter/material.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaServicioCard extends StatelessWidget
{
  final Servicio servicio;

  const ConstanciaServicioCard({super.key, required this.servicio});

  @override
  Widget build(BuildContext context)
  {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [
            if (servicio.descripcion != null && servicio.descripcion!.trim().isNotEmpty)
              Text(
                servicio.descripcion ?? 'Servicio',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildDato(
                    context,
                    icon: Icons.numbers_outlined,
                    label: 'Cantidad',
                    value: _formatNumero(servicio.cantidad),
                  ),
                ),
                if (servicio.precio != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDato(
                      context,
                      icon: Icons.attach_money,
                      label: 'Precio',
                      value: _formatMoneda(servicio.precio),
                    ),
                  ),
                ],
              ],
            ),
            if (servicio.subtotal != null && servicio.subtotal != 0) ...[
              const SizedBox(height: 14),
              _buildDato(
                context,
                icon: Icons.calculate_outlined,
                label: 'Subtotal',
                value: _formatMoneda(servicio.subtotal),
              ),
            ],
          ],
        )
      ),
    );
  }

  Widget _buildDato(BuildContext context, {required IconData icon, required String label, required String value})
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }


  String _formatNumero(double? valor)
  {
    if (valor == null)
    {
      return '0';
    }

    return valor % 1 == 0 ? valor.toInt().toString() : valor.toString();
  }


  String _formatMoneda(double? valor)
  {
    if (valor == null)
    {
      return '\$0.00';
    }

    return '\$${valor.toStringAsFixed(2)}';
  }
}
