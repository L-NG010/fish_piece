import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

   AuthCubit(this.authService) : super(AuthLoading()) {
    checkSession();
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final String? error = await authService.login(email, password);
      if (error != null) {
        emit(AuthError(error));
        return;
      }

      final user = authService.currentUser;
      if (user == null) {
        emit(AuthError("Login gagal, coba lagi."));
        return;
      }

      emit(AuthSuccess(user.id));
    } catch (e) {
      emit(AuthError("error: $e"));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      final String? error = await authService.logout();
      if (error != null) {
        emit(AuthError(error));
        return;
      }
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError("logout gagal: $e"));
    }
  }

  Future<void> checkSession() async {
    final user = authService.currentUser;
    if (user != null) {
      emit(AuthSuccess(user.id));
    } else {
      emit(AuthInitial());
    }
  }
}
