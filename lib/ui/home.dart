import 'dart:async';

import 'package:dhikr_counter/resources/colors.dart';
import 'package:dhikr_counter/services/theme_service.dart';
import 'package:dhikr_counter/services/view_service.dart';
import 'package:dhikr_counter/services/volume_key_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:in_app_update/in_app_update.dart';

import '../services/utils.dart';
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
  late int _cycle;
  double _bigFontSize = 112;
  double _smallFontSize = 96;
  late double _currnetFontSize;
  StreamSubscription<HardwareButton>? subscription;

  void _incrementCounter(DikhrNotifier dikhr) {
    setState(() {
      _counter++;
      _cycle++;
    });
    if (_counter >= 10000) {
      setState(() {
        _currnetFontSize = _smallFontSize;
      });
    }
    if (_counter % dikhr.getDikhrTarget() != 0) {
      //vibrate on tap
      if (dikhr.getVibrateOnTap()) {
        Vibration.vibrate(duration: 50, amplitude: 50);
      }
    } else {
      //vibrate on target reach
      _cycle = 0;
      if (dikhr.getVibrateOnCountTarget()) {
        Vibration.vibrate(duration: 200, amplitude: 128);
      }
    }
    StorageManager.saveData('Counter', _counter);
    StorageManager.saveData('Cycle', _cycle);
  }

  void _resetCounter() async {
    Vibration.vibrate(duration: 400);
    var showTotalView = Provider.of<ViewNotifier>(context, listen: false).showTotalView;
    setState(() {
      if (showTotalView) {
        _cycle = 0;
        StorageManager.saveData('Cycle', _cycle);
      } else {
        _counter = 0;
        StorageManager.saveData('Counter', _counter);
      }
      _currnetFontSize = _bigFontSize;
    });
  }

  Future<Null> getSharedPrefs() async {
    StorageManager.readData('Counter').then((value) {
      setState(() {
        _counter = value ?? 0;
      });
    });
    StorageManager.readData('Cycle').then((value) {
      setState(() {
        _cycle = value ?? 0;
      });
    });
  }

  void startListening() {
    subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
      if (event == HardwareButton.volume_down || event == HardwareButton.volume_up) {
        if (Provider.of<VolumeKeyTasbeehNotifier>(context, listen: false).volumeKeyTasbeeh) {
          _incrementCounter(Provider.of<DikhrNotifier>(context, listen: false));
        }
      }
    });
  }

  void stopListening() {
    subscription?.cancel();
  }

  updateCount(int newCount) {
    setState(() {
      _counter = newCount;
    });
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate().then((_) {
          InAppUpdate.completeFlexibleUpdate().then((_) {
            printSnackBar("Success!", context);
          }).catchError((e) {
            printSnackBar(e.toString(), context);
          });
        }).catchError((e) {
          printSnackBar(e.toString(), context);
        });
      }
    }).catchError((e) {
      printSnackBar(e.toString(), context);
    });
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    Wakelock.enable();
    _counter = 0;
    _cycle = 0;
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
    return Consumer3<DikhrNotifier, ThemeNotifier, ViewNotifier>(
      builder: (context, dikhr, theme, view, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Tasbeeh Counter'),
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
                    builder: (context) => SettingsPage(
                      count: _counter,
                      updateCount: updateCount,
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
          child: view.showTotalView
              ? totalView(dikhr, theme)
              : counterView(dikhr, theme), //chose view based on ViewNotifier
        ),
      ),
    );
  }

  Widget counterView(DikhrNotifier dikhr, ThemeNotifier theme) {
    double width = MediaQuery.of(context).size.width;
    double heightWithToolbar = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    double height = heightWithToolbar - padding.top - kToolbarHeight;

    return Center(
      child: SizedBox(
        height: height * 0.25,
        width: width * 0.85,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            color: theme.themeMode == ThemeMode.dark ? Colors.black54 : color3.withOpacity(0.5),
          ),
          child: Center(
            child: Text(_counter.toString(),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.merge(TextStyle(fontSize: _currnetFontSize))),
          ),
        ),
      ),
    );
  }

  Widget totalView(DikhrNotifier dikhr, ThemeNotifier theme) {
    double width = MediaQuery.of(context).size.width;
    double heightWithToolbar = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    double height = heightWithToolbar - padding.top - kToolbarHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height * 0.375,
        ),
        Center(
          child: SizedBox(
            height: height * 0.25,
            width: width * 0.75,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                color: theme.themeMode == ThemeMode.dark ? Colors.black54 : color3.withOpacity(0.5),
              ),
              child: Center(
                child: Text(_cycle.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.merge(TextStyle(fontSize: _currnetFontSize))),
              ),
            ),
          ),
        ),
        SizedBox(
          height: height * 0.075,
        ),
        SizedBox(
            height: height * 0.3,
            width: width * 0.8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Tasbeeh: ',
                  style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: theme.themeMode == ThemeMode.dark
                              ? Colors.grey.shade400
                              : greenMaterialColor.shade400)),
                ),
                Text(
                  '$_counter',
                  style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                          fontSize: 16,
                          color:
                              theme.themeMode == ThemeMode.dark ? Colors.grey.shade200 : color4)),
                ),
              ],
            )),
      ],
    );
  }
}
