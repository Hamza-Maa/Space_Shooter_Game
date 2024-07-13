import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends PositionComponent {
  int score;
  late TextPainter _textPainter;
  final TextStyle _textStyle;

  ScoreText({
    required this.score,
    required Vector2 position,
  })  : _textStyle = TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [Colors.yellow, Colors.orange],
            ).createShader(const Rect.fromLTWH(0, 0, 100, 40)),
        ),
        super(position: position) {
    _updateTextPainter();
  }

  void _updateTextPainter() {
    _textPainter = TextPainter(
      text: TextSpan(text: 'Score: $score', style: _textStyle),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void render(Canvas canvas) {
    _textPainter.paint(canvas, Offset.zero);
  }

  void updateScore(int newScore) {
    score = newScore;
    _updateTextPainter();
  }
}
