import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color white = Color(0xFFF9F9FF);
  static const Color mirage = Color(0xFF181D2E);
  static const int _indigoBase = 0xFF3A05E1;
  static const int _malibuBase = 0xFF6e99ff;

  static const indigo = MaterialColor(
    _indigoBase,
    <int, Color>{
      50: Color(0xFFEFE6FD),
      100: Color(0xFFE8E0FF),
      200: Color(0xFFB697F7),
      300: Color(0xFF976AF5),
      400: Color(0xFF6232FA),
      500: Color(0xFF5D18EF),
      600: Color(0xFF4F13E9),
      700: Color(_indigoBase),
      800: Color(0xFF1200DC),
      900: Color(0xFF0000D6),
    },
  );

  static const malibu = MaterialColor(
    _malibuBase,
    <int, Color>{
      50: Color(0xFFE7F3FF),
      100: Color(0xFFc7e0ff),
      200: Color(0xFFa5cdff),
      300: Color(0xFF87b9ff),
      400: Color(0xFF76a9ff),
      500: Color(_malibuBase),
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
