import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/local_storage.dart';

const _storageKey = 'app_theme_mode';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final storage = ref.watch(localStorageProvider);
  return ThemeModeNotifier(storage);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._storage) : super(ThemeMode.light) {
    _load();
  }

  final LocalStorage _storage;

  Future<void> _load() async {
    final saved = await _storage.getString(_storageKey);
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else if (saved == 'system') {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _storage.saveString(_storageKey, value);
  }

  void toggleBetweenLightDark() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(next);
  }
}
