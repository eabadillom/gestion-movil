import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestion_movil/conf/config.dart';

Widget buildIconMenu(MenuItems item, Color appBarColor) 
{
  final mainIcon = SvgPicture.asset(
    'assets/svg/${item.icon}',
    width: 30,
    height: 30,
    colorFilter: ColorFilter.mode(appBarColor, BlendMode.srcIn),
  );
  
  Widget iconWidget = mainIcon;

  if (item.overlayIcon != null) 
  {
    iconWidget = Stack(
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

  if (item.prefixIcon == null && item.suffixIcon == null) {
    return iconWidget;
  }

  Widget? prefix;
  Widget? suffix;

  if (item.prefixIcon != null) {
    prefix = SvgPicture.asset(
      'assets/svg/${item.prefixIcon}',
      width: 25,
      height: 25,
      colorFilter: ColorFilter.mode(appBarColor, BlendMode.srcIn),
    );
  }

  if (item.suffixIcon != null) {
    suffix = SvgPicture.asset(
      'assets/svg/${item.suffixIcon}',
      width: 25,
      height: 25,
      colorFilter: ColorFilter.mode(appBarColor, BlendMode.srcIn),
    );
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (prefix != null) ...[
        prefix,
        const SizedBox(width: 4),
      ],

      iconWidget,

      if (suffix != null) ...[
        const SizedBox(width: 4),
        suffix,
      ],
    ],
  );
}
