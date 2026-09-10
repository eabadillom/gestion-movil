import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

class MenuItems 
{
  final String title;
  final String link;
  final IconData icon;
  final Widget? customIcon;

  const MenuItems({
    required this.title,
    required this.link,
    required this.icon,
    this.customIcon,
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
      icon: FontAwesomeIcons.fileLines,
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
        title: 'Órdenes de Retiro',
        link: '/ordenSalidas',
        icon: FontAwesomeIcons.rightFromBracket,
        customIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              FontAwesomeIcons.rightFromBracket,
              size: 28,
            ),
            Positioned(
              right: -7,
              top: -7,
              child: Icon(
                FontAwesomeIcons.clock,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );

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
