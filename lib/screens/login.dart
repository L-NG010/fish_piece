import 'package:fish_it_kasir/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import 'beranda.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    
    if (email.isEmpty) {
      _showErrorSnackBar('login.email_required'.tr());
      return;
    }
    
    if (password.isEmpty) {
      _showErrorSnackBar('login.password_required'.tr());
      return;
    }
    
    context.read<AuthCubit>().login(email, password);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Navigasi ke beranda, menggantikan halaman login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const BerandaScreen()),
          );
        } else if (state is AuthError) {
          _showErrorSnackBar(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFECECEC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', width: 250, height: 153),
              Image.asset('assets/images/FishPiece.png', width: 194, height: 60),
              const SizedBox(height: 20),

              Container(
                width: 360,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),

                    Text("login.email".tr(), style: textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "login.email_hint".tr(),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.biru,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text("login.password".tr(), style: textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: "login.password_hint".tr(),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.biru,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final loading = state is AuthLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.biru,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "login.login_button".tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}