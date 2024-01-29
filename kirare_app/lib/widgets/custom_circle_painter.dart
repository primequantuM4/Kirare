import 'package:flutter/material.dart';

class CustomCirclePainter extends CustomPainter {
  final List<int> scaleKeys;

  CustomCirclePainter({
    super.repaint,
    required this.scaleKeys,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint blackStroke = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Paint whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint blackFill = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Outer circle
    canvas.drawCircle(Offset(centerX, centerY), 119, blackStroke);
    // Inner circles
    final List<Map<String, double>> circles = [
      {"radius": 25, "dx": 0, "dy": -119},
      {"radius": 25, "dx": 59, "dy": -104},
      {"radius": 25, "dx": 103, "dy": -60},
      {"radius": 25, "dx": 119, "dy": 0},
      {"radius": 25, "dx": 103, "dy": 59},
      {"radius": 25, "dx": 59, "dy": 103},
      {"radius": 25, "dx": 0, "dy": 119},
      {"radius": 25, "dx": -60, "dy": 103},
      {"radius": 25, "dx": -104, "dy": 59},
      {"radius": 25, "dx": -119, "dy": 0},
      {"radius": 25, "dx": -104, "dy": -60},
      {"radius": 25, "dx": -60, "dy": -104},
    ];
    int roundKeys = 1;
    for (final circle in circles) {
      canvas.drawCircle(
        Offset(centerX + circle['dx']!, centerY + circle['dy']!),
        circle['radius']!,
        scaleKeys.contains(roundKeys) ? blackFill : whiteFill,
      );
      canvas.drawCircle(
        Offset(centerX + circle['dx']!, centerY + circle['dy']!),
        circle['radius']!,
        blackStroke,
      );
      roundKeys++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
