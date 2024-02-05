import "package:flutter/material.dart";
import "package:math_quest_2_application/main.dart";
import 'package:math_quest_2_application/utils/level_button.dart';
import "package:math_quest_2_application/pages/quiz_page.dart";
import "package:math_quest_2_application/reusables/theme.dart";
import "package:provider/provider.dart";

class LevelSelectionPage extends StatefulWidget {
  const LevelSelectionPage({Key? key}) : super(key: key);

  @override
  _LevelSelectionPageState createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  String selectedOperation = 'Addition';

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
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectedOperation,
                        items: <String>[
                          'Addition',
                          'Subtraction',
                          'Multiplication',
                          'Division'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOperation = newValue!;
                          });
                        },
                      ),
                      Expanded(
                        child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount:
                                10, // Assuming 10 levels for each operation
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              // Accessing unlocked levels for the selected operation
                              List<bool> unlockedLevels =
                                  gameState.unlockedLevelsPerOperation[
                                          selectedOperation] ??
                                      [];

                              return LevelButton(
                                unlocked: unlockedLevels[index],
                                text: 'Level ${index + 1}',
                                onPressed: unlockedLevels[index]
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => QuizPage(
                                              level: index + 1,
                                              isTimerEnabled:
                                                  appSettings.isTimerEnabled,
                                              operation: selectedOperation,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                              );
                            }),
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}
