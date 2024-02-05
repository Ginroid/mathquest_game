import "dart:async";
import "dart:math";

import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:math_quest_2_application/main.dart";
import "package:math_quest_2_application/reusables/theme.dart";
import "package:math_quest_2_application/utils/color_utils.dart";
import "package:math_quest_2_application/utils/performance_data_service.dart";
import "package:provider/provider.dart";

class QuizPage extends StatefulWidget {
  final int level;
  final bool isTimerEnabled;
  final String operation;

  const QuizPage(
      {Key? key,
      required this.level,
      required this.isTimerEnabled,
      required this.operation})
      : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late DateTime _levelStartTime;
  late DateTime _questionStartTime;

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
  int totalQuestionsAsked = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;

  AudioPlayer audioPlayer = AudioPlayer();
  final correctAnswerSound = 'sounds/correct_answer.mp3';
  final wrongAnswerSound = 'sounds/false_answer.mp3';

  @override
  void initState() {
    super.initState();
    _levelStartTime = DateTime.now();
    _questionStartTime = DateTime.now();
    totalQuestionsAsked = 0;
    correctAnswers = 0;
    wrongAnswers = 0;
    updateQuestion();
    if (widget.isTimerEnabled) {
      startTimer();
    }
  }

  void updateQuestion() {
    _questionStartTime = DateTime.now();
    if (totalQuestionsAsked < 20) {
      setState(() {
        int range = getRangeBasedOnScore();
        num1 = Random().nextInt(range);
        num2 = Random().nextInt(range);

        switch (widget.operation) {
          case 'Addition':
            correctAnswer = (num1 + num2).toDouble();
            operator = '+';
            break;
          case 'Subtraction':
            correctAnswer = (num1 - num2).toDouble();
            operator = '-';
            break;
          case 'Multiplication':
            correctAnswer = (num1 * num2).toDouble();
            operator = '×';
            break;
          case 'Division':
            // Ensure num2 is not zero and division is integer
            while (num2 == 0 || num1 % num2 != 0) {
              num1 = Random().nextInt(range);
              num2 = Random().nextInt(range) + 1; // Adding 1 to avoid zero
            }
            correctAnswer = num1 / num2;
            correctAnswer = double.parse(correctAnswer.toStringAsFixed(2));
            operator = '÷';
            break;
          default:
            throw Exception('Unsupported operation');
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
    } else {
      showResultsDialog();
    }
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

  //*sometimes its not unique
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
          setState(() {
            feedback = 'Time\'s up!';
            feedbackColor = Colors.red;
            timeLeft = 10; // Reset time for next question
            totalQuestionsAsked++;
          });

          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              feedback = ''; // Clear feedback
              if (totalQuestionsAsked < 20) {
                updateQuestion();
              } else {
                showResultsDialog();
              }
            });
          });
        } else {
          setState(() {
            timeLeft--;
          });
        }
      });
    }
  }

  void showHint() {
    var appSettings = Provider.of<AppSettings>(context, listen: false);
    if (!hintUsed && appSettings.isHintEnabled) {
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

  void checkAnswer(double userAnswer) async {
    bool isCorrect = userAnswer == correctAnswer;
    int timeTakenForQuestion =
        DateTime.now().difference(_questionStartTime).inSeconds;

    setState(() {
      feedback = isCorrect ? 'Correct!' : 'Wrong!';
      feedbackColor = isCorrect ? Colors.green : Colors.red;
      if (isCorrect) {
        correctAnswers++;
        score += 10;
      } else {
        wrongAnswers++;
      }
    });

    // Wait for sound to play
    await playSound(isCorrect ? correctAnswerSound : wrongAnswerSound);

    // Delay for feedback visibility
    await Future.delayed(const Duration(seconds: 1));

    // Update performance data
    await PerformanceDataService.updatePerformanceData(
      correctAnswers: isCorrect ? 1 : 0,
      wrongAnswers: isCorrect ? 0 : 1,
      hintsUsed: hintUsed ? 1 : 0,
      timeSpentInSeconds: timeTakenForQuestion,
    );

    // Prepare for next question or show results
    setState(() {
      feedback = ''; // Clear feedback
      totalQuestionsAsked++;
      if (totalQuestionsAsked < 20) {
        updateQuestion();
      } else {
        showResultsDialog();
      }
    });
  }

  Future<void> playSound(String path) async {
    await audioPlayer.play(AssetSource(path));
  }

  void showResultsDialog() {
    bool isLevelPassed = score >= 100;
    bool canProceedToNextLevel = isLevelPassed && widget.level < 10;
    int totalTimeSpentInQuiz =
        DateTime.now().difference(_levelStartTime).inSeconds;

    PerformanceDataService.updatePerformanceData(
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      hintsUsed: hintUsed ? 1 : 0,
      timeSpentInSeconds: totalTimeSpentInQuiz,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isLevelPassed ? 'Congratulations!' : 'Try Again!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Correct Answers: $correctAnswers'),
                Text('Wrong Answers: $wrongAnswers'),
                Text('Total Score: $score'),
                if (canProceedToNextLevel)
                  const Text('\nDo you want to proceed to the next level?'),
              ],
            ),
          ),
          actions: isLevelPassed
              ? <Widget>[
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      saveProgress(widget.level + 1);
                      Navigator.pushReplacementNamed(
                          context, '/level_selection');
                    },
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      navigateToNextLevel();
                    },
                  ),
                ]
              : <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                          context, '/level_selection');
                    },
                  ),
                ],
        );
      },
    );
  }

  void saveProgress(int level) async {
    var gameState = Provider.of<GameState>(context, listen: false);
    gameState.unlockLevel(widget.operation, level);
  }

  void navigateToNextLevel() {
    saveProgress(widget.level + 1); // Save progress before navigating
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          level: widget.level + 1,
          isTimerEnabled: widget.isTimerEnabled,
          operation: widget.operation,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer if it's still running
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(builder: (context, appSettings, child) {
      return Scaffold(
        appBar: CustomAppBar(
          title: '${widget.operation}: Level ${widget.level}',
          showHomeButton: true,
          showHintButton: appSettings.isHintEnabled,
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
                  if (feedback.isNotEmpty)
                    Text(
                      feedback,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: feedbackColor),
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
                  const SizedBox(height: 20),
                  Text(
                    '$num1 $operator $num2 = ?',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hexStringToActualColor("4E899A")),
                  ),
                  const SizedBox(height: 20),

                  // Option Buttons
                  ...(options.map((option) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                hexStringToActualColor("E4BD1F"), // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fixedSize: const Size(200, 50),
                            elevation: 5,
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
