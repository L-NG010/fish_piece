import 'package:flutter/material.dart';

class AppConfig {
  // Konfigurasi bahasa yang didukung
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];

  static const Locale fallbackLocale = Locale('en');
  static const String translationPath = 'lang';

  // Konfigurasi aplikasi
  static const String appTitle = 'Fish It Kasir';
  static const bool showDebugBanner = false;
}