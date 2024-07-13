import 'package:flame/components.dart';
import 'package:tuto_test/main_app.dart';

class CoinEffect extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  CoinEffect({
    super.position,
  }) : super(
    size: Vector2.all(50),
    anchor: Anchor.center,
    removeOnFinish: true,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'coin_effect2.png',
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: .1,
        textureSize: Vector2(51.33, 36),
        loop: false,
      ),
    );
  }
}
