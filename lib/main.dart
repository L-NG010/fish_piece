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
import 'bloc/auth/auth_cubit.dart';

// Import screens
import 'screens/beranda.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Inisialisasi localization
  await EasyLocalization.ensureInitialized();

  // 2️⃣ Inisialisasi Supabase (sudah include load .env)
  await SupabaseConfig.initialize();

  // 3️⃣ Jalankan aplikasi dengan pembungkus EasyLocalization
  runApp(
    EasyLocalization(
      supportedLocales: AppConfig.supportedLocales,
      path: AppConfig.translationPath,
      fallbackLocale: AppConfig.fallbackLocale,
      saveLocale: true, // Save the selected locale
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Current locale in main app: ${context.locale}');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthService())),
        BlocProvider(create: (_) => BerandaCubit(ProdukService())),
        BlocProvider(create: (_) => ProdukCubit(ProdukService())),
        BlocProvider(create: (_) => PelangganCubit(PelangganService())),
      ],
      child: MaterialApp(
        title: AppConfig.appTitle,
        debugShowCheckedModeBanner: AppConfig.showDebugBanner,
        theme: ThemeData(fontFamily: 'Poppins'),
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              // Use a navigator to maintain navigation stack
              return Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => const BerandaScreen(),
                    settings: settings,
                  );
                },
              );
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}