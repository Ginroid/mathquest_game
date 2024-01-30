import "package:flutter/material.dart";
import "package:math_quest_2_application/pages/quiz_page.dart";

class LostPage extends StatelessWidget {
  final int level;
  final bool isTimerEnabled;

  const LostPage({Key? key, required this.level, required this.isTimerEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oops!'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You selected the wrong answer.',
              style: TextStyle(fontSize: 26),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.replay), // Repeat icon
              label: const Text('Try Again', style: TextStyle(fontSize: 24)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizPage(level: level, isTimerEnabled: isTimerEnabled),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
