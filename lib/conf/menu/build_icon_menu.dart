import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestion_movil/conf/menu/menu_items.dart';

Widget buildIconMenu(MenuItems item, Color appBarColor) 
{
  final mainIcon = SvgPicture.asset(
    'assets/svg/${item.icon}', 
    width: 30, 
    height: 30, 
    colorFilter: ColorFilter.mode(appBarColor, BlendMode.srcIn)
  );

  if (item.overlayIcon == null) {
    return mainIcon;
  }

  return Stack(
    clipBehavior: Clip.none,
    children: [
      mainIcon,
      Positioned(
        right: item.overlayRight,
        top: item.overlayTop,
        child: SvgPicture.asset(
          'assets/svg/${item.overlayIcon}',
          width: 30,
          height: 30,
          colorFilter: ColorFilter.mode(
            appBarColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    ],
  );
}
