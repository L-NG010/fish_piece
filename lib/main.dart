import 'package:fish_it_kasir/bloc/auth/auth_state.dart';
import 'package:fish_it_kasir/bloc/beranda/beranda_cubit.dart';
import 'package:fish_it_kasir/bloc/pelanggan/pelanggan_cubit.dart';
import 'package:fish_it_kasir/bloc/produk/produk_cubit.dart';
import 'package:fish_it_kasir/services/auth_service.dart';
import 'package:fish_it_kasir/services/pelanggan.dart';
import 'package:fish_it_kasir/services/produk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

// Import konfigurasi
import 'config/supabase_config.dart';
import 'config/app_config.dart';

// Import Bloc
import 'bloc/language/language_cubit.dart';
import 'bloc/language/language_state.dart';
import 'bloc/auth/auth_cubit.dart';

// Import screens
import 'screens/beranda.dart';
import 'screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Inisialisasi localization
  await EasyLocalization.ensureInitialized();

  // 2️⃣ Inisialisasi Supabase (sudah include load .env)
  await SupabaseConfig.initialize();

  // 3️⃣ Jalankan aplikasi dengan pembungkus EasyLocalization dan Bloc
  runApp(
    EasyLocalization(
      supportedLocales: AppConfig.supportedLocales,
      path: AppConfig.translationPath,
      fallbackLocale: AppConfig.fallbackLocale,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LanguageCubit()),
          BlocProvider(create: (_) => AuthCubit(AuthService())),
          BlocProvider(create: (_) => BerandaCubit(ProdukService())),
          BlocProvider(create: (_) => ProdukCubit(ProdukService())),
          BlocProvider(create: (_) => PelangganCubit(PelangganService())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp(
          title: AppConfig.appTitle,
          debugShowCheckedModeBanner: AppConfig.showDebugBanner,
          theme: ThemeData(fontFamily: 'Poppins'),
          locale: state.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return const BerandaScreen();
              }
              return const LoginPage();
            },
          ),
        );
      },
    );
  }
}
