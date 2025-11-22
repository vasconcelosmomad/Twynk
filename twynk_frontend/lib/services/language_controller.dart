import 'package:flutter/foundation.dart';

/// Supported application languages.
enum AppLanguage { pt, en }

/// Simple global controller for the current app language.
///
/// Widgets can read [LanguageController.instance.current] inside build
/// and call [LanguageController.instance.setLanguage] to change it.
///
/// The root [MaterialApp] is wrapped in a [ValueListenableBuilder]
/// listening to [language], so any change triggers a rebuild and the
/// new language is reflected wherever it is read.
class LanguageController {
  LanguageController._();

  static final LanguageController instance = LanguageController._();

  final ValueNotifier<AppLanguage> language =
      ValueNotifier<AppLanguage>(AppLanguage.pt);

  AppLanguage get current => language.value;

  void setLanguage(AppLanguage lang) {
    if (language.value == lang) return;
    language.value = lang;
  }

  void toggle() {
    setLanguage(current == AppLanguage.en ? AppLanguage.pt : AppLanguage.en);
  }
}
