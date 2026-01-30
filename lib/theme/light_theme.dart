import 'package:flutter/material.dart';
import 'package:countries/utils/color_resources.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorResources.primaryColor,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.grey[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[50],
    elevation: 0,
    foregroundColor: Colors.black,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: ColorResources.primaryColor,
    unselectedItemColor: Colors.grey[600],
  ),
  useMaterial3: true,
);