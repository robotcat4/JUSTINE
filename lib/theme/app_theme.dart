import 'package:flutter/material.dart';

class AppTheme {
  // Design colors from Figma
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceDark = Color(0xFF28283E);
  static const Color inputBackground = Color(0xFF3A3A4A);
  static const Color tableHeaderBg = Color(0xFF3F3E5E);
  static const Color accentPurple = Color(0xFF6A4CE4);
  static const Color accentPurpleBright = Color(0xFF7F58E8);

  static const Color primaryPurple = Color(0xFF353972);
  static const Color backgroundGrey = Color(0xFF44475A);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: Brightness.light,
    ),
  );

  // Dark Theme matching Figma
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: surfaceDark,
    colorScheme: ColorScheme.dark(
      primary: accentPurple,
      surface: surfaceDark,
      onSurface: Colors.white,
      onPrimary: Colors.white,
      surfaceContainerHighest: tableHeaderBg,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: backgroundDark,
    ),
  );
}
