import 'package:flutter/material.dart';

const Color backgroudColor = Color(0Xffd6dbd2);
const Color appBarColor = Color(0xff2C363F);
const Color screenColor = Colors.white;
const Color counterDarkColor = Colors.black54;
const Color counterLightColor = Colors.black54;

Color colorTextLight = Colors.white.withOpacity(0.9);
const Color colorTextDark = Colors.white;

//* Theme Swatch */
const MaterialColor darkThemeSwatch = Colors.teal;
const MaterialColor lightThemeSwatch = Colors.blueGrey;

//* Green color */
const Color color1 = Color.fromRGBO(218, 215, 205, 1);
const Color color2 = Color.fromRGBO(163, 177, 138, 1);
const Color color3 = Color.fromRGBO(88, 129, 87, 1);
const Color color4 = Color.fromRGBO(58, 90, 64, 1);
const Color color5 = Color.fromRGBO(52, 78, 65, 1);

Map<int, Color> color = {
  50: const Color.fromRGBO(88, 129, 87, .1),
  100: const Color.fromRGBO(88, 129, 87, .2),
  200: const Color.fromRGBO(88, 129, 87, .3),
  300: const Color.fromRGBO(88, 129, 87, .4),
  400: const Color.fromRGBO(88, 129, 87, .5),
  500: const Color.fromRGBO(88, 129, 87, .6),
  600: const Color.fromRGBO(88, 129, 87, .7),
  700: const Color.fromRGBO(88, 129, 87, .8),
  800: const Color.fromRGBO(88, 129, 87, .9),
  900: const Color.fromRGBO(88, 129, 87, 1),
};

MaterialColor greenMaterialColor = MaterialColor(color3.value, color);
