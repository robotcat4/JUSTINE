import 'package:flutter/material.dart';

class AppTheme {
  // Define your main colors here so you can change them in one spot
  static const Color primaryPurple = Color(0xFF353972);
  static const Color backgroundGrey = Color(0xFF44475A); // From your surface color

  // Light Theme (Generated from your seed color)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: Brightness.light,
    ),
  );

  // Dark Theme (Your main focus)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: Brightness.dark,
      // You can force specific overrides here if the seed generation isn't perfect
      surface: backgroundGrey,
    ),
    // Example: styling all input borders globally to match your design
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.black12,
    ),
  );
}