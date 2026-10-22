class MenuItems {
  final String title;
  final String? link;
  final String icon;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? overlayIcon;
  final double overlayRight;
  final double overlayTop;

  const MenuItems({
    required this.title,
    this.link,
    required this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.overlayIcon,
    this.overlayRight = 0,
    this.overlayTop = 0,
  });
}
