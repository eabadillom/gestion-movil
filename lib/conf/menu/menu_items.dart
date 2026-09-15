import 'package:gestion_movil/features/login/domain/domain.dart';

class MenuItems 
{
  final String title;
  final String link;
  final String icon;
  final String? overlayIcon;
  final double overlayRight;
  final double overlayTop;

  const MenuItems({
    required this.title,
    required this.link,
    required this.icon,
    this.overlayIcon,
    this.overlayRight = 0,
    this.overlayTop = 0,
  });
}

List<MenuItems> obtenerMenuItems(UsuarioDetalle? usuario) 
{
  final appMenuItem = <MenuItems> [
    MenuItems(
      title: 'Posiciones por planta',
      link: '/posiciones',
      icon: 'warehouse-solid-full.svg',
        
    ),

    MenuItems(
      title: 'Kardex',
      link: '/kardex',
      icon: 'file-lines-regular-full.svg',
    ),

    MenuItems(
      title: 'Entradas',
      link: '/entradas',
      icon: 'right-to-bracket-solid-full.svg',
    ),

    MenuItems(
      title: 'Salidas',
      link: '/salidas',
      icon: 'right-from-bracket-solid-full.svg',
    ),

    MenuItems(
      title: 'Inventarios',
      link: '/inventarios',
      icon: 'clipboard-list-solid-full.svg',
    ),

  ];

  if (usuario?.perfil == 2 || usuario?.perfil == 3) 
  {
    appMenuItem.add(
      MenuItems(
        title: 'Órdenes de Retiro',
        link: '/ordenSalidas',
        icon: 'right-from-bracket-solid-full.svg',
        overlayIcon: 'clock-regular-full.svg',
        overlayRight: -11,
        overlayTop: -19,
      ),
    );

    appMenuItem.add(
      MenuItems(
        title: 'Candado Salida',
        link: '/candadoSalida',
        icon: 'lock-solid-full.svg',
      ),
    );
  }

  return appMenuItem;
}
