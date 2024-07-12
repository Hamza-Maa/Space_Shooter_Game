import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:tuto_test/actors/enemy.dart';
import 'package:tuto_test/overlays/game_over_menu.dart';
import 'package:tuto_test/overlays/hud.dart';
import 'package:tuto_test/actors/player.dart';
import 'package:tuto_test/overlays/pause_menu.dart';

class SpaceShooterGame extends FlameGame
    with HasGameReference<SpaceShooterGame> ,PanDetector, HasCollisionDetection, TapCallbacks {
  late Player player;
  late HUD hud;
  late SpawnComponent enemySpawner;

  @override
  Future<void> onLoad() async {
    //debug mode
    debugMode = true;
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('1.png'),
        ParallaxImageData('2.png'),
        // you can add a third one here
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);

    player = Player();
    add(player);

    hud = HUD();
    add(hud);
    startEnemySpawning(); // Start spawning enemies


  }
  void startEnemySpawning() {
    enemySpawner = SpawnComponent(
      factory: (index) {
        return Enemy();
      },
      period: 1,
      area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),

    );

    add(enemySpawner);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }


  void gameOver() {
    // Pause the game when game over
    pauseEngine();

    // Add game over overlay
    overlays.add('GameOver');
  }
  void resetGame() {
    // Reset player position to the center of the screen
    player.position = game.size / 2;

    // Reset player health to initial value
    player.health = 100;
    // Clear existing enemies

    // Resume the game engine
    resumeEngine();
    // Remove 'GameOver' overlay if it exists
    overlays.remove('GameOver');
  }

}

class SpaceShooterGameWidget extends StatelessWidget {
  const SpaceShooterGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget<SpaceShooterGame>(
      game: SpaceShooterGame(),
      overlayBuilderMap: {
        'PauseMenu': (context, game) => PauseMenu(game: game),
        'GameOver': (context, game) => GameOver(game: game, onRetry: game.resetGame), // Add GameOver overlay
      },
      initialActiveOverlays: const [],
    );
  }
}
