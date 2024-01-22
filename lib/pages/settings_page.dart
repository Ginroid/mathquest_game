import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double volume = 0.5;
  bool isMuted = false;
  //timer in each question
  bool isTimerOn = false;
  int numberOfOptions = 4;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load the number of questions setting or default to 4
      numberOfOptions = prefs.getInt('numberOfOptions') ?? 4;
    });
  }

  //when hot reloading, preferences will still be saved (local storage)
  void saveNumberOfOptions(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('numberOfOptions', value);
    setState(() {
      numberOfOptions = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView(children: [
          ListTile(
            title: const Text("Performance Report"),
            onTap: () {
              // TODO: Implement Performance report page
            },
          ),
          /*
          ListTile(
            title: Text("Child Profiles"),
            onTap: () {
              // TODO: Implement Child Profiles page
            },
          ),*/
          SwitchListTile(
            title: const Text('Sound'),
            value: isMuted,
            onChanged: (bool value) {
              setState(() {
                isMuted = value;
                volume = value ? 0 : 0.5;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Questions Timer'),
            value: isTimerOn,
            onChanged: (bool value) {
              setState(() {
                isTimerOn = value;
              });
            },
          ),
          ListTile(
              title: const Text("Options for Questions"),
              trailing: Wrap(
                spacing: 8,
                children: List<Widget>.generate(3, (int index) {
                  return ChoiceChip(
                    label: Text('${4 + index}'),
                    //check
                    selected: numberOfOptions == 4 + index,
                    onSelected: (bool value) {
                      saveNumberOfOptions(4 + index);
                    },
                  );
                }),
              ))
        ]));
  }
}
