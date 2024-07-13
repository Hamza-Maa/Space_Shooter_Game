import 'package:flame/components.dart';
import 'package:tuto_test/objects/bullet.dart';
import 'package:tuto_test/main_app.dart';
import 'package:flame/collisions.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  late final SpawnComponent _bulletSpawner;
  int health = 100; // Initial health
  int score = 0; // Initial score

  Player()
      : super(
          size: Vector2(80, 130),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'player2.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(32, 48),
      ),
    );

    position = game.size / 2;
    _bulletSpawner = SpawnComponent(
      period: .4, //speed of firing
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position +
              Vector2(
                0,
                -height / 2,
              ),
        );
      },
      autoStart: false,
    );

    game.add(_bulletSpawner);
    add(RectangleHitbox());
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      game.gameOver();
    }
  }

  void incrementScore(int points) {
    score += points;
  }

  void resetScore() {
    score = 0; // Reset score to 0
  }
}
