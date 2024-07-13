import 'package:flame/components.dart';
import 'package:tuto_test/widgets/HealthBarSegment.dart';

class HealthBar extends PositionComponent {
  final int maxSegments;
  int currentSegments;
  late List<HealthBarSegment> segments;

  HealthBar({
    required this.maxSegments,
    required this.currentSegments,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position) {
    segments = List.generate(maxSegments, (index) {
      return HealthBarSegment(
        isFilled: index < currentSegments,
        position: Vector2(index * (size.x / maxSegments + 4),
            0), // Adjust position with spacing
        size: Vector2(size.x / maxSegments - 4,
            size.y), // Adjust size to fit the whole bar with spacing
      );
    });
    addAll(segments);
  }

  void updateSegments(int newSegments) {
    currentSegments = newSegments;
    for (int i = 0; i < maxSegments; i++) {
      segments[i].updateColor(i < currentSegments);
    }
  }
}
