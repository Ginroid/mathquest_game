import 'package:shared_preferences/shared_preferences.dart';

class PerformanceDataService {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Fetch all performance data
  static Future<Map<String, dynamic>> loadPerformanceData() async {
    await init();
    int playedQuestions = _prefs?.getInt('playedQuestions') ?? 0;
    int totalSecondsPlayed = _prefs?.getInt('totalSecondsPlayed') ?? 0;
    int daysPlayed =
        _prefs?.getInt('daysPlayed') ?? 1; // Avoid division by zero

    String playedHours = formatDuration(Duration(seconds: totalSecondsPlayed));
    int averageEquationSolvedPerDay = playedQuestions ~/ daysPlayed;
    String averageTimeFor1Equation = playedQuestions > 0
        ? formatDuration(
            Duration(seconds: totalSecondsPlayed ~/ playedQuestions))
        : '0s';

    return {
      'playedHours': playedHours,
      'playedQuestions': playedQuestions,
      'correctAnswers': _prefs?.getInt('correctAnswers') ?? 0,
      'wrongAnswers': _prefs?.getInt('wrongAnswers') ?? 0,
      'averageEquationSolvedPerDay': averageEquationSolvedPerDay,
      'averageTimeFor1Equation': averageTimeFor1Equation,
      'hintUsed': _prefs?.getInt('hintUsed') ?? 0,
    };
  }

  // Update performance data
  static Future<void> updatePerformanceData({
    required int correctAnswers,
    required int wrongAnswers,
    required int hintsUsed,
    required int timeSpentInSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int totalCorrectAnswers =
        (prefs.getInt('correctAnswers') ?? 0) + correctAnswers;
    int totalWrongAnswers = (prefs.getInt('wrongAnswers') ?? 0) + wrongAnswers;
    int totalHintsUsed = (prefs.getInt('hintUsed') ?? 0) + hintsUsed;
    int totalSecondsPlayed =
        (prefs.getInt('totalSecondsPlayed') ?? 0) + timeSpentInSeconds;
    int playedQuestions = (prefs.getInt('playedQuestions') ?? 0) + 1;

    // Increment the number of days played if this is a new day
    int lastPlayedDay = prefs.getInt('lastPlayedDay') ?? 0;
    int currentDay = DateTime.now().day;
    if (currentDay != lastPlayedDay) {
      int daysPlayed = (prefs.getInt('daysPlayed') ?? 0) + 1;
      prefs.setInt('daysPlayed', daysPlayed);
      prefs.setInt('lastPlayedDay', currentDay);
    }

    await prefs.setInt('correctAnswers', totalCorrectAnswers);
    await prefs.setInt('wrongAnswers', totalWrongAnswers);
    await prefs.setInt('hintUsed', totalHintsUsed);
    await prefs.setInt('totalSecondsPlayed', totalSecondsPlayed);
    await prefs.setInt('playedQuestions', playedQuestions);
  }

  // Format duration to a string in "h m s" format
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${hours}h ${minutes}m ${seconds}s";
  }

  // Clear all performance data
  static Future<void> clearPerformanceData() async {
    await _prefs?.clear();
  }
}
