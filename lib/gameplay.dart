// ignore_for_file: camel_case_types

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'widgets/pausebutton.dart';
import 'widgets/pausemenu.dart';

PixelWing _pixelwing = PixelWing();

class gamePlay extends StatelessWidget {
  const gamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _pixelwing,
          initialActiveOverlays: const [PauseButton.id],
          overlayBuilderMap: {
            PauseButton.id: (BuildContext context, PixelWing gameRef) =>
                PauseButton(
                  gameRef: gameRef,
                ),
            PauseMenu.id: (BuildContext context, PixelWing gameRef) =>
                PauseMenu(
                  gameRef: gameRef,
                ),
          },
        ),
      ),
    );
  }
}
