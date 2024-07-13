import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:tuto_test/actors/enemy.dart';
import 'package:tuto_test/objects/coin.dart';
import 'package:tuto_test/overlays/game_over_menu.dart';
import 'package:tuto_test/overlays/hud.dart';
import 'package:tuto_test/actors/player.dart';
import 'package:tuto_test/overlays/pause_menu.dart';

class SpaceShooterGame extends FlameGame
    with
        HasGameReference<SpaceShooterGame>,
        PanDetector,
        HasCollisionDetection,
        TapCallbacks {
  late Player player;
  late HUD hud;
  late SpawnComponent enemySpawner;
  late SpawnComponent coinSpawner;

  @override
  Future<void> onLoad() async {
    //debugger Mode
    debugMode = false;
    // Initialize audio
    //FlameAudio.bgm.initialize();
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('1.png'),
        ParallaxImageData('2.png'),
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
    startEnemySpawning();
    startCoinSpawning();
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

  void startCoinSpawning() {
    coinSpawner = SpawnComponent(
      factory: (index) {
        return Coin();
      },
      period: 3,
      area: Rectangle.fromLTWH(0, 0, size.x, -Coin.coinSize),
    );

    add(coinSpawner);
  }

  //clear coin
  void clearAndResetCoinSpawns() {
    // Clear existing coins
    children.whereType<Coin>().forEach((coin) => coin.removeFromParent());
    // Remove and re-add the coin spawner to reset it
    coinSpawner.removeFromParent();
    startCoinSpawning();
  }

  //clear enemy
  void clearAndResetEnemySpawns() {
    // Clear existing coins
    children.whereType<Enemy>().forEach((enemy) => enemy.removeFromParent());
    // Remove and re-add the coin spawner to reset it
    enemySpawner.removeFromParent();
    startEnemySpawning();
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
    pauseEngine();
    overlays.add('GameOver');
  }

  void resetGame() {
    player.position = size / 2;
    player.health = 100;
    player.resetScore();
    clearAndResetCoinSpawns(); // Clear and reset coin spawns
    clearAndResetEnemySpawns();
    overlays.remove('GameOver');
    resumeEngine();
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
        'GameOver': (context, game) => GameOver(
            game: game,
            onRetry: game.resetGame,
            score: game.player.score), // Pass the score to GameOver
      },
      initialActiveOverlays: const [],
    );
  }
}
