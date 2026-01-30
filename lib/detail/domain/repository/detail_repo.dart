import 'package:countries/data/api_client.dart';
import 'package:countries/detail/domain/model/country_details.dart';

class DetailRepository {
  final ApiClient apiClient;

  DetailRepository({required this.apiClient});

  Future<CountryDetails> getCountryDetails(String cca2) async {

    
    try {
      final data = await apiClient.getCountryDetails(cca2);
    
      
      final countryDetails = CountryDetails.fromJson(data);
    
      
      return countryDetails;
    } catch (e) {
  
      rethrow;
    }
  }
}