import "package:flutter/material.dart";
import "package:math_quest_2_application/main.dart";
import "package:math_quest_2_application/pages/level_button_page.dart";
import "package:math_quest_2_application/pages/quiz_page.dart";
import "package:math_quest_2_application/reusables/theme.dart";
import "package:provider/provider.dart";

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Consumer<AppSettings>(
          builder: (context, appSettings, child) {
            return Scaffold(
              appBar: const CustomAppBar(
                title: 'Select Level',
                showHomeButton: false,
                showHintButton: false,
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
                    unlocked: gameState.unlockedLevels[index],
                    text: 'Level ${index + 1}',
                    onPressed: gameState.unlockedLevels[index]
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(
                                    level: index + 1,
                                    isTimerEnabled: appSettings.isTimerEnabled),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
