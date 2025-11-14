import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client = Supabase.instance.client;

  /// Login
  Future<AuthResponse> login(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Logout
  Future<void> logout() async {
    await client.auth.signOut();
  }

  /// Register
  Future<AuthResponse> register(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }
}
