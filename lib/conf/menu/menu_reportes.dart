import 'package:gestion_movil/conf/config.dart';

List<MenuItems> obtenerMenuReportes() 
{
  return const [
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
      link: '/reporteEntradas',
      icon: 'right-to-bracket-solid-full.svg',
    ),
    
    MenuItems(
      title: 'Salidas',
      link: '/reporteSalidas',
      icon: 'right-from-bracket-solid-full.svg',
    ),
    
    MenuItems(
      title: 'Inventarios',
      link: '/reporteInventarios',
      icon: 'clipboard-list-solid-full.svg',
    ),
    
  ];

}
