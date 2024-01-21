import "package:flutter/material.dart";
import "package:math_quest_2_application/pages/quiz_page.dart";

class WinPage extends StatelessWidget {
  final int level;

  const WinPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations!'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have completed Level $level!',
              style: const TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              child: const Text('Next Level'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(level: level + 1),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Home'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
