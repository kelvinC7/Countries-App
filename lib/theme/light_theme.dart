import 'package:flutter/material.dart';
import 'package:countries/utils/color_resources.dart';

import 'widget/favorite_icon_theme.dart';

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
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: ColorResources.primaryColor,
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(color: Colors.grey[600]),
  ),
  iconTheme: const IconThemeData(
    color: Colors.grey, // Default icon color
  ),
  extensions: <ThemeExtension<dynamic>>[
    // Custom colors for favorite icons
    FavoriteIconTheme(
      favoriteColor: Colors.red, // Favorite icon color
      unfavoriteColor: Colors.grey[600]!, // Unfavorite icon color
    ),
  ],
  useMaterial3: true,
);