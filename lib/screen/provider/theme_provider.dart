import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeState { light, dark }

class ThemeNotifier extends StateNotifier<ThemeModeState> {
  ThemeNotifier() : super(ThemeModeState.light) {
    _loadTheme();
  }

  Future _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    state = isDarkMode ? ThemeModeState.dark : ThemeModeState.light;
  }

  Future toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeModeState.light) {
      state = ThemeModeState.dark;
      await prefs.setBool('isDarkMode', true);
    } else {
      state = ThemeModeState.light;
      await prefs.setBool('isDarkMode', false);
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeModeState>(
  (ref) {
    return ThemeNotifier();
  },
);
