import "package:flutter/material.dart";
import "package:math_quest_2_application/pages/level_button_page.dart";
import "package:math_quest_2_application/pages/quiz_page.dart";

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage(this.unlockedLevels, {super.key});

  final List<bool> unlockedLevels;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        backgroundColor: Colors.deepPurple,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return LevelButton(
            unlocked: unlockedLevels[index],
            text: 'Level ${index + 1}',
            onPressed: unlockedLevels[index]
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(level: index + 1),
                      ),
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}
