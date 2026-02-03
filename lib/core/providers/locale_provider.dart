import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/local_storage.dart';

const _storageKey = 'app_locale';
const _defaultLocale = 'ru';

const _supportedLanguageCodes = [
  'az',
  'be',
  'en',
  'hy',
  'kk',
  'ky',
  'ru',
  'ro',
  'tg',
  'uk',
  'uz',
];

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.watch(localStorageProvider);
  return LocaleNotifier(storage);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage) : super(const Locale(_defaultLocale)) {
    _load();
  }

  final LocalStorage _storage;

  Future<void> _load() async {
    final code = await _storage.getString(_storageKey);
    if (code != null && _supportedLanguageCodes.contains(code)) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (!_supportedLanguageCodes.contains(languageCode)) return;
    state = Locale(languageCode);
    await _storage.saveString(_storageKey, languageCode);
  }
}
