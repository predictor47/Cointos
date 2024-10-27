import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor =
      Color(0xFF4CAF50); // Green for growth and stability
  static const Color _accentColor =
      Color(0xFFFFA726); // Orange for enthusiasm and creativity
  static const Color _backgroundColor = Color(0xFF121212); // Dark background
  static const Color _surfaceColor =
      Color(0xFF1E1E1E); // Slightly lighter surface
  static const Color _errorColor = Color(0xFFCF6679); // Soft red for errors

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
      secondary: _accentColor,
      surface: _surfaceColor,
      error: _errorColor,
    ),
    scaffoldBackgroundColor: _backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceColor,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryColor),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white30),
    ),
    cardTheme: CardTheme(
      color: _surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
    ),
    textTheme: const TextTheme(
      headlineLarge:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headlineMedium:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white60),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _surfaceColor,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.white54,
    ),
  );

  // You can keep the lightTheme if needed, or remove it if your app is dark-mode only
}
