import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Параллельные диагональные штрихи внутри круга (как в ячейке недельного расписания).
void paintDiagonalStripeHatchInCircle(
  Canvas canvas,
  Size size,
  Offset center,
  double radius, {
  required bool isDark,
}) {
  canvas.save();
  canvas.clipPath(
    Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
  );

  // Лёгкая «бумажная» подложка под линии
  final wash = Paint()
    ..color = isDark
        ? const Color(0xFF3A3A3C).withValues(alpha: 0.35)
        : const Color(0xFFECECEF);
  canvas.drawRect(Offset.zero & size, wash);

  final lineColor = isDark
      ? const Color(0xFF8E8E93).withValues(alpha: 0.65)
      : const Color(0xFFAEAEB2);
  final line = Paint()
    ..color = lineColor
    ..strokeWidth = 1.0
    ..isAntiAlias = true;

  const spacing = 4.0;
  final span = radius * 3.0;

  canvas.translate(center.dx, center.dy);
  canvas.rotate(math.pi / 4);
  canvas.translate(-center.dx, -center.dy);

  for (var y = -span; y <= span; y += spacing) {
    canvas.drawLine(
      Offset(center.dx - span, center.dy + y),
      Offset(center.dx + span, center.dy + y),
      line,
    );
  }

  canvas.restore();
}
