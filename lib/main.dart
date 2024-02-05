import 'package:flutter/material.dart';
import 'package:math_quest_2_application/pages/performance_card_page.dart';
import 'package:math_quest_2_application/pages/signin_page.dart';
import 'package:math_quest_2_application/pages/level_selection_page.dart';
import 'package:math_quest_2_application/pages/quiz_page.dart';
import 'package:math_quest_2_application/pages/settings_page.dart';
import 'package:math_quest_2_application/pages/signup_page.dart';
import 'package:math_quest_2_application/pages/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameState()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
      ],
      child: const MathGame(),
    ),
  );
}

class GameState extends ChangeNotifier {
  Map<String, List<bool>> unlockedLevelsPerOperation = {
    'Addition': [true] + List.filled(9, false),
    'Subtraction': [true] + List.filled(9, false),
    'Multiplication': [true] + List.filled(9, false),
    'Division': [true] + List.filled(9, false),
  };

  GameState() {
    _loadState();
  }

  void unlockLevel(String operation, int level) {
    // Check if the operation exists in the map, access it
    if (unlockedLevelsPerOperation.containsKey(operation)) {
      unlockedLevelsPerOperation[operation]![level - 1] = true;
      _saveState();
      notifyListeners();
    } else {
      // handles the case where the operation does not exist
      print("Operation not found: $operation");
    }
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    // Load for each operation
    unlockedLevelsPerOperation.forEach((operation, _) {
      var levels = prefs.getStringList('unlockedLevels_$operation');
      if (levels != null) {
        unlockedLevelsPerOperation[operation] =
            levels.map((e) => e == 'true').toList();
      }
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    // Save for each operation
    unlockedLevelsPerOperation.forEach((operation, levels) {
      prefs.setStringList('unlockedLevels_$operation',
          levels.map((e) => e.toString()).toList());
    });
  }
}

class AppSettings extends ChangeNotifier {
  bool _isTimerEnabled = true;
  bool _isHintEnabled = true;

  AppSettings() {
    _loadSettings();
  }

  bool get isTimerEnabled => _isTimerEnabled;
  set isTimerEnabled(bool newValue) {
    _isTimerEnabled = newValue;
    notifyListeners();
    _saveSettings();
  }

  bool get isHintEnabled => _isHintEnabled;
  set isHintEnabled(bool newValue) {
    _isHintEnabled = newValue;
    notifyListeners();
    _saveSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isTimerEnabled = prefs.getBool('isTimerEnabled') ?? true;
    _isHintEnabled = prefs.getBool('isHintEnabled') ?? true;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTimerEnabled', _isTimerEnabled);
    prefs.setBool('isHintEnabled', _isHintEnabled); // Save hint setting
  }
}

class MathGame extends StatelessWidget {
  const MathGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, appSettings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const WelcomePage(),
            '/login': (context) => const SignInPage(),
            '/quiz': (context) => QuizPage(
                  level: 1,
                  isTimerEnabled: appSettings.isTimerEnabled,
                  operation:
                      'Addition', // Default operation for direct navigation
                ),
            '/settings': (context) => SettingsPage(appSettings: appSettings),
            '/level_selection': (context) => const LevelSelectionPage(),
            '/signin': (context) => const SignInPage(),
            '/signup': (context) => const SignUpPage(),
            '/performancecard': (context) => const PerformanceCardPage()
          },
        );
      },
    );
  }
}
