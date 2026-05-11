import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PdfProgressWidget extends StatelessWidget 
{
  final double progress;
  final bool isReady;

  const PdfProgressWidget({super.key, required this.progress, required this.isReady});

  @override
  Widget build(BuildContext context) 
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 80,
          lineWidth: 12,
          percent: progress.clamp(0.0, 1.0),
          center: Text(
            "${(progress.clamp(0.0, 1.0) * 100).toInt()}%",
            style: const TextStyle(fontSize: 18),
          ),
          progressColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.grey.shade200,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animateFromLastPercent: true,
        ),

        const SizedBox(height: 24),

        Text(
          isReady ? '¡Documento listo!' : 'Generando reporte...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
