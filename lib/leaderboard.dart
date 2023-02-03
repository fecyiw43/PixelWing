import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LeaderboardRepository {
  Future<void> saveHighScore(String name, int newScore) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    try {
      final uid = currentUser.uid;
      final userName = currentUser.displayName;
      final splitted = userName?.split(' ');

      // Get the previous score
      final scoreRef = FirebaseDatabase.instance.ref('leaderboard/$uid');
      final userScoreResult = await scoreRef.child('score').once();
      final score = (userScoreResult.snapshot.value as int?) ?? 0;

      // Return if it is not the high score
      if (newScore < score) {
        return;
      }

      await scoreRef.set({
        'name': splitted?[0],
        'score': newScore,
      });
    } catch (e) {
      // handle error
    }
  }

  Future<Iterable<LeaderboardModel>> getTopHighScores() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    // Retrieve first 20 data from highest to lowest in firebase
    final result = await FirebaseDatabase.instance
        .ref()
        .child('leaderboard')
        .orderByChild('score')
        .limitToLast(20)
        .once();

    final leaderboardScores = result.snapshot.children
        .map(
          // ignore: cast_nullable_to_non_nullable
          (e) => LeaderboardModel.fromJson(e.value as Map, e.key == userId),
        )
        .toList();

    return leaderboardScores.reversed;
  }
}

class LeaderboardModel {
  final String name;
  final int score;

  LeaderboardModel({
    required this.name,
    required this.score,
  });

  factory LeaderboardModel.fromJson(Map json, bool isUser) {
    return LeaderboardModel(
      name: isUser ? 'You' : json['name'] as String,
      score: json['score'] as int,
    );
  }
}

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({
    this.isGameOver = true,
    Key? key,
  }) : super(key: key);
  final bool isGameOver;

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  final List<LeaderboardModel> _leaderboardScores = [];

  @override
  void initState() {
    super.initState();

    getLeaderboardScores();
  }

  void getLeaderboardScores() async {
    final leaderboardScores = await LeaderboardRepository().getTopHighScores();
    setState(() {
      _leaderboardScores.addAll(leaderboardScores);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              './assets/images/Leaderboard_Background.png',
            ), //./assets/images/
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Image.asset(
                  './assets/images/returnSprite.png',
                ),
                iconSize: 50.0,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (context) => StartScreen(),
                    ),
                  );
                },
              ),
            ),
            const Text(
              'LeaderBoard',
              style: TextStyle(
                height: 2,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.black),
                  child: DataTable(
                    columnSpacing: 150,
                    dataTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Score',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                    // rows: const [],
                    rows: List.generate(_leaderboardScores.length, (index) {
                      final leaderboard = _leaderboardScores[index];
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              leaderboard.name,
                            ),
                          ),
                          DataCell(Text(leaderboard.score.toString())),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
