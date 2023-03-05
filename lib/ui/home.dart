import 'package:dhikr_counter/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../services/dikhr_service.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter(DikhrNotifier dikhr) {
    setState(() {
      _counter++;
    });
    if (_counter % dikhr.getDikhrTarget() != 0) {
      //vibrate on tap
      if (dikhr.getVibrateOnTap()) {
        Vibrate.feedback(FeedbackType.medium);
      }
    } else {
      //vibrate on target reach
      if (dikhr.getVibrateOnCountTarget()) {
        Vibrate.feedback(FeedbackType.warning);
      }
    }
  }

  void _resetCounter() async {
    Vibrate.feedback(FeedbackType.error);
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DikhrNotifier, ThemeNotifier>(
      builder: (context, dikhr, theme, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Counter'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(
                      title: 'Settings Page',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: _resetCounter,
          onTap: (() {
            _incrementCounter(dikhr);
          }),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Container(
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: theme.getTheme() == theme.darkTheme? Colors.black54:Color.fromARGB(120, 96, 125, 139),
                ),
                child: Center(
                  child: Text(_counter.toString().padLeft(4, '0'), style: Theme.of(context).textTheme.headline1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
