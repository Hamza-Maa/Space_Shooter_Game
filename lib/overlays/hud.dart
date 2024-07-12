import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tuto_test/widgets/HealthBar.dart';
import 'package:tuto_test/main_app.dart'; // Import the main app to access player

class HUD extends PositionComponent
    with HasGameRef<SpaceShooterGame>, TapCallbacks {
  late final SpriteComponent pauseButton;
  late HealthBar healthBar;

  @override
  Future<void> onLoad() async {
    final sprite = await gameRef.loadSprite('pause.png');

    pauseButton = SpriteComponent(
      sprite: sprite,
      size: Vector2(40, 40),
      position: Vector2(gameRef.size.x - 30, 40),
      anchor: Anchor.topRight,
    );

    add(pauseButton);

    healthBar = HealthBar(
      maxSegments: 5, // Set to 5 segments
      currentSegments: 5, // Start with full health
      position: Vector2(20, 50), // Adjust position as needed
      size: Vector2(120, 20), // Define the size of the health bar
    );
    add(healthBar);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update the health bar based on the player's current health
    updateHealthBar(gameRef.player.health);
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

  void updateHealthBar(int currentHealth) {
    healthBar.updateSegments((currentHealth / 100 * 5)
        .toInt()); // Adjust to fit the number of segments
  }
}

