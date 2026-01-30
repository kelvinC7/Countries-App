import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static const String _favoritesKey = 'favorite_countries';
  static const String _countriesCacheKey = 'countries_cache';
  static const String _countriesTimestampKey = 'countries_cache_timestamp';
  static const String _countryDetailsPrefix = 'country_detail_';
  
  static const Duration _cacheDuration = Duration(hours: 24); // Cache for 24 hours
  static const Duration _detailsCacheDuration = Duration(days: 7); // Details cache for 7 days
  
  
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  // ===== FAVORITES =====
  Future<List<String>> getFavorites() async {
    final prefs = await _prefs;
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addFavorite(String countryCode) async {
    final prefs = await _prefs;
    final favorites = await getFavorites();
    if (!favorites.contains(countryCode)) {
      favorites.add(countryCode);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(String countryCode) async {
    final prefs = await _prefs;
    final favorites = await getFavorites();
    favorites.remove(countryCode);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<bool> isFavorite(String countryCode) async {
    final favorites = await getFavorites();
    return favorites.contains(countryCode);
  }

  // ===== COUNTRIES CACHE =====
  Future<void> cacheCountries(List<Map<String, dynamic>> countries) async {
    final prefs = await _prefs;
    final jsonString = json.encode(countries);
    await prefs.setString(_countriesCacheKey, jsonString);
    await prefs.setInt(_countriesTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Map<String, dynamic>>?> getCachedCountries() async {
    final prefs = await _prefs;
    
    // Check if cache exists and is not expired
    final timestamp = prefs.getInt(_countriesTimestampKey);
    if (timestamp == null) return null;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    if (now.difference(cacheTime) > _cacheDuration) {
      // Cache expired
      await clearCountriesCache();
      return null;
    }
    
    final jsonString = prefs.getString(_countriesCacheKey);
    if (jsonString == null) return null;
    
    try {
      final List<dynamic> data = json.decode(jsonString);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error parsing cached countries: $e');
      await clearCountriesCache();
      return null;
    }
  }

  Future<void> clearCountriesCache() async {
    final prefs = await _prefs;
    await prefs.remove(_countriesCacheKey);
    await prefs.remove(_countriesTimestampKey);
  }

  Future<bool> hasValidCache() async {
    final prefs = await _prefs;
    final timestamp = prefs.getInt(_countriesTimestampKey);
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime) <= _cacheDuration;
  }

  // ===== COUNTRY DETAILS CACHE =====
  Future<void> cacheCountryDetails(String countryCode, Map<String, dynamic> details) async {
    final prefs = await _prefs;
    final key = '$_countryDetailsPrefix$countryCode';
    final timestampKey = '${key}_timestamp';
    
    final jsonString = json.encode(details);
    await prefs.setString(key, jsonString);
    await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    
    print('💾 Cached details for: $countryCode');
  }

  Future<Map<String, dynamic>?> getCachedCountryDetails(String countryCode) async {
    final key = '$_countryDetailsPrefix$countryCode';
    final timestampKey = '${key}_timestamp';
    
    return await _getCachedData<Map<String, dynamic>>(
      key,
      timestampKey,
      _detailsCacheDuration,
    );
  }

  Future<void> clearCountryDetailsCache(String countryCode) async {
    final prefs = await _prefs;
    final key = '$_countryDetailsPrefix$countryCode';
    final timestampKey = '${key}_timestamp';
    
    await prefs.remove(key);
    await prefs.remove(timestampKey);
    
    print('🗑️ Cleared details cache for: $countryCode');
  }

  Future<void> clearAllCountryDetailsCache() async {
    final prefs = await _prefs;
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_countryDetailsPrefix)) {
        await prefs.remove(key);
        final timestampKey = '${key}_timestamp';
        await prefs.remove(timestampKey);
      }
    }
    
    print('🧹 Cleared all country details cache');
  }

  // ===== GENERIC CACHE HELPER =====
  Future<T?> _getCachedData<T>(String dataKey, String timestampKey, Duration duration) async {
    final prefs = await _prefs;
    
    // Check if cache exists and is not expired
    final timestamp = prefs.getInt(timestampKey);
    if (timestamp == null) return null;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    if (now.difference(cacheTime) > duration) {
      // Cache expired
      await prefs.remove(dataKey);
      await prefs.remove(timestampKey);
      return null;
    }
    
    final jsonString = prefs.getString(dataKey);
    if (jsonString == null) return null;
    
    try {
      final dynamic data = json.decode(jsonString);
      return data as T;
    } catch (e) {
      print('Error parsing cached data: $e');
      await prefs.remove(dataKey);
      await prefs.remove(timestampKey);
      return null;
    }
  }

  // ===== CACHE STATUS =====
  Future<bool> hasValidCountriesCache() async {
    return await _hasValidCache(_countriesCacheKey, _countriesTimestampKey, _cacheDuration);
  }

  Future<bool> hasValidCountryDetailsCache(String countryCode) async {
    final key = '$_countryDetailsPrefix$countryCode';
    final timestampKey = '${key}_timestamp';
    return await _hasValidCache(key, timestampKey, _detailsCacheDuration);
  }

  Future<bool> _hasValidCache(String dataKey, String timestampKey, Duration duration) async {
    final prefs = await _prefs;
    final timestamp = prefs.getInt(timestampKey);
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime) <= duration;
  }

  // ===== CLEAR ALL CACHE =====
  Future<void> clearAllCache() async {
    final prefs = await _prefs;
    await prefs.remove(_countriesCacheKey);
    await prefs.remove(_countriesTimestampKey);
    await clearAllCountryDetailsCache();
    print('🧹 Cleared all cache');
  }

  // ===== CACHE STATISTICS =====
  Future<Map<String, dynamic>> getCacheStats() async {
    final prefs = await _prefs;
    final keys = prefs.getKeys();
    
    int countryDetailsCount = 0;
    int expiredDetailsCount = 0;
    
    for (final key in keys) {
      if (key.startsWith(_countryDetailsPrefix) && !key.endsWith('_timestamp')) {
        countryDetailsCount++;
        
        final timestampKey = '${key}_timestamp';
        final timestamp = prefs.getInt(timestampKey);
        if (timestamp != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          if (DateTime.now().difference(cacheTime) > _detailsCacheDuration) {
            expiredDetailsCount++;
          }
        }
      }
    }
    
    return {
      'countryDetailsCount': countryDetailsCount,
      'expiredDetailsCount': expiredDetailsCount,
      'hasCountriesCache': await hasValidCountriesCache(),
    };
  }
}