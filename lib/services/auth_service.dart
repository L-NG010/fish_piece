import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client = Supabase.instance.client;

  /// Listener status autentikasi (login, logout, refresh token)
  Stream<AuthState> get authState => client.auth.onAuthStateChange;

  User? get currentUser => client.auth.currentUser;

  Future<String?> login(String email, String password) async {
    try {
      await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (error) {
      return "Email atau password salah";
    }
  }

  Future<String?> register(String email, String password,
      {Map<String, dynamic>? metadata}) async {
    try {
      await client.auth.signUp(
        email: email,
        password: password,
        data: metadata, 
      );
      return null;
    } catch (error) {
      return _parseError(error);
    }
  }

  /// Logout
  Future<String?> logout() async {
  try {
    await client.auth.signOut();
    return null;
  } catch (error) {
    return _parseError(error);
  }
}

  String _parseError(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }
    return 'Terjadi kesalahan yang tidak diketahui';
  }
}
