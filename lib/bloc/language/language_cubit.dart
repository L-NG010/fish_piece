import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial(const Locale('en')));

  void changeLanguage(BuildContext context, String languageCode) {
    // Change the locale using EasyLocalization
    context.setLocale(Locale(languageCode));
    
    // Emit new state to notify listeners
    emit(LanguageInitial(Locale(languageCode)));
  }
  
  Locale getCurrentLocale(BuildContext context) {
    return context.locale;
  }
}