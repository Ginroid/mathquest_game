import 'package:flutter/material.dart';
import 'package:math_quest_2_application/utils/color_utils.dart';
import 'package:math_quest_2_application/utils/performance_data_service.dart';

class PerformanceCardPage extends StatefulWidget {
  const PerformanceCardPage({Key? key}) : super(key: key);

  @override
  _PerformanceCardPageState createState() => _PerformanceCardPageState();
}

class _PerformanceCardPageState extends State<PerformanceCardPage> {
  Map<String, dynamic> performanceData = {};

  @override
  void initState() {
    super.initState();
    _loadPerformanceData();
  }

  Future<void> _loadPerformanceData() async {
    performanceData = await PerformanceDataService.loadPerformanceData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Card'),
        backgroundColor: hexStringToActualColor("4E899A"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Played Hours'),
            trailing: Text(performanceData['playedHours'] ?? '0h 0m'),
          ),
          ListTile(
            title: const Text('Played Questions'),
            trailing: Text(performanceData['playedQuestions'].toString()),
          ),
          ListTile(
            title: const Text('Correct Answers'),
            trailing: Text(performanceData['correctAnswers'].toString()),
          ),
          ListTile(
            title: const Text('Wrong Answers'),
            trailing: Text(performanceData['wrongAnswers'].toString()),
          ),
          ListTile(
            title: const Text('Average Equations Solved Per Day'),
            trailing:
                Text(performanceData['averageEquationSolvedPerDay'].toString()),
          ),
          ListTile(
            title: const Text('Average Time for 1 Equation'),
            trailing:
                Text(performanceData['averageTimeFor1Equation'].toString()),
          ),
          ListTile(
            title: const Text('Hint Used'),
            trailing: Text(performanceData['hintUsed'].toString()),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Keep up the good work and continue improving!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
