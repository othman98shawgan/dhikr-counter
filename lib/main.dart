import 'package:dhikr_counter/services/store_manager.dart';
import 'package:dhikr_counter/services/volume_key_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/dikhr_service.dart';
import 'services/theme_service.dart';
import 'services/view_service.dart';
import 'ui/home.dart';
import 'ui/settings_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  StorageManager.init().then((value) {
    var prefs = value;

    //Theme
    var isDark = StorageManager.readDataFromPrefs('isDark', prefs) ?? false;
    ThemeMode themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DikhrNotifier()),
          ChangeNotifierProvider(create: (context) => ThemeNotifier(themeMode)),
          ChangeNotifierProvider(create: (context) => ViewNotifier()),
          ChangeNotifierProvider(create: (context) => VolumeKeyTasbeehNotifier()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Alfajr',
              theme: theme.themeData,
              initialRoute: '/home',
              routes: {
                '/home': (context) => const HomePage(),
                '/settings': (context) => SettingsPage(),
              },
            ));
  }
}
