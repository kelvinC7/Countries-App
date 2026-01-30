import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs; // Make it observable
  final String _themeKey = 'theme_mode';

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    
    if (savedTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.system;
    }
    
    update(); // Trigger update
  }

  Future<void> switchTheme(ThemeMode mode) async {
    themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString().split('.').last);
    update(); // Trigger UI update
  }

  // Toggle between light and dark
  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      switchTheme(ThemeMode.light);
    } else {
      switchTheme(ThemeMode.dark);
    }
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}