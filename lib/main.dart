import 'package:fish_it_kasir/services/auth_service.dart';
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

// Import utils
import 'utils/theme.dart';

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
          theme: AppTheme.theme,
          locale: state.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: const LoginPage(),
        );
      },
    );
  }
}
