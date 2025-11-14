import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  /// Proses login
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await authService.login(email, password);

      final user = response.user;
      if (user == null) {
        emit(AuthError("Login gagal, Paduka."));
        return;
      }

      emit(AuthSuccess(user.id));
    } catch (e) {
      emit(AuthError("Mohon ampun, Paduka… terjadi kesalahan: $e"));
    }
  }

  /// Proses logout
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authService.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError("Mohon ampun, Paduka… gagal logout: $e"));
    }
  }
}
