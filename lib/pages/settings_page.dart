import "package:flutter/material.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double volume = 0.5;
  String difficulty = 'Easy';
  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              const Text(
                'Volume',
                style: TextStyle(fontSize: 24),
              ),
              Slider(
                value: volume,
                min: 0,
                max: 1,
                divisions: 10,
                label: volume.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    volume = value;
                  });
                },
              ),
              const Text(
                'Mute',
                style: TextStyle(fontSize: 24),
              ),
              Switch(
                value: isMuted,
                onChanged: (bool value) {
                  setState(() {
                    isMuted = value;
                    volume = value ? 0 : 0.5;
                  });
                },
              ),
              const Text(
                'Difficulty',
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton<String>(
                value: difficulty,
                items: <String>['Easy', 'Medium', 'Hard']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    difficulty = newValue!;
                  });
                },
              ),
            ])));
  }
}
