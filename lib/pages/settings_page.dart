import "package:flutter/material.dart";
import 'package:math_quest_2_application/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required AppSettings appSettings})
      : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double volume = 0.5;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        volume = prefs.getDouble('volume') ?? 0.5;
        isMuted = prefs.getBool('isMuted') ?? false;
        Provider.of<AppSettings>(context, listen: false).isTimerEnabled =
            prefs.getBool('isTimerEnabled') ?? true;
      });
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('volume', volume);
    prefs.setBool('isMuted', isMuted);
    prefs.setBool('isTimerEnabled',
        Provider.of<AppSettings>(context, listen: false).isTimerEnabled);
  }

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
                _saveSettings();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      'Mute',
                      style: TextStyle(fontSize: 24),
                    ),
                    Switch(
                      value: volume == 0,
                      onChanged: (bool value) {
                        setState(() {
                          volume = value ? 0 : 0.5;
                        });
                        _saveSettings();
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    const Text(
                      'Timer',
                      style: TextStyle(fontSize: 24),
                    ),
                    Consumer<AppSettings>(
                      builder: (context, appSettings, child) {
                        return Switch(
                          value: appSettings.isTimerEnabled,
                          onChanged: (bool value) {
                            appSettings.isTimerEnabled = value;
                            _saveSettings();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
