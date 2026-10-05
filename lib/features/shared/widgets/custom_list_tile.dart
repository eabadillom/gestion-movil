import 'package:flutter/material.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:go_router/go_router.dart';

class CustomListTile extends StatelessWidget 
{
  const CustomListTile({super.key, required this.menuItem});

  final MenuItems menuItem;

  @override
  Widget build(BuildContext context) 
  {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push(menuItem.link!),
      splashColor: colors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIconMenu(menuItem, Theme.of(context).expansionTileTheme.iconColor!),
            const SizedBox(height: 10),
            Text(
              menuItem.title, 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), 
              textAlign: TextAlign.center
            ),
          ],
        ),
      ),
    );
  }
}
