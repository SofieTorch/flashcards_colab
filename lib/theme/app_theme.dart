import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final lightTextTheme = TextTheme(
    headline1: AppTextStyle.headline1,
    headline2: AppTextStyle.headline2,
    headline3: AppTextStyle.headline3,
    subtitle1: AppTextStyle.subtitle1,
    bodyText1: AppTextStyle.body,
    button: AppTextStyle.button,
    caption: AppTextStyle.caption,
    overline: AppTextStyle.overline,
  );

  static final light = ThemeData(
    primaryTextTheme: lightTextTheme,
    textTheme: lightTextTheme,
    iconTheme: const IconThemeData(size: 32),
    primarySwatch: AppColors.indigo,
    backgroundColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.indigo.shade200,
      foregroundColor: AppColors.headline,
      iconTheme: const IconThemeData(color: AppColors.headline),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: AppColors.indigo.shade50,
      labelColor: AppColors.headline,
      labelStyle: lightTextTheme.button,
      unselectedLabelStyle: lightTextTheme.button,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        color: AppColors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.indigo.shade400),
        foregroundColor: MaterialStateProperty.all(AppColors.white),
        elevation: MaterialStateProperty.all(0.5),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            width: 1.2,
            color: AppColors.indigo.shade500,
          ),
        ),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed)
                ? AppColors.indigo.shade200
                : AppColors.white;
          },
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.malibu.shade400,
      foregroundColor: AppColors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.snuff,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 14,
      ),
      suffixIconColor: AppColors.malibu,
      hintStyle: AppTextStyle.subtitle1.copyWith(
        color: AppColors.grey.shade400,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),
  );
}
