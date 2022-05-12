import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppFontWeight {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

abstract class AppTextStyle {
  static final _bodyTextStyle = GoogleFonts.inter(
    color: AppColors.body,
    fontSize: 16,
    fontWeight: AppFontWeight.regular,
  );

  static final _headerTextStyle = GoogleFonts.poppins(
    color: AppColors.headline,
    fontSize: 18,
    fontWeight: AppFontWeight.semibold,
  );

  static TextStyle get headline1 {
    return _headerTextStyle.copyWith(
      fontSize: 26,
      letterSpacing: 0.07,
    );
  }

  static TextStyle get headline2 {
    return _headerTextStyle.copyWith(
      fontSize: 22,
      letterSpacing: 0.12,
    );
  }

  static TextStyle get headline3 {
    return _headerTextStyle.copyWith(
      letterSpacing: 0.03,
    );
  }

  static TextStyle get subtitle1 {
    return _bodyTextStyle.copyWith(
      letterSpacing: 0.03,
      color: AppColors.body,
    );
  }

  static TextStyle get body {
    return _bodyTextStyle.copyWith(
      letterSpacing: 0.08,
    );
  }

  static TextStyle get button {
    return _bodyTextStyle.copyWith(
      fontWeight: AppFontWeight.bold,
      fontSize: 14,
      letterSpacing: 0.4,
      color: AppColors.headline,
    );
  }

  static TextStyle get caption {
    return _bodyTextStyle.copyWith(
      fontSize: 14,
      letterSpacing: 0.05,
    );
  }

  static TextStyle get overline {
    return _bodyTextStyle.copyWith(
      fontWeight: AppFontWeight.medium,
      fontSize: 12,
      letterSpacing: 0.18,
    );
  }
}
