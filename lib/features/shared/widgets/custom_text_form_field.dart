import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget 
{
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isPasswordField;
  final bool enabled;
  final int maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorMessage,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isPasswordField = false,
    this.enabled = true,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> 
{
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPasswordField ? true : widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) 
  {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(18),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,

        onChanged: widget.onChanged,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,

        obscureText: _obscure,
        
        keyboardType: widget.keyboardType,

        maxLines: widget.obscureText ? 1 : widget.maxLines,
        
        style: const TextStyle(fontSize: 18, color: Colors.black87),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,

          floatingLabelStyle: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: colors.primary,
              width: 2,
            ),
          ),
          errorBorder: border.copyWith(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: widget.hint,
          errorText: widget.errorMessage,
          focusColor: colors.primary,
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          suffixIcon: widget.isPasswordField ? IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: _toggleVisibility) : null,
        ),
      ),
    );
  }
}