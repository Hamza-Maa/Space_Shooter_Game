import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuto_test/main_app.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  Bullet({
    super.position,
  }) : super(
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'bullet2.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 1.3,
        textureSize: Vector2(32, 32),
      ),
    );
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -500; //speed of the bullet

    if (position.y < -height) {
      removeFromParent();
    }
  }
}
