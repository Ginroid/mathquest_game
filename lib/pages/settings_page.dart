import "package:flutter/material.dart";
import 'package:math_quest_2_application/main.dart';
import 'package:math_quest_2_application/utils/color_utils.dart';
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
    final appSettings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: hexStringToActualColor("4E899A"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Timer'),
            subtitle: const Text('Enable or disable the timer during games'),
            value: appSettings.isTimerEnabled,
            onChanged: (bool newValue) {
              setState(() {
                appSettings.isTimerEnabled = newValue;
              });
            },
            secondary: const Icon(Icons.timer),
          ),
          SwitchListTile(
            title: const Text('Hints'),
            subtitle: const Text('Enable or disable hints during games'),
            value: appSettings.isHintEnabled,
            onChanged: (bool newValue) {
              setState(() {
                appSettings.isHintEnabled = newValue;
              });
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
          ListTile(
            title: const Text('Performance Card'),
            subtitle: const Text('View detailed performance statistics'),
            trailing: const Icon(Icons.assessment),
            onTap: () {
              Navigator.pushNamed(context, '/performancecard');
            },
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Learn more about Math Quest'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              // Navigate to About Page
            },
          ),
        ],
      ),
    );
  }
}
