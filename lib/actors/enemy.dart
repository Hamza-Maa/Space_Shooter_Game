import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuto_test/actors/player.dart';
import 'package:tuto_test/objects/bullet.dart';
import 'package:tuto_test/objects/explosion.dart';
import 'package:tuto_test/main_app.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Enemy()
      : super(
    size: Vector2.all(enemySize),
    anchor: Anchor.center,
  );

  static const enemySize = 140.0;
  static const damage = 20; // Damage inflicted on collision

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'enemy3.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(128),
      ),
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 250;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      print('Bullet work!');
      removeFromParent();
      other.removeFromParent();
      game.add(Explosion(position: position));
    }

    if (other is Player) {
      print('Player collided with enemy!');
      other.takeDamage(damage); // Apply damage to the player
      game.add(Explosion(position: position)); // Add explosion effect
      removeFromParent();
    }
  }
}
