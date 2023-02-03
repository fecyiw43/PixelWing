// ignore_for_file: camel_case_types
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';

import 'background.dart';
import 'leaderboard.dart';
import 'multi_obstacles.dart';
import 'player.dart';
import 'widgets/pausebutton.dart';

bool _isAlreadyLoaded = false;

class PixelWing extends FlameGame with TapDetector, HasCollisionDetection {
  final LeaderboardRepository leaderboardRepository = LeaderboardRepository();
  late AudioPool jumpSound, scoreSound, loseSound, startSound;
  bool pause = false;
  bool sound = true;
  bool updateSprite = false;
  bool gameHasStarted = true;
  late final Player player;
  final random = Random();
  double speed = 120;

  int count = 0;
  int _score = 1;
  int _highScore = 0; // leaderboard.score
  double pixelRatio = window.devicePixelRatio;

  final List<Component> _components = [];

  final _play = TextComponent(
    text: ' ',
    priority: 1,
    scale: Vector2.all(1),
    anchor: Anchor.center,
  );

  late final _highScoreText = TextComponent(
    text: gameHasStarted ? ' ' : '$_highScore',
    priority: 1,
    scale: Vector2.all(1),
    position: Vector2(178, 200),
    anchor: Anchor.center,
  );

  late final _scoreText = TextComponent(
    text: gameHasStarted ? ' ' : '$_score',
    priority: 1,
    scale: Vector2.all(3),
    position: Vector2(180, 150),
    anchor: Anchor.center,
  );

  // Objects
  @override
  Future<void>? onLoad() async {
    if (!_isAlreadyLoaded) {
      // sounds
      startSound =
          await AudioPool.create('audio/gameStartSound.mp3', maxPlayers: 1);
      jumpSound = await AudioPool.create('audio/JumpSound.mp3', maxPlayers: 1);
      scoreSound =
          await AudioPool.create('audio/scoreSound.wav', maxPlayers: 1);
      loseSound =
          await AudioPool.create('audio/losingSound.wav', maxPlayers: 1);
      startSound.start();
      // sprite elements
      gameHasStarted = true;
      player = Player();
      _components.add(player);
      _components.add(_play);
      _components.add(_scoreText);
      _components.add(_highScoreText);
      _components.forEach(add);
      add(ScreenHitbox());
      add(Sky());
      _isAlreadyLoaded = true;
      return super.onLoad();
    }
  }

  // Obstacles
  double _timeSinceBox = 0;
  final double _boxInterval = 2.5;
  @override
  void update(double dt) {
    super.update(dt);
    pause = false;
    if (speed <= 350) {
      speed += 5 * dt;
    }
    _timeSinceBox += dt;
    if (_timeSinceBox > _boxInterval) {
      add(MulObs());
      resize();
      _timeSinceBox = 0;
    }
  }

  // Gameover (needs to implement an endscreen and a restart screen)
  void gameover(bool sound) {
    overlays.remove(PauseButton.id);
    if (sound) {
      loseSound.start();
    }
    gameHasStarted = false;
    _score--;
    if (_score > _highScore) {
      _highScore = _score;
    }
    leaderboardRepository.saveHighScore('test', _score);
    updateScore(sound);
    if (sound == true) {
      Future.delayed(const Duration(milliseconds: 40), pauseEngine);
    }
    return;
  }

  // score update
  void updateScore(bool sound) {
    _highScoreText.text = gameHasStarted ? '$_highScore' : ' ';
    _scoreText.text = gameHasStarted ? '$_score' : ' ';
    if (gameHasStarted && sound) {
      _score++;
    }
    if (count >= 0) {
      scoreSound.start();
    }
    count++;
    _play.text = gameHasStarted || !sound
        ? ' '
        : '\nT A P  T O  P L A Y\n\nScore: $_score \nHighscore: $_highScore';
  }

  // resize the text so it always stays in the middle
  void resize() {
    final logicalScreenSize = window.physicalSize / pixelRatio;
    final Width = logicalScreenSize.width;
    _play.position = Vector2(Width / 2, 300);
    _scoreText.position = Vector2(Width / 2, 150);
    _highScoreText.position = Vector2(Width / 2, 200);
  }

  // flying method
  @override
  void onTap() {
    if (gameHasStarted == true) {
      // during the game
      jumpSound.start(volume: 0.7);
      super.onTap();
      player.fly();
    } else {
      // restart the game
      reset();
    }
  }

  // reset the game to start a new instance
  void reset() {
    gameHasStarted = true;
    count = -1;
    _score = 0;
    speed = 120;
    player.position = Vector2(50, 100);
    updateSprite = true;
    overlays.add(PauseButton.id);
    updateScore(sound);
    Future.delayed(const Duration(milliseconds: 20), resumeEngine);
  }
}
