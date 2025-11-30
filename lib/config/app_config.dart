import 'package:flutter/material.dart';

class AppConfig {
  static const paddingHorizontal = 12.0;
  // Konfigurasi bahasa yang didukung
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];

  static const Locale fallbackLocale = Locale('en');
  static const String translationPath = 'lang';

  static const String appTitle = 'Fish It Kasir';
  static const bool showDebugBanner = false;
}

class AppColors {
  static const Color biru = Color(0xFF0392D6);
  static final Color abu = Color(0xFF000000).withValues(alpha: 158);
  static const Color hitam = Color(0xFF000000);
  static const Color pink = Color(0xFFFCA6A0);
  static const Color ungu = Color(0xFF9E92FE);
  static const Color oren = Color(0xFFFFAE4C);
  static const Color secret = Color(0xFF38D28F);
  static const Color mythic = Color(0xFFB22132);
  static const Color legendary = Color(0xFFFFDE59);
  static const Color exclusive = Color(0xFFFF59E1);
  static const Color epic = Color(0xFF9655C5);
  static const Color uncommon = Color(0xFFBFD641);
}

