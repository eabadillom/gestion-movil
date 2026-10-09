import 'package:flutter/material.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'constancia_servicio_card.dart';

class ConstanciaServicios extends StatelessWidget
{
  final List<Servicio> servicios;

  const ConstanciaServicios({super.key, required this.servicios});

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        Row(
          children: [
            Icon(
              Icons.miscellaneous_services_outlined,
              size: 21,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Servicios (${servicios.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: servicios.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index)
          {
            return ConstanciaServicioCard(servicio: servicios[index]);
          },
        ),
      ],
    );
  }
}
