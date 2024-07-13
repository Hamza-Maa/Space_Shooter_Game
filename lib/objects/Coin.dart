import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tuto_test/actors/player.dart';
import 'package:tuto_test/main_app.dart';
import 'package:tuto_test/widgets/coin_effect.dart';

class Coin extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Coin()
      : super(
          size: Vector2.all(coinSize),
          anchor: Anchor.center,
        );

  static const coinSize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'coin.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: .2,
        textureSize: Vector2.all(16),
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

    if (other is Player) {
      FlameAudio.play('coin_pickup.mp3'); // sound effects
      other.incrementScore(1); // Increment score by 10 points
      game.add(CoinEffect(position: position));
      removeFromParent();
    }
  }
}
