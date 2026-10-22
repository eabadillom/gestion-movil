import 'package:flutter/material.dart';

class BarraAccionesFlotante extends StatelessWidget 
{
  final bool isLoading;
  final bool excedeLimite;
  final bool enviado;
  final VoidCallback onComprimir;
  final VoidCallback onLimpiar;
  final VoidCallback onEnviar;

  const BarraAccionesFlotante({super.key, required this.isLoading,required this.excedeLimite, required this.enviado, required this.onComprimir, required this.onLimpiar, required this.onEnviar});

  @override
  Widget build(BuildContext context) 
  {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: 
          [
            Expanded(
              child: _BotonAccionFlotante(
                icono: Icons.folder_zip,
                etiqueta: 'Comprimir',
                isLoading: isLoading,
                onPressed: onComprimir,
              ),
            ),
            Expanded(
              child: _BotonAccionFlotante(
                icono: Icons.delete_sweep_outlined,
                etiqueta: 'Eliminar',
                isLoading: isLoading,
                onPressed: () => _confirmarLimpiarFotos(context, onLimpiar),
              ),
            ),
            Expanded(
              child: _BotonAccionFlotante(
                icono: enviado ? Icons.check_circle : Icons.send_rounded,
                etiqueta: enviado ? 'Enviado' : 'Enviar',
                isLoading: isLoading,
                onPressed: onEnviar,
                color: enviado ? Colors.green : colorScheme.primary,
                colorTexto: colorScheme.onPrimary,
                deshabilitado: excedeLimite || enviado,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarLimpiarFotos(BuildContext context, VoidCallback onLimpiar) async 
  {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar fotografías'),
        content: const Text('¿Estás seguro de que deseas eliminar todas las fotografías? Esta acción no se puede deshacer.'),
        actions: 
        [
          TextButton(
            onPressed: () 
            {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () 
            {
              Navigator.of(context).pop(true);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      onLimpiar();
    }
  }

}

class _BotonAccionFlotante extends StatelessWidget 
{
  final IconData icono;
  final String etiqueta;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color? color;
  final Color? colorTexto;
  final bool deshabilitado;

  const _BotonAccionFlotante({required this.icono, required this.etiqueta, required this.isLoading, required this.onPressed, this.color, this.colorTexto, this.deshabilitado = false});

  @override
  Widget build(BuildContext context) 
  {
    final colorScheme = Theme.of(context).colorScheme;
    final activo = !isLoading && !deshabilitado;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Material(
        color: color ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: activo ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: 
              [
                isLoading && etiqueta == 'Enviar' ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(icono, color: !activo ? colorScheme.onSurface.withValues(alpha: 0.38) : colorTexto ?? colorScheme.onSurface),
                const SizedBox(height: 5),
                Text(
                  etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: !activo ? colorScheme.onSurface.withValues(alpha: 0.38) : colorTexto ?? colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}
