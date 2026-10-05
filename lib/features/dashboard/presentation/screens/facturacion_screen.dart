import 'package:flutter/material.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/shared/shared.dart';

class FacturacionScreen extends StatelessWidget 
{
  const FacturacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = obtenerMenuFacturacion();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturación', textAlign: TextAlign.center),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(4),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 1.2,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) 
        {
          final menuItem = menuItems[index];

          return Card(
            elevation: 2,
            child: CustomListTile(menuItem: menuItem),
          );
        },
      ),
    );
  }
}
