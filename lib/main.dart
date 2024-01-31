import 'package:flutter/material.dart';
import 'package:math_quest_2_application/pages/signin_page.dart';
import 'package:math_quest_2_application/pages/level_selection_page.dart';
import 'package:math_quest_2_application/pages/lost_page.dart';
import 'package:math_quest_2_application/pages/quiz_page.dart';
import 'package:math_quest_2_application/pages/settings_page.dart';
import 'package:math_quest_2_application/pages/welcome_page.dart';
import 'package:math_quest_2_application/pages/win_page.dart';
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
  List<bool> unlockedLevels = [true] + List.filled(9, false);

  GameState() {
    _loadState();
  }

  void unlockLevel(int level) {
    unlockedLevels[level - 1] = true;
    _saveState();
    //! Error when finishing a level!!
    notifyListeners();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    unlockedLevels = prefs
            .getStringList('unlockedLevels')
            ?.map((e) => e == 'true')
            .toList() ??
        [true] + List.filled(9, false);
  }
}

Future<void> _saveState() async {
  final prefs = await SharedPreferences.getInstance();
  var unlockedLevels;
  prefs.setStringList(
      'unlockedLevels', unlockedLevels.map((e) => e.toString()).toList());
}

class AppSettings extends ChangeNotifier {
  bool _isTimerEnabled = true;

  AppSettings() {
    _loadSettings();
  }

  bool get isTimerEnabled => _isTimerEnabled;

  set isTimerEnabled(bool value) {
    _isTimerEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isTimerEnabled = prefs.getBool('isTimerEnabled') ?? true;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTimerEnabled', _isTimerEnabled);
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
                ),
            '/settings': (context) => SettingsPage(appSettings: appSettings),
            '/level_selection': (context) =>
                const LevelSelectionPage(), // Update this line
            '/lost': (context) => LostPage(
                  // Update this line
                  level: 1,
                  isTimerEnabled: appSettings.isTimerEnabled,
                ),
            '/win': (context) => WinPage(
                  // Update this line
                  level: 1,
                  isTimerEnabled: appSettings.isTimerEnabled,
                ),
          },
        );
      },
    );
  }
}
