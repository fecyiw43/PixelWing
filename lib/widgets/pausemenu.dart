import 'package:flutter/material.dart';
import '../game.dart';
import '../main.dart';
import 'pausebutton.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final PixelWing gameRef;
  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: gameRef.gameHasStarted,
            child: SizedBox(
              height: 70.0,
              width: 150.0,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/replaySprite.png',
                ),
                onPressed: () {
                  gameRef.pause = false;
                  gameRef.overlays.remove(PauseMenu.id);
                  gameRef.overlays.add(PauseButton.id);
                  gameRef.gameover(false);
                  gameRef.reset();
                  gameRef.gameHasStarted = true;
                },
              ),
            ),
          ),
          Visibility(
            visible: gameRef.gameHasStarted,
            child: SizedBox(
              height: 70.0,
              width: 210.0,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/playSprite.png',
                ),
                iconSize: 100.0,
                onPressed: () {
                  gameRef.resumeEngine();
                  gameRef.overlays.remove(PauseMenu.id);
                  gameRef.overlays.add(PauseButton.id);
                },
              ),
            ),
          ),
          Visibility(
            visible: gameRef.gameHasStarted,
            child: SizedBox(
              height: 70.0,
              width: 150.0,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/menuSprite.png',
                ),
                iconSize: 100.0,
                onPressed: () {
                  gameRef.pause = false;
                  gameRef.overlays.remove(PauseMenu.id);
                  gameRef.resumeEngine();
                  gameRef.gameover(false);
                  gameRef.reset();
                  gameRef.gameHasStarted = true;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (context) => StartScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
