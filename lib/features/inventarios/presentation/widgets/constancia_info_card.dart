import 'package:flutter/material.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaInfoCard extends StatelessWidget
{
  final ConstanciaDetalle constancia;
  final TipoConstancia tipo;

  const ConstanciaInfoCard({super.key, required this.constancia, required this.tipo});

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Información de la constancia', Icons.info_outline_rounded),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(context, icon: Icons.calendar_month_rounded, label: 'Fecha', value: _formatFecha(constancia.fecha)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(context, icon: Icons.description_outlined, label: 'Tipo', value: _nombreTipo()),
                    ),
                  ],
                ),
                if (_tieneTransporte()) 
                ...[
                  const SizedBox(height: 18),
                  Row(
                    children: 
                    [
                      Expanded(
                        child: _buildInfoItem(context, icon: Icons.person_outline_rounded, label: 'Transportista', value: _texto(constancia.nombreTransportista)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoItem(context, icon: Icons.directions_car_outlined, label: 'Placas', value: _texto(constancia.placasTransporte)),
                      ),
                    ],
                  ),
                ],
                if (_tieneTemperatura()) ...[
                  const SizedBox(height: 18),
                  _buildInfoItem(context, icon: Icons.thermostat_outlined, label: 'Temperatura', value: _texto(constancia.temperatura)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildObservaciones(context),
      ],
    );
  }

  bool _tieneTransporte()
  {
    return _tieneTexto(constancia.nombreTransportista) || _tieneTexto(constancia.placasTransporte);
  }

  bool _tieneTemperatura()
  {
    return _tieneTexto(constancia.temperatura);
  }

  bool _tieneTexto(String? valor)
  {
    return valor != null && valor.trim().isNotEmpty;
  }

  String _texto(String? valor)
  {
    return _tieneTexto(valor) ? valor! : 'No especificado';
  }

  Widget _buildObservaciones(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Observaciones', Icons.notes_rounded),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _tieneTexto(constancia.observaciones) ? constancia.observaciones! : 'Sin observaciones',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon)
  {
    return Row(
      children: 
      [
        Icon(
          icon,
          size: 21,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, {required IconData icon, required String label, required String value})
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        Icon(
          icon,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _nombreTipo()
  {
    switch (tipo)
    {
      case TipoConstancia.deposito:
        return 'Entrada';
      case TipoConstancia.salida:
        return 'Salida';
      case TipoConstancia.servicio:
        return 'Servicio';
      case TipoConstancia.traspaso:
        return 'Traspaso';
    }
  }

  String _formatFecha(DateTime? fecha)
  {
    if (fecha == null)
    {
      return 'No especificada';
    }

    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }
}
