import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItems 
{
  final String title;
  final String link;
  final IconData icon;

  const MenuItems({
    required this.title,
    required this.link,
    required this.icon,
  });
}

const appMenuItem = <MenuItems> [
  MenuItems(
    title: 'Posiciones por planta',
    link: '/posiciones',
    icon: FontAwesomeIcons.warehouse,
  ),

  MenuItems(
    title: 'Kardex',
    link: '/kardex',
    icon: FontAwesomeIcons.tableList,
  ),

];
