import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//observable object
//subject
//provider
class SettingsProvider extends ChangeNotifier {
  SharedPreferences? sharedPreferences;
  ThemeMode currentTheme = ThemeMode.light;
  String currentLocale = 'en';

  void changeTheme(ThemeMode newTheme) {
    if (newTheme == currentTheme) {
      return;
    }
    currentTheme = newTheme;
    notifyListeners();
    saveTheme(currentTheme);
  }

  bool isDarkEnabled() {
    return currentTheme == ThemeMode.dark;
  }

  void changeLocale(String newLocal) {
    if (newLocal == currentLocale) {
      return;
    }
    currentLocale = newLocal;
    notifyListeners();
    saveLocal(currentLocale);
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    String theme = themeMode == ThemeMode.dark ? 'Dark' : 'Light';
    await sharedPreferences?.setString('theme', theme);
  }

  String? getTheme() {
    return sharedPreferences!.getString('theme');
  }

  Future<void> loadTheme() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? oldTheme = getTheme();
    if (oldTheme != null) {
      oldTheme == 'Dark'
          ? currentTheme = ThemeMode.dark
          : currentTheme = ThemeMode.light;
    }
  }

  Future<void> saveLocal(String local) async {
    if (currentLocale == 'en') {
      local = 'English';
    } else {
      local = 'Arabic';
    }
    String localStr = local;
    await sharedPreferences?.setString('local', localStr);
  }

  String? getLocale() {
    return sharedPreferences!.getString('local');
  }

  Future<void> loadLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? oldLocal = getLocale();
    if (oldLocal != null) {
      oldLocal == 'English' ? currentLocale = 'en' : currentLocale = 'ar';
    }
  }
}
