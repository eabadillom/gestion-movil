import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget
{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children:
        [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ Color(0xFF07111F), Color(0xFF0D47A1), Color(0xFF1976D2) ]
              ),
            ),
          ),

          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent.withValues(alpha: 0.25),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scale(
              duration: 4.seconds,
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.1, 1.1),
            ),
          ),

          Positioned(
            bottom: -120,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withValues(alpha: 0.18),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scale(
              duration: 5.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.black.withValues(alpha: 0.05)),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    boxShadow:
                    [
                      BoxShadow(
                        color: Colors.lightBlueAccent.withValues(alpha: 0.4),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.ac_unit,
                    size: 90,
                    color: Colors.white,
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(begin: -10, end: 10, duration: 2.seconds),

                const SizedBox(height: 35),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      const Text(
                        'Cargando...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.9)),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).rotate(duration: 2.seconds),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
