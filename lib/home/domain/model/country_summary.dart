import 'package:equatable/equatable.dart';

class CountrySummary extends Equatable {
  final String name;
  final String flag;
  final int population;
  final String cca2;
  final String capital; 

  const CountrySummary({
    required this.name,
    required this.flag,
    required this.population,
    required this.cca2,
    required this.capital, 
  });

  factory CountrySummary.fromJson(Map<String, dynamic> json) {
    return CountrySummary(
      name: json['name']['common'] ?? '',
      flag: json['flags']['png'] ?? json['flags']['svg'] ?? '',
      population: json['population'] ?? 0,
      cca2: json['cca2'] ?? '',
      capital: _parseCapital(json['capital']),
    );
  }

  // Helper method to parse capital from API response
  static String _parseCapital(dynamic capitalData) {
    if (capitalData == null) return 'N/A';
    
    if (capitalData is List) {
      if (capitalData.isEmpty) return 'N/A';
      return capitalData[0].toString();
    }
    
    if (capitalData is String) {
      return capitalData;
    }
    
    return 'N/A';
  }

  String get formattedPopulation {
    if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(1)}M';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return population.toString();
  }

  @override
  List<Object> get props => [name, cca2, capital];
}