import 'package:flutter/material.dart';


abstract final class AppColors {

  // Nubank core colors
  static const purple = Color(0xFF8A05BE); // Roxo principal
  static const purpleDark = Color(0xFF52009B); // Roxo mais escuro
  static const purpleLight = Color(0xFFEDE4F7); // Fundo/lilás claro
  static const greyText = Color(0xFF4E4B59); // Texto secundário
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF101010);
  static const errorRed = Color(0xFFE74C3C);

  // Transparências
  static const whiteTransparent = Color(0x4DFFFFFF); // 30% branco
  static const blackTransparent = Color(0x4D000000);

  /// Tema claro Nubank
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: purple,
    onPrimary: white,
    secondary: purpleDark,
    onSecondary: white,
    surface: white,
    onSurface: black,
    error: errorRed,
    onError: white,
  );

  /// Tema escuro Nubank
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: purpleLight,
    onPrimary: purpleDark,
    secondary: purple,
    onSecondary: white,
    surface: black,
    onSurface: white,
    error: errorRed,
    onError: white,
  );
}
