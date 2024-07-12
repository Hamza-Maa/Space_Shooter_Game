import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:tuto_test/actors/enemy.dart';
import 'package:tuto_test/overlays/hud.dart';
import 'package:tuto_test/actors/player.dart';
import 'package:tuto_test/overlays/pause_menu.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection, TapCallbacks {
  late Player player;
  late HUD hud;

  @override
  Future<void> onLoad() async {
    //debug mode
    debugMode = false;
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

    add(
      SpawnComponent(
        factory: (index) {
          return Enemy();
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
      ),
    );
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
  /*
  @override
  void update(double dt) {
    super.update(dt);
    hud.updateHealthBar(player.currentHealth); // Update the health bar in HUD
  }
   */
}

class SpaceShooterGameWidget extends StatelessWidget {
  const SpaceShooterGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget<SpaceShooterGame>(
      game: SpaceShooterGame(),
      overlayBuilderMap: {
        'PauseMenu': (context, game) => PauseMenu(game: game),
      },
      initialActiveOverlays: const [],
    );
  }
}
