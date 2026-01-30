import 'package:flutter/material.dart';

class FavoriteIconTheme extends ThemeExtension<FavoriteIconTheme> {
  final Color favoriteColor;
  final Color unfavoriteColor;

  const FavoriteIconTheme({
    required this.favoriteColor,
    required this.unfavoriteColor,
  });

  @override
  ThemeExtension<FavoriteIconTheme> copyWith({
    Color? favoriteColor,
    Color? unfavoriteColor,
  }) {
    return FavoriteIconTheme(
      favoriteColor: favoriteColor ?? this.favoriteColor,
      unfavoriteColor: unfavoriteColor ?? this.unfavoriteColor,
    );
  }

  @override
  ThemeExtension<FavoriteIconTheme> lerp(
    covariant ThemeExtension<FavoriteIconTheme>? other,
    double t,
  ) {
    if (other is! FavoriteIconTheme) {
      return this;
    }
    return FavoriteIconTheme(
      favoriteColor: Color.lerp(favoriteColor, other.favoriteColor, t)!,
      unfavoriteColor: Color.lerp(unfavoriteColor, other.unfavoriteColor, t)!,
    );
  }
}