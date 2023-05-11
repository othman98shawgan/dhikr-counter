import 'package:dhikr_counter/services/dikhr_service.dart';
import 'package:dhikr_counter/services/view_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../services/store_manager.dart';
import '../services/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.count, this.updateCount});

  final int? count;
  final Function? updateCount;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeNotifier, DikhrNotifier, ViewNotifier>(
      builder: (context, theme, dikhr, view, child) => Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
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
                  SettingsTile.navigation(
                    leading: const Icon(Icons.clear_all),
                    title: const Text('Clear total count'),
                    trailing: const Icon(Icons.navigate_next_rounded),
                    onPressed: (context) {
                      showClearTotalDialog(context, widget.updateCount!);
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.onetwothree),
                    title: const Text('Set Counter'),
                    trailing: const Icon(Icons.navigate_next_rounded),
                    onPressed: (context) {
                      showSetCounterDialog(context, widget.count!, widget.updateCount!);
                    },
                  ),
                  SettingsTile(
                    title: const Text('Total view'),
                    description: const Text('Counter will show cycle count'),
                    leading: const Icon(Icons.view_carousel),
                    trailing: Checkbox(
                      value: view.getView(),
                      onChanged: (bool? value) {
                        if (value == true) {
                          view.enableTotalView();
                        } else {
                          view.disableTotalView();
                        }
                      },
                    ),
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
                    trailing: const Icon(Icons.navigate_next_rounded),
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

showSetCounterDialog(BuildContext context, int count, Function updateCount) async {
  int currentCount = count;
  final _textFieldController = TextEditingController();
  _textFieldController.text = count.toString();

  var confirmMethod = (() {
    Navigator.pop(context);
    if (currentCount != -1) {
      StorageManager.saveData('Counter', currentCount);
      updateCount(currentCount);
    }
  });

  AlertDialog alert = AlertDialog(
      title: const Text("Set Counter"),
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
                  currentCount = -1;
                } else {
                  currentCount = int.parse(value);
                }
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered

            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Tasbeeh count"),
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

showClearTotalDialog(BuildContext context, Function updateCount) async {
  var confirmMethod = (() {
    updateCount(0);
    Navigator.pop(context);
  });

  AlertDialog alert = AlertDialog(
      title: Text('Clear Total Count'),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(
          onPressed: confirmMethod,
          child: Text('Confirm'),
        ),
      ],
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Text('Are you sure you want to clear total count?');
      }));
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
