import 'dart:convert';
import 'dart:math';
import 'package:countries/data/local_storage.dart';
import 'package:countries/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final http.Client client;
  final LocalStorage localStorage;

  ApiClient({
    required this.client,
    required this.localStorage,
  });

  Future<List<Map<String, dynamic>>> getAllCountries() async {
    try {
      // Try to get from cache first
      final cachedCountries = await localStorage.getCachedCountries();
      if (cachedCountries != null && cachedCountries.isNotEmpty) {
        print('📦 Using cached countries data');
        return cachedCountries;
      }
      
      print('🌐 Fetching countries from API');
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}all?fields=name,flags,population,cca2,capital'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final countries = List<Map<String, dynamic>>.from(data);
        
        // Cache the data for future use
        await localStorage.cacheCountries(countries);
        
        return countries;
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      
      // Fallback to cache even if expired
      final cachedCountries = await localStorage.getCachedCountries();
      if (cachedCountries != null && cachedCountries.isNotEmpty) {
        print('🔄 Falling back to expired cache');
        return cachedCountries;
      }
      
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> searchCountries(String query) async {
    try {
      // For search, we can use cached data if available
      final cachedCountries = await localStorage.getCachedCountries();
      if (cachedCountries != null && query.isNotEmpty) {
        // Filter cached data for search
        final filtered = cachedCountries.where((country) {
          final name = country['name']['common']?.toString().toLowerCase() ?? '';
          return name.contains(query.toLowerCase());
        }).toList();
        
        if (filtered.isNotEmpty) {
          print('🔍 Using cached data for search: $query');
          return filtered;
        }
      }
      
      // Fallback to API if no cache or no results in cache
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}name/$query?fields=name,flags,population,cca2,capital'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to search countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Search Error: $e');
      
      // Try to use cached data as fallback
      final cachedCountries = await localStorage.getCachedCountries();
      if (cachedCountries != null && query.isNotEmpty) {
        final filtered = cachedCountries.where((country) {
          final name = country['name']['common']?.toString().toLowerCase() ?? '';
          return name.contains(query.toLowerCase());
        }).toList();
        
        return filtered;
      }
      
      return [];
    }
  }

Future<Map<String, dynamic>> getCountryDetails(String cca2) async {
  print('🔍 Fetching country details for: $cca2');
  
  // Try cache first
  final cachedDetails = await localStorage.getCachedCountryDetails(cca2);
  if (cachedDetails != null && cachedDetails.isNotEmpty) {
    print('📦 Using cached details for: $cca2');
    return cachedDetails;
  }
  
  print('🌐 Fetching details from API for: $cca2');
  final uri = Uri.parse('${AppConstants.baseUrl}alpha/$cca2?fields=name,flags,population,capital,region,subregion,area,timezones');
  
  final response = await client.get(uri);
  
  if (response.statusCode == 200) {
    try {
      final dynamic decoded = json.decode(response.body);
      Map<String, dynamic> details;
      
      if (decoded is List) {
        if (decoded.isEmpty) {
          throw Exception('Country not found');
        }
        details = Map<String, dynamic>.from(decoded[0]);
      } else if (decoded is Map<String, dynamic>) {
        details = decoded;
      } else {
        throw Exception('Unexpected API response format');
      }
      
      // Cache the details
      await localStorage.cacheCountryDetails(cca2, details);
      print('💾 Cached details for: $cca2');
      
      return details;
    } catch (e) {
      print('💥 Error parsing details: $e');
      throw Exception('Failed to parse country details: $e');
    }
  } else {
    // If API fails, try to return expired cache as fallback
    final expiredCache = await _getExpiredCache(cca2);
    if (expiredCache != null) {
      print('🔄 Falling back to expired cache for: $cca2');
      return expiredCache;
    }
    
    throw Exception('Failed to load country details: ${response.statusCode}');
  }
}

// Helper to get expired cache as last resort
Future<Map<String, dynamic>?> _getExpiredCache(String cca2) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final key = 'country_detail_$cca2';
    final jsonString = prefs.getString(key);
    
    if (jsonString != null) {
      final dynamic data = json.decode(jsonString);
      if (data is Map<String, dynamic>) {
        return data;
      }
    }
  } catch (e) {
    print('Error getting expired cache: $e');
  }
  return null;
}

}