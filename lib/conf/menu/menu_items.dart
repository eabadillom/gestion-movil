import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

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

List<MenuItems> obtenerMenuItems(UsuarioDetalle? usuario) 
{
  final appMenuItem = <MenuItems> [
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

    MenuItems(
      title: 'Entradas',
      link: '/entradas',
      icon: FontAwesomeIcons.rightToBracket
    ),

    MenuItems(
      title: 'Salidas',
      link: '/salidas',
      icon: FontAwesomeIcons.rightFromBracket
    ),

    MenuItems(
      title: 'Inventarios',
      link: '/inventarios',
      icon: FontAwesomeIcons.clipboardList
    ),

  ];

  if (usuario?.perfil == 2 || usuario?.perfil == 3) 
  {
    appMenuItem.add(
      MenuItems(
        title: 'Candado Salida',
        link: '/candadoSalida',
        icon: FontAwesomeIcons.lock
      ),
    );
  }

  return appMenuItem;
}
