import 'package:bloc/bloc.dart';
import 'package:countries/home/domain/model/country_summary.dart';
import 'package:countries/home/domain/repository/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/local_storage.dart';

part 'home_state.dart';

class HomeController extends Cubit<HomeState> {
  final HomeRepository repository;
  final LocalStorage localStorage;
  
  List<CountrySummary> _allCountries = [];
  Set<String> _favorites = {};
  bool _isLoadingFromCache = false;

  HomeController({
    required this.repository,
    required this.localStorage,
  }) : super(HomeInitial()) {
    _loadCountriesWithCache();
  }

  Future<void> _loadCountriesWithCache() async {
    // Check if we have cache first
    final hasCache = await localStorage.hasValidCountriesCache();
    
    if (hasCache) {
      _isLoadingFromCache = true;
      emit(HomeLoadingFromCache());
      
      try {
        // Load from cache first (this happens instantly)
        _allCountries = await repository.getAllCountries();
        
        // Load favorites
        final favoriteCodes = await localStorage.getFavorites();
        _favorites = Set<String>.from(favoriteCodes);
        
        emit(HomeLoaded(
          countries: _allCountries,
          favorites: _favorites,
          isFromCache: true,
        ));
        
        // Then refresh from API in background
        _refreshFromApi();
      } catch (e) {
        print('Cache load failed: $e');
        // If cache fails, load from API
        await _loadFromApi();
      }
    } else {
      // No cache, load from API
      await _loadFromApi();
    }
  }

  Future<void> _loadFromApi() async {
    emit(HomeLoading());
    try {
      _allCountries = await repository.getAllCountries();
      
      final favoriteCodes = await localStorage.getFavorites();
      _favorites = Set<String>.from(favoriteCodes);
      
      emit(HomeLoaded(
        countries: _allCountries,
        favorites: _favorites,
        isFromCache: false,
      ));
    } catch (e) {
      emit(HomeError(error: e.toString()));
    }
  }

  Future<void> _refreshFromApi() async {
    try {
      final refreshedCountries = await repository.getAllCountries();
      
      // Only update if data changed
      if (_allCountries.length != refreshedCountries.length) {
        _allCountries = refreshedCountries;
        
        emit(HomeLoaded(
          countries: _allCountries,
          favorites: _favorites,
          isFromCache: false,
        ));
      }
    } catch (e) {
      print('Background refresh failed: $e');
      // Don't emit error for background refresh
    }
  }

  Future<void> loadCountries({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await _loadFromApi();
    } else {
      await _loadCountriesWithCache();
    }
  }

  Future<void> toggleFavorite(CountrySummary country) async {
    try {
      final newFavorites = Set<String>.from(_favorites);
      
      if (newFavorites.contains(country.cca2)) {
        await localStorage.removeFavorite(country.cca2);
        newFavorites.remove(country.cca2);
      } else {
        await localStorage.addFavorite(country.cca2);
        newFavorites.add(country.cca2);
      }
      
      _favorites = newFavorites;
      
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeLoaded(
          countries: currentState.countries,
          favorites: _favorites,
          isFromCache: currentState.isFromCache,
        ));
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  void searchCountries(String query) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      if (query.isEmpty) {
        emit(HomeLoaded(
          countries: _allCountries,
          favorites: _favorites,
          isFromCache: currentState.isFromCache,
        ));
      } else {
        final filtered = _allCountries.where(
          (country) => country.name.toLowerCase().contains(query.toLowerCase()),
        ).toList();
        
        emit(HomeLoaded(
          countries: filtered,
          favorites: _favorites,
          isFromCache: currentState.isFromCache,
        ));
      }
    }
  }

  bool isFavorite(String countryCode) {
    return _favorites.contains(countryCode);
  }

  // Get cache status
  bool get isLoadingFromCache => _isLoadingFromCache;
}