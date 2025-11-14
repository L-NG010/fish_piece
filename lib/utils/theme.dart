import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    ),
  );
}
