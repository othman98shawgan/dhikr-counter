import 'package:flutter/material.dart';
import '../resources/colors.dart';
import 'store_manager.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData? _themeData;
  ThemeData? get themeData => _themeData;

  ThemeMode? _themeMode;
  ThemeMode? get themeMode => _themeMode;

  ThemeNotifier(ThemeMode themeMode) {
    if (themeMode == ThemeMode.light) {
      _themeData = lightTheme;
      _themeMode = ThemeMode.light;
    } else {
      _themeData = darkTheme;
      _themeMode = ThemeMode.dark;      
    }
    notifyListeners();
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    _themeMode = ThemeMode.dark;
    StorageManager.saveData('themeMode', 'dark');
    StorageManager.saveData('isDark', true);
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    _themeMode = ThemeMode.light;
    StorageManager.saveData('themeMode', 'light');
    StorageManager.saveData('isDark', false);
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
