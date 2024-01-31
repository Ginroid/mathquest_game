import "dart:async";
import "dart:math";

import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:math_quest_2_application/main.dart";
import "package:math_quest_2_application/pages/lost_page.dart";
import "package:math_quest_2_application/pages/win_page.dart";
import "package:math_quest_2_application/reusables/theme.dart";
import "package:math_quest_2_application/utils/color_utils.dart";
import "package:provider/provider.dart";

class QuizPage extends StatefulWidget {
  final int level;
  final bool isTimerEnabled;

  const QuizPage({Key? key, required this.level, required this.isTimerEnabled})
      : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  //fixes the issue with timer not counting down after enabling
  @override
  void didUpdateWidget(covariant QuizPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTimerEnabled != widget.isTimerEnabled) {
      if (widget.isTimerEnabled) {
        startTimer();
      } else {
        timer?.cancel();
        setState(() {
          timeLeft = 10; // Reset the time left
        });
      }
    }
  }

  int num1 = 0;
  int num2 = 0;
  String operator = '+';
  List<double> options = [];
  List<double> originalOptions = [];
  late double correctAnswer;
  String feedback = '';
  Color feedbackColor = Colors.black;
  int score = 0;
  int timeLeft = 10;
  Timer? timer;
  bool hintUsed = false;

  AudioPlayer audioPlayer = AudioPlayer();
  final correctAnswerSound = 'sounds/correct_answer.mp3';
  final wrongAnswerSound = 'sounds/false_answer.mp3';

  @override
  void initState() {
    super.initState();
    updateQuestion();
    if (widget.isTimerEnabled) {
      startTimer();
    }
  }

  void updateQuestion() {
    setState(() {
      int range = getRangeBasedOnScore();
      num1 = Random().nextInt(range);
      num2 = Random().nextInt(range);
      List<String> operators = ['+', '-', '×', '÷'];
      operator = (operators..shuffle()).first;
      switch (operator) {
        case '+':
          correctAnswer = (num1 + num2).toDouble();
          break;
        case '-':
          correctAnswer = (num1 - num2).toDouble();
          break;
        case '×':
          correctAnswer = (num1 * num2).toDouble();
          break;
        case '÷':
          if (num2 != 0 && num1 % num2 == 0) {
            correctAnswer = num1 / num2;
            correctAnswer = double.parse(correctAnswer.toStringAsFixed(2));
          } else {
            updateQuestion();
            return;
          }
          break;
      }
      originalOptions = [
        correctAnswer,
        generateUniqueOption(correctAnswer),
        generateUniqueOption(correctAnswer),
        generateUniqueOption(correctAnswer)
      ];
      options = List.from(originalOptions);
      options.shuffle();
      feedback = '';
      if (widget.isTimerEnabled) {
        timeLeft = 10;
      }
      hintUsed = false;
    });
  }

  int getRangeBasedOnScore() {
    if (score < 10) {
      return 10;
    } else if (score < 20) {
      return 15;
    } else {
      return 20;
    }
  }

  double generateUniqueOption(double correctAnswer) {
    double option;
    do {
      option = (correctAnswer + Random().nextInt(11) - 5).toDouble();
    } while (option == correctAnswer ||
        originalOptions.contains(option) ||
        option == 0);
    return option;
  }

  void startTimer() {
    timer?.cancel();
    if (widget.isTimerEnabled) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeLeft == 0) {
          timer.cancel();
          updateQuestion();
          if (widget.isTimerEnabled) {
            startTimer();
          }
        } else {
          setState(() {
            timeLeft--;
          });
        }
      });
    }
  }

  void showHint() {
    if (!hintUsed) {
      setState(() {
        options = List.from(originalOptions);
        List<double> wrongOptions =
            options.where((option) => option != correctAnswer).toList();
        wrongOptions.shuffle();
        if (wrongOptions.length > 1) {
          options.remove(wrongOptions[0]);
          options.remove(wrongOptions[1]);
        }
        hintUsed = true;
      });
    }
  }

  void checkAnswer(double userAnswer) {
    if (userAnswer == correctAnswer) {
      playSound(correctAnswerSound);
      // The user's answer is correct. Update the score.
      score += 10; // Increase score by 10

      // Check if the user has reached a score of 100
      if (score >= 100) {
        // Navigate to the WinPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WinPage(
                level: widget.level, isTimerEnabled: widget.isTimerEnabled),
          ),
        );
      }
    } else {
      playSound(wrongAnswerSound);
      // The user's answer is incorrect. Navigate to the LostPage.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LostPage(
              level: widget.level, isTimerEnabled: widget.isTimerEnabled),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer if it's still running
    super.dispose();
  }

  Future<void> playSound(String path) async {
    await audioPlayer.play(AssetSource(path));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(builder: (context, appSettings, child) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Level ${widget.level}',
          showHomeButton: true,
          showHintButton: true,
          onHintPressed: showHint,
          onHomePressed: () =>
              Navigator.pushReplacementNamed(context, '/level_selection'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Score Text
                  Text(
                    'Score: $score',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hexStringToActualColor("4E899A")),
                  ),

                  // Timer and Question Text
                  if (appSettings.isTimerEnabled)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer,
                            size: 30, color: hexStringToActualColor("4E899A")),
                        const SizedBox(
                            width: 8), // Spacing between icon and text
                        Text(
                          'Time left: $timeLeft',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: hexStringToActualColor("4E899A")),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20), // Spacing between elements
                  Text(
                    '$num1 $operator $num2 = ?',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hexStringToActualColor("4E899A")),
                  ),
                  const SizedBox(height: 20), // Spacing between elements

                  // Option Buttons
                  ...(options.map((option) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: hexStringToActualColor(
                                "E4BD1F"), // Button background color
                            onPrimary: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                            ),
                            fixedSize:
                                const Size(200, 50), // Fixed size of the button
                            elevation: 5, // Slight elevation for a tactile feel
                          ),
                          onPressed: () {
                            checkAnswer(option);
                            Future.delayed(const Duration(seconds: 1), () {
                              updateQuestion();
                              if (appSettings.isTimerEnabled) {
                                startTimer();
                              }
                            });
                          },
                          child: Text(
                            option.toStringAsFixed(
                                option.truncateToDouble() == option ? 0 : 2),
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ))),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
