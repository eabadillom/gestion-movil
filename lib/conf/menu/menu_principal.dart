import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

List<MenuItems> obtenerMenuPrincipal(UsuarioDetalle? usuario) 
{
  final appMenuItem = <MenuItems> [
    MenuItems(
      title: 'Inventarios',
      link: '/inventarios',
      icon: 'list-check-solid-full.svg',
        
    ),

    MenuItems(
      title: 'Reportes',
      link: '/reportes',
      icon: 'chart-column-solid-full.svg',
    ),

  ];

  if (usuario?.perfil == 2 || usuario?.perfil == 3) 
  {
    appMenuItem.add(
      MenuItems(
        title: 'Facturación',
        link: '/facturacion',
        icon: 'file-invoice-dollar-solid-full.svg',
      ),
    );

  }

  return appMenuItem;
}
