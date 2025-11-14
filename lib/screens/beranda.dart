import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/language/language_cubit.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LanguageCubit>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr(), style: textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('greeting'.tr(), style: textTheme.bodyMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cubit.changeLanguage('id');
                context.setLocale(const Locale('id'));
              },
              child: const Text('Indonesia'),
            ),
            ElevatedButton(
              onPressed: () {
                cubit.changeLanguage('en');
                context.setLocale(const Locale('en'));
              },
              child: const Text('English'),
            ),
          ],
        ),
      ),
    );
  }
}
