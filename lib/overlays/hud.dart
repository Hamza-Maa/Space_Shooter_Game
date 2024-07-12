import 'package:flame/components.dart';
import 'package:flame/events.dart';


class HUD extends PositionComponent with HasGameRef, TapCallbacks {
  late final SpriteComponent pauseButton;

  @override
  Future<void> onLoad() async {
    final sprite = await gameRef.loadSprite('pause.png'); // Add your pause icon image

    pauseButton = SpriteComponent(
      sprite: sprite,
      size: Vector2(40, 40), // Adjust size as needed
      position: Vector2(gameRef.size.x - 30, 60),
      anchor: Anchor.topRight,
    );

    add(pauseButton);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return pauseButton.containsPoint(point);
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.overlays.add('PauseMenu');
    gameRef.pauseEngine();
  }
}
