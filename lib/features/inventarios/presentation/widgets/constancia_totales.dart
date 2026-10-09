import 'package:flutter/material.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class ConstanciaTotales extends StatefulWidget
{
  final List<Producto> productos;

  const ConstanciaTotales({super.key, required this.productos});

  @override
  State<ConstanciaTotales> createState() => _ConstanciaTotalesState();
}

class _ConstanciaTotalesState extends State<ConstanciaTotales> 
{
  int get totalTarimas 
  {
    return widget.productos
        .map((producto) => producto.tarima)
        .where((tarima) => tarima != null && tarima.isNotEmpty)
        .map((tarima) => tarima!)
        .toSet()
        .length;
  }

  @override
  Widget build(BuildContext context)
  {
    final cantidadTotal = widget.productos.fold<int>(0, (total, producto) => total + (producto.piezas ?? 0));
    final pesoTotal = widget.productos.fold<double>(0.0, (total, producto) => total + (producto.peso ?? 0.0));
    final anchoPantalla = MediaQuery.of(context).size.width;
    final anchoTab = anchoPantalla / 3;
    final tamanoTexto = _tamanoTextoTab(anchoTab);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if(cantidadTotal != 0) ...[
              Expanded(
                child: _buildTotal(context, label: 'Cantidad', value: cantidadTotal.toString(), tamanio: tamanoTexto),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
            ],
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _buildTotal(context, label: 'Peso total', value: _formatearPeso(pesoTotal), tamanio: tamanoTexto),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildTotal(context, label: 'No. tarimas', value: '$totalTarimas', tamanio: tamanoTexto),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal(BuildContext context, {required String label, required String value, required double tamanio})
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: tamanio),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: tamanio),
        ),
      ],
    );
  }

  double _tamanoTextoTab(double anchoTab) 
  {
    if (anchoTab < 100) {
      return 11;
    }

    if (anchoTab < 120) {
      return 12;
    }

    if (anchoTab < 150) {
      return 14;
    }

    return 16;
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
