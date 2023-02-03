import 'package:flutter/material.dart';
import '../game.dart';
import 'pausemenu.dart';

class PauseButton extends StatelessWidget {
  static const String id = 'PauseButton';
  final PixelWing gameRef;

  const PauseButton({required this.gameRef}) : super();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
        child: const Icon(
          Icons.pause_rounded,
          color: Colors.white,
          size: 55,
        ),
        onPressed: () {
          gameRef.pause = true;
          Future.delayed(
            const Duration(milliseconds: 20),
            gameRef.pauseEngine,
          );
          gameRef.overlays.add(PauseMenu.id);
          gameRef.overlays.remove(PauseButton.id);
        },
      ),
    );
  }
}
