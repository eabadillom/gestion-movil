import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class RenombrarFotoDialog extends StatefulWidget 
{
  final String nombreActual;
  final bool Function(String nombre) existeNombre;

  const RenombrarFotoDialog({super.key, required this.nombreActual, required this.existeNombre});

  @override
  State<RenombrarFotoDialog> createState() => _RenombrarFotoDialogState();
}

class _RenombrarFotoDialogState extends State<RenombrarFotoDialog> 
{
  late final TextEditingController _controller;
  late String nombre;
  late String extension;
  late String nombreSinExtension;
  String? _error;

  @override
  void initState() 
  {
    super.initState();

    nombre = widget.nombreActual;
    extension = path.extension(nombre);

    if (extension.isEmpty) {
      extension = '.jpg';
      nombreSinExtension = nombre;
    } else {
      nombreSinExtension = path.basenameWithoutExtension(nombre);
    }

    _controller = TextEditingController(text: nombreSinExtension);
  }

  @override
  void dispose() 
  {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final tamanoPantalla = MediaQuery.sizeOf(context);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: const Text('Renombrar fotografía'),
      content: SizedBox(
        width: tamanoPantalla.width * 0.85,
        child: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Nombre de la fotografía',
            suffixText: extension,
            hintText: 'Ej. Evidencia_Entrada_1',
            errorText: _error,
          ),
          onChanged: (_) 
          {
            if (_error != null) {
              setState(() {
                _error = null;
              });
            }
          },
          onSubmitted: (_) => _guardar(),
        ),
      ),
      actions: 
      [
        TextButton(
          onPressed: () 
          {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  void _guardar() async
  {
    final nuevoNombre = _controller.text.trim();

    if (nuevoNombre.isEmpty) 
    {
      setState(() {
        _error = 'Escribe un nombre para la fotografía.';
      });
      return;
    }

    if (RegExp(r'[/\\:*?"<>|]').hasMatch(nuevoNombre)) 
    {
      setState(() {
        _error = 'El nombre contiene caracteres no permitidos.';
      });
      return;
    }

    final nombreCompleto = '$nuevoNombre$extension';

    if (widget.existeNombre(nombreCompleto)) 
    {
      setState(() {
        _error = 'Ya existe una fotografía con ese nombre.';
      });
      return;
    }

    Navigator.of(context).pop(nombreCompleto);
  }

}
