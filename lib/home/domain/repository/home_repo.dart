import 'package:countries/data/api_client.dart';
import 'package:countries/home/domain/model/country_summary.dart';

class HomeRepository {
  final ApiClient apiClient;

  HomeRepository({required this.apiClient});

  Future<List<CountrySummary>> getAllCountries() async {
    try {
      final data = await apiClient.getAllCountries();
      return data.map((json) => CountrySummary.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CountrySummary>> searchCountries(String query) async {
    try {
      final data = await apiClient.searchCountries(query);
      return data.map((json) => CountrySummary.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}