import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color white = Color(0xFFF9F9FF);
  static const Color mirage = Color(0xFF181D2E);
  static const int _indigoBase = 0xFF3A05E1;
  static const int _goldenrodBase = 0xFFFFD36E;

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

  static const goldenrod = MaterialColor(
    _goldenrodBase,
    <int, Color>{
      200: Color(0xFFFFF4DB),
      300: Color(0xFFFFE9B7),
      400: Color(0xFFFFDE92),
      500: Color(_goldenrodBase),
    },
  );
}
