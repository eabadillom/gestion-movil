import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/login/domain/domain.dart';

List<MenuItems> obtenerMenuInventarios(UsuarioDetalle? usuario) 
{
  final appMenuItem = <MenuItems>  [
    MenuItems(
      title: 'Entradas',
      link: '/menuConstanciasEntradas',
      prefixIcon: 'arrow-right-solid-full.svg',
      icon: 'warehouse-solid-full.svg',
    ),

    MenuItems(
      title: 'Salidas',
      link: '/menuConstanciasSalidas',
      icon: 'warehouse-solid-full.svg',
      suffixIcon: 'arrow-right-solid-full.svg',
    ),
    
    MenuItems(
      title: 'Traspasos',
      link: '/menuConstanciasTraspasos',
      prefixIcon: 'warehouse-solid-full.svg',
      icon: 'right-left-solid-full.svg',
      suffixIcon: 'warehouse-solid-full.svg',
    ),
    
    MenuItems(
      title: 'Servicios',
      link: '/menuConstanciasServicios',
      icon: 'cart-flatbed-solid-full.svg',
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
  }

  return appMenuItem;
}
