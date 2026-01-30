
import 'package:countries/data/local_storage.dart';
import 'package:countries/home/domain/model/country_summary.dart';
import 'package:countries/home/domain/repository/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'favorite_state.dart';

class FavoritesController extends Cubit<FavoritesState> {
  final LocalStorage localStorage;
  final HomeRepository repository;
  
  FavoritesController({
    required this.localStorage,
    required this.repository,
  }) : super(FavoritesInitial()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favoriteCodes = await localStorage.getFavorites();
      
      if (favoriteCodes.isEmpty) {
        emit(FavoritesEmpty());
        return;
      }
      
      final allCountries = await repository.getAllCountries();
      
      final favoriteCountries = allCountries.where(
        (country) => favoriteCodes.contains(country.cca2),
      ).toList();
      
      if (favoriteCountries.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        emit(FavoritesLoaded(favorites: favoriteCountries));
      }
    } catch (e) {
      emit(FavoritesError(error: e.toString()));
    }
  }

  // Remove a favorite country
  Future<void> removeFavorite(CountrySummary country) async {
    try {
      print('🗑️ Removing favorite: ${country.name} (${country.cca2})');
      
      // Remove from local storage
      await localStorage.removeFavorite(country.cca2);
      
      // Reload favorites to update the UI
      await loadFavorites();
      
      // Show success feedback
      _showSuccessMessage('Removed ${country.name} from favorites');
    } catch (e) {
      print('💥 Error removing favorite: $e');
      emit(FavoritesError(error: 'Failed to remove favorite: $e'));
      // Re-emit current state after error
      await Future.delayed(const Duration(seconds: 2));
      await loadFavorites();
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(CountrySummary country) async {
    try {
      final isFavorite = await localStorage.isFavorite(country.cca2);
      
      if (isFavorite) {
        await removeFavorite(country);
      } else {
        await localStorage.addFavorite(country.cca2);
        await loadFavorites();
        _showSuccessMessage('Added ${country.name} to favorites');
      }
    } catch (e) {
      print('💥 Error toggling favorite: $e');
      emit(FavoritesError(error: 'Failed to update favorite: $e'));
    }
  }

  void _showSuccessMessage(String message) {
    // You can use GetX snackbar or other notification system
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Check if a country is favorite
  Future<bool> isFavorite(String countryCode) async {
    return await localStorage.isFavorite(countryCode);
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      final favorites = await localStorage.getFavorites();
      for (final code in favorites) {
        await localStorage.removeFavorite(code);
      }
      await loadFavorites();
      _showSuccessMessage('Cleared all favorites');
    } catch (e) {
      print('💥 Error clearing favorites: $e');
      emit(FavoritesError(error: 'Failed to clear favorites: $e'));
    }
  }
}