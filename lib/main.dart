import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/dikhr_service.dart';
import 'services/theme_service.dart';
import 'services/view_service.dart';
import 'ui/home.dart';
import 'ui/settings_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DikhrNotifier()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => ViewNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Alfajr',
              theme: theme.getTheme(),
              initialRoute: '/home',
              routes: {
                '/home': (context) => const HomePage(),
                '/settings': (context) => SettingsPage(),
              },
            ));
  }
}
