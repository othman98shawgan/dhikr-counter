import 'package:dhikr_counter/services/dikhr_service.dart';
import 'package:flutter/material.dart';
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
                    description: const Text('Vibrate on reaching Target'),
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
                    title: const Text('Target'),
                    value: Text('Current target is: ${dikhr.getDikhrTarget()}'),
                    onPressed: (context) {
                      showRoundToDialog(context, dikhr.getDikhrTarget());
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

showRoundToDialog(BuildContext context, int target) async {
  int currentTarget = target;

  var confirmMethod = (() {
    Navigator.pop(context);
    Provider.of<DikhrNotifier>(context, listen: false).setDikhrCount(currentTarget);
  });

  AlertDialog alert = AlertDialog(
      title: const Text("Counter target"),
      // titlePadding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0),
      contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 24.0),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: confirmMethod,
          child: const Text('Confirm'),
        ),
      ],
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    value: 33,
                    title: const Text('33'),
                    groupValue: currentTarget,
                    onChanged: (val) {
                      setState(() {
                        currentTarget = val ?? 0;
                      });
                    }),
                RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    value: 100,
                    title: const Text('100'),
                    groupValue: currentTarget,
                    onChanged: (val) {
                      setState(() {
                        currentTarget = val ?? 0;
                      });
                    }),
              ],
            ),
          ),
        ]);
      }));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
