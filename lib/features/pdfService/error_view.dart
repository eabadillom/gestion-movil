import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget 
{
  final String mensaje;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.mensaje, required this.onRetry});

  @override
  Widget build(BuildContext context) 
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}