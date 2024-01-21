import "dart:async";
import "dart:math";

import "package:flutter/material.dart";
import "package:math_quest_2_application/pages/win_page.dart";

class QuizPage extends StatefulWidget {
  final int level;

  const QuizPage({super.key, required this.level});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int num1 = 0; // Initialize at declaration
  int num2 = 0; // Initialize at declaration
  String operator = '+'; // Initialize at declaration
  List<double> options = []; // Initialize at declaration
  List<double> originalOptions = []; // Initialize at declaration
  late double correctAnswer;
  String feedback = '';
  Color feedbackColor = Colors.black;
  int score = 0;
  int timeLeft = 10;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    updateQuestion();
    startTimer();
  }

  void updateQuestion() {
    setState(() {
      int range;
      if (score < 10) {
        range = 10;
      } else if (score < 20) {
        range = 15;
      } else {
        range = 20;
      }
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
          if (num2 != 0) {
            correctAnswer = num1 / num2;
            correctAnswer = double.parse(correctAnswer.toStringAsFixed(1));
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
    });
  }

  double generateUniqueOption(double correctAnswer) {
    double option;
    do {
      option = (correctAnswer + Random().nextInt(11) - 5).toDouble();
    } while (option == correctAnswer || originalOptions.contains(option));
    return option;
  }

  void startTimer() {
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
    setState(() {
      options = List.from(originalOptions);
      options.removeWhere((option) => option != correctAnswer);
      if (options.length < 4) {
        double fillerOption;
        do {
          fillerOption = generateUniqueOption(correctAnswer);
        } while (
            fillerOption == correctAnswer || options.contains(fillerOption));
        options.add(fillerOption);
      }
    });
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
            Text(
              'Time left: $timeLeft',
              style: const TextStyle(fontSize: 30),
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
                          feedback = 'Wrong!';
                          feedbackColor = Colors.red;
                          score -= 5;
                          if (score < 0) {
                            score = 0;
                          }
                        }
                      });
                      Future.delayed(
                          const Duration(seconds: 1), updateQuestion);
                    },
                    child: Text(
                      option.toStringAsFixed(
                          option.truncateToDouble() == option ? 0 : 1),
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
