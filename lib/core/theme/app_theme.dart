import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const primary = Color(0xFF087F8C);
  static const navy = Color(0xFF123047);
  static const background = Color(0xFFF5F8FA);
  static const success = Color(0xFF25A271);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: const Color(0xFF63C7B2),
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'SF Pro Display',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.w800, color: navy),
        headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: navy),
        titleLarge: TextStyle(fontWeight: FontWeight.w700, color: navy),
        titleMedium: TextStyle(fontWeight: FontWeight.w700, color: navy),
        bodyLarge: TextStyle(color: Color(0xFF405667)),
        bodyMedium: TextStyle(color: Color(0xFF607585)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4EBEF)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
