import 'dart:async';

import 'package:dhikr_counter/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../services/dikhr_service.dart';
import '../services/store_manager.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _counter;
  double _bigFontSize = 112;
  double _smallFontSize = 96;
  late double _currnetFontSize;
  StreamSubscription<HardwareButton>? subscription;

  void _incrementCounter(DikhrNotifier dikhr) {
    setState(() {
      _counter++;
    });
    StorageManager.saveData('Counter', _counter);
    if (_counter >= 10000) {
      setState(() {
        _currnetFontSize = _smallFontSize;
      });
    }
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
      _currnetFontSize = _bigFontSize;
      StorageManager.saveData('Counter', _counter);
    });
  }

  Future<Null> getSharedPrefs() async {
    StorageManager.readData('Counter').then((value) {
      setState(() {
        _counter = value ?? 0;
      });
    });
  }

  void startListening() {
    Wakelock.enable();
    subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
      if (event == HardwareButton.volume_down || event == HardwareButton.volume_up) {
        _incrementCounter(Provider.of<DikhrNotifier>(context, listen: false));
      }
    });
  }

  void stopListening() {
    subscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _counter = 0;
    _currnetFontSize = _bigFontSize;
    getSharedPrefs();
    startListening();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DikhrNotifier, ThemeNotifier>(
      builder: (context, dikhr, theme, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Counter'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset Count',
              onPressed: _resetCounter,
            ),
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
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: theme.getTheme() == theme.darkTheme
                      ? Colors.black54
                      : Color.fromARGB(120, 96, 125, 139),
                ),
                child: Center(
                  child: Text(_counter.toString().padLeft(4, '0'),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.merge(TextStyle(fontSize: _currnetFontSize))),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
