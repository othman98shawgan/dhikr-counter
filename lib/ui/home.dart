import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    if (_counter % 10 != 0) {
      Vibrate.feedback(FeedbackType.medium);
    } else {
      Vibrate.feedback(FeedbackType.heavy);
    }
  }

  void _resetCounter() async {
    Vibrate.feedback(FeedbackType.warning);
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onTap: _incrementCounter,
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.6,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                color: Colors.black54,
              ),
              child: Center(
                child: Text('$_counter', style: Theme.of(context).textTheme.headline1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
