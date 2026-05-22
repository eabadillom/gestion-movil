import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget 
{
  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;
  final IconData? icon;

  const CustomFilledButton({
    super.key, 
    this.onPressed, 
    required this.text, 
    this.buttonColor,
    this.icon
  });

  @override
  Widget build(BuildContext context) 
  {
    const radius = Radius.circular(10);

    final style = FilledButton.styleFrom(
      backgroundColor: buttonColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: radius,
          bottomRight: radius,
          topLeft: radius,
        ),
      ),
    );

    if (icon != null) // Si tiene icono
    {
      return FilledButton.icon(
        style: style,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
      );
    }

    return FilledButton( // Sin icono
      style: style,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}