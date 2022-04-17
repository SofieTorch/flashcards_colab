import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class _AppFontWeight {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w700;
}

abstract class AppTextStyle {
  static final _bodyTextStyle = GoogleFonts.inter(
    color: AppColors.mirage,
    fontSize: 15,
    fontWeight: _AppFontWeight.regular,
  );

  static final _headerTextStyle = GoogleFonts.poppins(
    color: AppColors.mirage,
    fontSize: 18,
    fontWeight: _AppFontWeight.semibold,
  );

  static final headline1 = _headerTextStyle
    ..copyWith(
      fontSize: 28,
      letterSpacing: 0.07,
    );

  static final headline2 = _headerTextStyle
    ..copyWith(
      fontSize: 22,
      letterSpacing: 0.12,
    );

  static final headline3 = _headerTextStyle
    ..copyWith(
      letterSpacing: 0.03,
    );

  static final subtitle1 = _bodyTextStyle
    ..copyWith(
      letterSpacing: 0.03,
    );

  static final body = _bodyTextStyle
    ..copyWith(
      letterSpacing: 0.08,
    );

  static final button = _bodyTextStyle
    ..copyWith(
      fontWeight: _AppFontWeight.semibold,
      fontSize: 12,
      letterSpacing: 0.32,
    );

  static final caption = _bodyTextStyle
    ..copyWith(
      fontSize: 12,
      letterSpacing: 0.05,
    );

  static final overline = _bodyTextStyle
    ..copyWith(
      fontWeight: _AppFontWeight.medium,
      fontSize: 10,
      letterSpacing: 0.18,
    );
}
