import "dart:async";
import "dart:math";

import "package:flutter/material.dart";
import "package:math_quest_2_application/pages/lost_page.dart";
import "package:math_quest_2_application/pages/win_page.dart";

class QuizPage extends StatefulWidget {
  final int level;

  const QuizPage({super.key, required this.level});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
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

  @override
  void initState() {
    super.initState();
    updateQuestion();
    startTimer();
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
      timeLeft = 10;
      hintUsed = false;
    });
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        timer.cancel();
        updateQuestion();
        startTimer();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Quest'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: showHint,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              'Level: ${widget.level}',
              style: const TextStyle(fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.timer,
                  size: 30,
                ),
                Text(
                  'Time left: $timeLeft',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            Text(
              feedback,
              style: TextStyle(fontSize: 30, color: feedbackColor),
            ),
            Text(
              '$num1 $operator $num2 = ?',
              style: const TextStyle(fontSize: 30),
            ),
            ...(options.map((option) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 25),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (option == correctAnswer) {
                          feedback = 'Correct!';
                          feedbackColor = Colors.green;
                          score += 10;
                          if (score == 100) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WinPage(level: widget.level),
                              ),
                            );
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LostPage(level: widget.level),
                            ),
                          );
                        }
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        updateQuestion();
                        startTimer();
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
    );
  }
}
