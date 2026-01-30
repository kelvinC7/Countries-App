import 'package:flutter/material.dart';

import 'widget/favorite_icon_theme.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Colors.deepPurpleAccent,
    secondary: Colors.purpleAccent,
    surface: Color(0xFF1E1E1E),
    background: Color(0xFF121212),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Colors.deepPurpleAccent,
    unselectedItemColor: Colors.grey,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2D2D2D),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),

    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(color: Colors.grey[400]),
  ),
  iconTheme: const IconThemeData(
    color: Colors.grey, // Default icon color for dark mode
  ),
  extensions: <ThemeExtension<dynamic>>[
    // Custom colors for favorite icons in dark mode
    FavoriteIconTheme(
      favoriteColor: Colors.red[300]!, // Lighter red for dark mode
      unfavoriteColor: Colors.grey[400]!, // Lighter grey for dark mode
    ),
  ],
  useMaterial3: true,
);