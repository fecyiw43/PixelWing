// import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BackButton extends PositionComponent {
  BackButton({required this.gameRef});
  final FlameGame gameRef;

  @override
  void render(Canvas c) {
    // render your button here
  }

  @override
  void update(double t) {
    // update your button here
  }

  void onTapDown() {
    // Navigate back to the main page
    // Navigator.of(gameRef.context).pop();
  }
}
