import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../resources/colors.dart';
import 'store_manager.dart';

class ThemeNotifier with ChangeNotifier {
  late ThemeData _themeData = darkTheme;
  ThemeData getTheme() => _themeData;

  late String _currTheme = 'dark';
  String getThemeStr() => _currTheme;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      if (kDebugMode) {
        print('value read from storage: $value');
      }
      var themeMode = value ?? 'dark';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        _currTheme = 'light';
      } else {
        if (kDebugMode) {
          print('setting dark theme');
        }
        _themeData = darkTheme;
        _currTheme = 'dark';
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    _currTheme = 'dark';
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    _currTheme = 'light';
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  //=============================================================================
  // Themes
  //=============================================================================

  //*** Dark Theme ***/
  final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: appBarColor, foregroundColor: Colors.white),
    brightness: Brightness.dark,
    focusColor: darkThemeSwatch,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: darkThemeSwatch).copyWith(
      brightness: Brightness.dark,
    ),
  );

  //*** Light Theme ***/

  final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: color5, foregroundColor: colorTextLight),
    brightness: Brightness.light,
    scaffoldBackgroundColor: color1,
    dialogBackgroundColor: Colors.white,
    dividerColor: Colors.black26,
    focusColor: lightThemeSwatch,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
    ).apply(
      bodyColor: colorTextLight,
      displayColor: colorTextLight,
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: greenMaterialColor).copyWith(),
  );
}
