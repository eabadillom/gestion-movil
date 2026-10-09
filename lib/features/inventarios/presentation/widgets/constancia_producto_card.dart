import 'package:flutter/material.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaProductoCard extends StatelessWidget
{
  final Producto producto;
  final TipoConstancia tipo;

  const ConstanciaProductoCard({super.key, required this.producto, required this.tipo});

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
            Text(
              _texto(producto.descripcion),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (producto.piezas != null)
                  Expanded(
                    child: _buildDato(context, icon: Icons.inventory_2_outlined, label: 'Piezas', value: producto.piezas.toString()),
                  ),
                if (producto.peso != null)
                  Expanded(
                    child: _buildDato(context, icon: Icons.scale_outlined, label: 'Peso', value: _formatearPeso(producto.peso),),
                  ),
              ],
            ),
            if (_tieneTexto(producto.unidad) || producto.cantidadCobro != null)
              const SizedBox(height: 14),
            if (_tieneTexto(producto.unidad) || producto.cantidadCobro != null)
              Row(
                children: 
                [
                  if (producto.cantidadCobro != null)
                    Expanded(
                      child: _buildDato(context, icon: Icons.numbers_outlined, label: 'Cantidad', value: '${producto.cantidadCobro}'),
                    ),
                  if (_tieneTexto(producto.unidad))
                    Expanded(
                      child: _buildDato(context, icon: Icons.straighten_outlined, label: 'Unidad', value: producto.unidad!),
                    ),
                ],
              ),
            if (_tieneTexto(producto.tarima))
              _buildDatoCompleto(context, icon: Icons.layers_outlined, label: 'Tarima', value: producto.tarima!),
            if (_tieneTexto(producto.folioEntrada))
              _buildDatoCompleto(context, icon: Icons.receipt_long_outlined, label: 'Folio entrada', value: producto.folioEntrada!),
            if (_tieneTexto(producto.camara))
              _buildDatoCompleto(context, icon: Icons.ac_unit_outlined, label: 'Cámara', value: producto.camara!),
            if (tipo == TipoConstancia.traspaso)
              _buildTraspaso(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTraspaso(BuildContext context)
  {
    final tieneOrigen = _tieneTexto(producto.origen);
    final tieneDestino = _tieneTexto(producto.destino);

    if (!tieneOrigen && !tieneDestino)
    {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tieneOrigen)
            _buildDato(context, icon: Icons.login_outlined, label: 'Origen', value: producto.origen!),
          if (tieneDestino) ...[
            const SizedBox(height: 8),
            _buildDato(context, icon: Icons.logout_outlined, label: 'Destino', value: producto.destino!),
          ],
        ],
      ),
    );
  }

  Widget _buildDato(BuildContext context, {required IconData icon, required String label, required String value})
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatoCompleto(BuildContext context, {required IconData icon, required String label, required String value})
  {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: _buildDato(context, icon: icon, label: label, value: value),
    );
  }

  bool _tieneTexto(String? valor)
  {
    return valor != null && valor.trim().isNotEmpty;
  }


  String _texto(String? valor)
  {
    return _tieneTexto(valor) ? valor! : 'Producto sin descripción';
  }

  String _formatearPeso(double? peso) 
  {
    if (peso == null) { 
      return '0 kg';
    }

    if (peso % 1 == 0) {
      return '${peso.toInt()} kg';
    }
    
    return '${peso.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')} kg';
  }

}
