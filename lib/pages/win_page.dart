import "package:flutter/material.dart";
import "package:math_quest_2_application/main.dart";
import "package:math_quest_2_application/pages/quiz_page.dart";
import "package:provider/provider.dart";

class WinPage extends StatelessWidget {
  final int level;
  final bool isTimerEnabled;

  const WinPage({Key? key, required this.level, required this.isTimerEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of<GameState>(context, listen: false);
    gameState.unlockLevel(level + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations!'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: Text(
                'You have completed Level $level!',
                style: const TextStyle(fontSize: 32),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.home, size: 30.0),
                        Text('Home', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                            level: level + 1, isTimerEnabled: isTimerEnabled),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_forward, size: 30.0),
                        Text('Next Level', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
