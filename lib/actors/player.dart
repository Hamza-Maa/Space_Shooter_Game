import 'package:flame/components.dart';
import 'package:tuto_test/objects/bullet.dart';
import 'package:tuto_test/main_app.dart';
import 'package:flame/collisions.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  late final SpawnComponent _bulletSpawner;
  int health = 100; // Initial health

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
      period: .2,
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
      // Implement game over logic or other actions when health reaches zero
      print('Game Over!');
      // Example: Reset player position or end game
      // position = game.size / 2;
       game.gameOver();
    }
  }
}
