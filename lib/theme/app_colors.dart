import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color white = Color(0xFFf4effc);
  static const Color mirage = Color(0xFF181D2E);
  static const int _malibuBase = 0xFF56608c;

  static const Color headline = Color(0xff1f1235);
  static const Color body = Color(0xff1b1425);

  static const Color snuff = Color(0xFFe2daeb);

  static const indigo = MaterialColor(
    0xff5039b3,
    <int, Color>{
      50: Color(0xFFece7f6),
      100: Color(0xFFcec4e9),
      200: Color(0xFFae9edc),
      300: Color(0xff8d76ce),
      400: Color(0xFF7459c4),
      500: Color(0xFF5a3db9),
      600: Color(0xFF5039b3),
      700: Color(0xff4231aa),
      800: Color(0xFF352ba2),
      900: Color(0xFF1b2093),
    },
  );

  static const malibu = MaterialColor(
    _malibuBase,
    <int, Color>{
      50: Color(0xFFe6e8ee),
      100: Color(0xFFc0c5d6),
      200: Color(0xFF989fba),
      300: Color(0xFF727b9f),
      400: Color(_malibuBase),
      500: Color(0xFF3b467b),
    },
  );

  static const grey = MaterialColor(
    0xFFA7AFAF,
    <int, Color>{
      50: Color(0xFFeff2f2),
      100: Color(0xFFcccece),
      200: Color(0xFFa7afaf),
      400: Color(0xFF677b7c),
    },
  );
}
