import 'package:countries/data/api_client.dart';
import 'package:countries/detail/domain/model/country_details.dart';

class DetailRepository {
  final ApiClient apiClient;

  DetailRepository({required this.apiClient});

  Future<CountryDetails> getCountryDetails(String cca2) async {
    print('🎯 DetailRepository.getCountryDetails called for: $cca2');
    
    try {
      final data = await apiClient.getCountryDetails(cca2);
      print('📊 API Data received: ${data.keys.toList()}');
      
      final countryDetails = CountryDetails.fromJson(data);
      print('✅ Successfully parsed CountryDetails: ${countryDetails.name}');
      
      return countryDetails;
    } catch (e) {
      print('💥 Error in DetailRepository.getCountryDetails: $e');
      print('💥 Stack trace: ${e.toString()}');
      rethrow;
    }
  }
}