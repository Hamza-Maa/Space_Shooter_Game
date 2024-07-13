import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthBarSegment extends PositionComponent {
  final Paint _paint;

  HealthBarSegment({
    required bool isFilled,
    required Vector2 position,
    required Vector2 size,
  })  : _paint = Paint()
          ..shader = LinearGradient(
            colors: isFilled
                ? [Colors.yellow, Colors.orange]
                : [Colors.grey, Colors.grey.shade600],
          ).createShader(Rect.fromLTWH(0, 0, size.x, size.y)),
        super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final rect =
        RRect.fromRectAndRadius(size.toRect(), const Radius.circular(4));
    canvas.drawRRect(rect, _paint);
  }

  void updateColor(bool isFilled) {
    _paint.shader = LinearGradient(
      colors: isFilled
          ? [Colors.yellow, Colors.orange]
          : [Colors.grey, Colors.grey.shade600],
    ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
  }
}
