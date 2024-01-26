import 'package:flutter/material.dart';
import 'package:math_quest_2_application/pages/signin_page.dart';
import 'package:math_quest_2_application/pages/level_selection_page.dart';
import 'package:math_quest_2_application/pages/lost_page.dart';
import 'package:math_quest_2_application/pages/quiz_page.dart';
import 'package:math_quest_2_application/pages/settings_page.dart';
import 'package:math_quest_2_application/pages/signup_page.dart';
import 'package:math_quest_2_application/pages/welcome_page.dart';

void main() {
  runApp(const MathGame());
}

class MathGame extends StatelessWidget {
  const MathGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signing': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/quiz': (context) => const QuizPage(level: 1),
        '/settings': (context) => const SettingsPage(),
        '/level_selection': (context) =>
            LevelSelectionPage([true] + List.filled(9, false)),
        '/lost': (context) => const LostPage(level: 1), // Add this line
      },
    );
  }
}
