import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState(Locale('en')));

  void changeLanguage(String code) {
    emit(LanguageState(Locale(code)));
  }
}
