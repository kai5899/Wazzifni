import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:locateme/Langs.dart/ar_ar.dart';
import 'package:locateme/Langs.dart/en_us.dart';

class LocalizationService extends Translations {
  GetStorage storage = GetStorage();
  // Default locale
  static final locale = Locale('en');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('en');

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'English',
    'Arabic',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en'),
    Locale('ar'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enUS, // lang/en_us.dart
        'ar': arAR, // lang/ja_jp.dart
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    storage.write("savedLang", lang);
    Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }

  Locale getSaved() {
    String savedLang = storage.read("savedLang") ?? "English";
    return _getLocaleFromLanguage(savedLang);
  }
}
