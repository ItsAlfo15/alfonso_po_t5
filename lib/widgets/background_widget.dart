import 'package:flutter/material.dart';

/// Widget de fondo con gradiente oscuro dorado.
/// Envuelve cualquier child para darle el fondo de la app.
class BackGroundWidget extends StatelessWidget {
  final Widget child;

  const BackGroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1400), Color(0xFF0F0F0F), Color(0xFF0F0F0F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.3, 1.0],
        ),
      ),
      child: child,
    );
  }
}