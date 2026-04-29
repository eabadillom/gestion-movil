import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectorFecha extends StatefulWidget 
{
  final DateTime fecha;
  final ValueChanged<DateTime> onFechaChanged;

  const SelectorFecha({
    super.key,
    required this.fecha,
    required this.onFechaChanged,
  });

  @override
  State<SelectorFecha> createState() => _SelectorFechaState();
}

class _SelectorFechaState extends State<SelectorFecha> 
{
  late TextEditingController controller;
  final formato = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: formato.format(widget.fecha),
    );
  }

  @override
  void didUpdateWidget(covariant SelectorFecha oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.text = formato.format(widget.fecha);
  }

  Future<void> seleccionarFecha() async 
  {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: widget.fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (nuevaFecha != null) {
      controller.text = formato.format(nuevaFecha);
      widget.onFechaChanged(nuevaFecha);
    }
  }

  void validarManual(String value) 
  {
    try {
      final fecha = formato.parseStrict(value);
      widget.onFechaChanged(fecha);
    } catch (_) {
      // fecha inválida
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: 'Fecha',
        hintText: 'yyyy-MM-dd',
        prefixIcon: const Icon(Icons.calendar_month),
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit_calendar),
          onPressed: seleccionarFecha,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onFieldSubmitted: validarManual,
      onChanged: validarManual,
    );
  }
}