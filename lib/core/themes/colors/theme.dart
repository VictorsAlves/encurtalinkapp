import 'package:flutter/material.dart';
import 'colors.dart';

abstract final class AppTheme {
  static final _textTheme = TextTheme(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
    headlineSmall: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    bodyMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.greyText,
    ),
    labelSmall: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.greyText,
    ),
    labelLarge: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.greyText,
    ),
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      // grey3 works for both light and dark themes
      color: AppColors.greyText,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
  );
}