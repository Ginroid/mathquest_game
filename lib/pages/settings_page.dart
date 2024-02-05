import 'package:flutter/material.dart';
import 'package:math_quest_2_application/main.dart';
import 'package:math_quest_2_application/reusables/theme.dart'; // Import CustomAppBar
import 'package:math_quest_2_application/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _sendMail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'deltastudio24@gmail.com',
      query: encodeQueryParameters(
          <String, String>{'subject': 'Customer Support'}),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Handle the error here
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Settings',
          showBackButton: true,
          showHomeButton: false,
          showSettingsButton: false, // Set this to false
          // Other properties...
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              SwitchListTile(
                title: const Text('Timer'),
                subtitle:
                    const Text('Enable or disable the timer during games'),
                value: appSettings.isTimerEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    appSettings.isTimerEnabled = newValue;
                  });
                },
                secondary: const Icon(Icons.timer),
                activeTrackColor:
                    hexStringToActualColor("E4BD1F"), // Set the color here
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
                  activeTrackColor: hexStringToActualColor("E4BD1F")),
              SwitchListTile(
                title: const Text('Sound Effects'),
                subtitle: const Text('Enable or disable sound effects'),
                value: appSettings.soundEffectsEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    appSettings.soundEffectsEnabled = newValue;
                  });
                },
                secondary: const Icon(Icons.music_note),
                activeTrackColor: hexStringToActualColor("E4BD1F"),
              ),
              ListTile(
                title: const Text('Performance Card'),
                subtitle: const Text('View detailed performance statistics'),
                leading: const Icon(Icons.assessment),
                onTap: () {
                  Navigator.pushNamed(context, '/performancecard');
                },
              ),
              ListTile(
                title: const Text('Customer Support'),
                subtitle: const Text('Contact us via email'),
                leading: const Icon(Icons.email),
                onTap: _sendMail, // Add this line
              ),
              ListTile(
                title: const Text('About'),
                subtitle:
                    const Text('Learn more about the creators of MathQuest'),
                leading: const Icon(Icons.info_outline),
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
