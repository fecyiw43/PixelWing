import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../authentication.dart';
import 'gameplay.dart';
import 'leaderboard.dart';
import 'signinscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  // debugMode = true;
  final image = Image.asset(
    './assets/images/title_Image.png',
    scale: 3,
    height: 250,
    alignment: Alignment.topCenter,
  );
  StartScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/images/Night_Sky_Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image,
            SizedBox(
              height: 70.0,
              width: 150.0,
              child: IconButton(
                icon: Image.asset(
                  './assets/images/playButton.png',
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (context) => const gamePlay(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 70.0,
              width: 210.0,
              child: IconButton(
                icon: Image.asset(
                  './assets/images/leaderboardButton.png',
                ),
                iconSize: 100.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const LeaderboardView(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 70.0,
              width: 150.0,
              child: IconButton(
                icon: Image.asset(
                  './assets/images/quitButton.png',
                ),
                iconSize: 100.0,
                onPressed: () async {
                  Authentication.signOut(context: context);
                  Future<void>.delayed(
                    const Duration(milliseconds: 40),
                    exit(0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
