import 'dart:math';

import 'package:flame/components.dart';

import 'game.dart';
import 'obstacles.dart';

class MulObs extends PositionComponent with HasGameRef<PixelWing> {
  bool _hasScored = false;
  static final _random = Random();
  late List<Box> _topBoxes, _bottomBoxes;

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;
    final gameHeight = gameRef.size.y;
    final boxHeight = Box.initialSize.y;

    final stackHeight = 8 - _random.nextInt(8);
    final stackHeight_2 = 8 - stackHeight;
    final boxSpacing = boxHeight * (6 / 11);

    final topBox = gameHeight - boxHeight;
    final bottomBox = -boxHeight / 3;

    _topBoxes = List.generate(stackHeight, (index) {
      return Box(
        position: Vector2(0, topBox + index * boxSpacing * -1),
      );
    });
    _bottomBoxes = List.generate(stackHeight_2, (index) {
      return Box(
        position: Vector2(0, bottomBox + index * boxSpacing),
      );
    });
    addAll(_topBoxes);
    addAll(_bottomBoxes);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if ((gameRef.gameHasStarted == false) ||
        (gameRef.pause == true) ||
        (position.x < Box.initialSize.x - 300)) {
      removeFromParent();
    }
    if (gameRef.player.x > position.x && !_hasScored) {
      gameRef.updateScore(true);
      _hasScored = true;
    }
    position.x -= gameRef.speed * dt;
  }
}
