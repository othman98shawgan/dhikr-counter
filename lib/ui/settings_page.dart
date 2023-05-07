import 'package:dhikr_counter/services/dikhr_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../resources/colors.dart';
import '../services/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, DikhrNotifier>(
      builder: (context, theme, dikhr, child) => Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SettingsList(
            sections: [
              SettingsSection(
                title: const Text('General'),
                tiles: [
                  SettingsTile.switchTile(
                    title: const Text('Dark Mode'),
                    leading: const Icon(Icons.dark_mode_outlined),
                    initialValue: theme.getTheme() == theme.darkTheme,
                    onToggle: (value) {
                      if (value) {
                        theme.setDarkMode();
                      } else {
                        theme.setLightMode();
                      }
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Vibration'),
                tiles: [
                  SettingsTile(
                    title: const Text('Tap Vibration'),
                    description: const Text('Vibrate on each Tap'),
                    leading: const Icon(Icons.vibration),
                    trailing: Checkbox(
                      value: dikhr.getVibrateOnTap(),
                      onChanged: (bool? value) {
                        if (value == true) {
                          dikhr.enableVibrateOnTap();
                        } else {
                          dikhr.disableVibrateOnTap();
                        }
                      },
                    ),
                  ),
                  SettingsTile(
                    title: const Text('Target Vibration'),
                    description: const Text('Vibrate on finishing Cycle'),
                    leading: const Icon(Icons.vibration),
                    trailing: Checkbox(
                      value: dikhr.getVibrateOnCountTarget(),
                      onChanged: (bool? value) {
                        if (value == true) {
                          dikhr.enableVibrateOnCountTarget();
                        } else {
                          dikhr.disableVibrateOnCountTarget();
                        }
                      },
                    ),
                  ),
                  SettingsTile.navigation(
                    enabled: dikhr.getVibrateOnCountTarget(),
                    leading: const Icon(Icons.track_changes),
                    title: const Text('Cycle'),
                    value: Text('Current Cycle is: ${dikhr.getDikhrTarget()}'),
                    onPressed: (context) {
                      showCycleDialog(context, dikhr.getDikhrTarget());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showCycleDialog(BuildContext context, int cycle) async {
  int currentCycle = cycle;
  final _textFieldController = TextEditingController();
  bool _validate = false;

  var confirmMethod = (() {
    Navigator.pop(context);
    if (currentCycle != -1) {
      Provider.of<DikhrNotifier>(context, listen: false).setDikhrCount(currentCycle);
    }
  });

  AlertDialog alert = AlertDialog(
      title: const Text("Counter cycle"),
      contentPadding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: confirmMethod,
          child: const Text('Confirm'),
        ),
      ],
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                if (value == '') {
                  currentCycle = -1;
                } else {
                  currentCycle = int.parse(value);
                }
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered

            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Tasbeeh cycle length"),
          ),
        );
      }));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
