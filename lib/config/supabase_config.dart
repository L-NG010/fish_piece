import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  /// Inisialisasi Supabase dengan kredensial dari file .env
  static Future<void> initialize() async {
    // Muat file .env
    await dotenv.load(fileName: ".env");

    // Inisialisasi Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }

  /// Getter untuk mengakses Supabase client
  static SupabaseClient get client => Supabase.instance.client;
}