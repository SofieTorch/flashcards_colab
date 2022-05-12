import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color white = Color(0xFFf4effc);
  static const Color mirage = Color(0xFF181D2E);
  static const int _malibuBase = 0xFF56608c;

  static const Color headline = Color(0xff1f1235);
  static const Color body = Color(0xff1b1425);

  static const Color snuff = Color(0xFFe2daeb);

  static const indigo = MaterialColor(
    0xffff6e6c,
    <int, Color>{
      50: Color(0xFFffebee),
      100: Color(0xFFffcdd1),
      200: Color(0xFFff9996),
      300: Color(0xffff6e6c),
      400: Color(0xFFff4843),
      500: Color(0xFFff278a),
      600: Color(0xFFf02586),
      700: Color(0xffd8237e),
      800: Color(0xFFd8237e),
      900: Color(0xFFc12279),
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
