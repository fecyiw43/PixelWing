import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/animation.dart';

import 'game.dart';

double inc = 0;

final random = Random();
final index = random.nextInt(8) + 1;

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<PixelWing> {
  Player()
      : super(
          size: Vector2(80, 80),
          position: Vector2(50, 50),
        ); // player size and position

  @override
  Future<void>? onLoad() async {
    // debugMode = true;
    add(
      CircleHitbox(
        // hitbox of player
        radius: 21,
        position: Vector2(17, 21),
      ), //..debugPaint.strokeWidth = 1,
    );
    final image =
        await Flame.images.load('Flying_$index.png'); // selected player sprite
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: 0.10,
        textureSize: Vector2.all(16),
      ),
    );
    return super.onLoad();
  }

  // collision method
  @override
  Future<void> onCollisionStart(_, __) async {
    super.onCollisionStart(_, __);
    gameRef.gameHasStarted = false;
    gameRef.gameover(true);
  }

  // physics engine (gravity)
  @override
  Future<void> update(double dt) async {
    super.update(dt);
    position.y += 300 * dt + gameRef.speed / 300;
    if (inc <= 20) {
      inc = gameRef.speed / 10;
    }
    if (gameRef.updateSprite == true) {
      final random = Random();
      final index = random.nextInt(8) + 1;
      final image = await Flame.images.load('Flying_$index.png');
      animation = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 11,
          stepTime: 0.10,
          textureSize: Vector2.all(16),
        ),
      );
      gameRef.updateSprite = false;
    }
  }

  // flying method
  void fly() {
    final effect = MoveByEffect(
      Vector2(0.0, -130 - inc),
      EffectController(duration: 0.4, curve: Curves.decelerate),
    );
    add(effect);
  }
}
